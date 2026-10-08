"""Repair the DCS mission-load faults that tools/miz_check.py reports, in place (a .bak copy is kept next to the file
unless --no-backup).

Usage: python tools/miz_fix.py [--no-backup] [--ground-start=<unit type>[:<heading deg>]] <file.miz> [...]

--ground-start turns runway / parking starts of that unit type into "From Ground Area Hot" at the same point
(B-2 troubleshooting guide #008: a 52 m span finds no taxi path, so the slot never spawns).

Fixes (row numbers from DCS_MISSION_HANGS_AND_LUA_ERRORS.md in DCS-AI-Frontline):
  #1  route points without alt / alt_type get alt 0 (ground) and alt_type "BARO"
  #4  coalitions without nav_points get an empty table; a missing neutrals coalition is added
  #11 a missing root ["coalitions"] roster is built from the countries each side uses
  #12 ground / static groups without a route get one point at the group (or first unit) position
  #14 aircraft units without a callsign get one (structured for western countries, numeric otherwise)
The mission table is re-serialised (key order is not kept; DCS does not depend on it). Other archive entries are
copied unchanged.
"""
import sys, zipfile, shutil, pathlib, math
import lupa

WESTERN = {2, 4, 5, 6, 8, 9, 10, 11, 12, 13, 15, 20, 21}


def lua_str(s):
    out = ['"']
    for ch in s:
        o = ord(ch)
        if ch == "\\": out.append("\\\\")
        elif ch == '"': out.append('\\"')
        elif ch == "\n": out.append("\\n")
        elif ch == "\r": out.append("\\r")
        elif ch == "\t": out.append("\\t")
        elif o < 32: out.append("\\%03d" % o)
        else: out.append(ch)
    out.append('"')
    return "".join(out)


def lua_num(v):
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, int):
        return str(v)
    if not math.isfinite(v):
        raise ValueError(f"non-finite number {v}")
    return repr(float(v))


def ser(v, ind=0):
    pad = "    " * ind
    if v is None:
        return "nil"
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        return lua_num(v)
    if isinstance(v, str):
        return lua_str(v)
    if lupa.lua_type(v) == "table":
        keys = list(v.keys())
        nums = sorted(k for k in keys if isinstance(k, (int, float)) and not isinstance(k, bool))
        strs = sorted(k for k in keys if isinstance(k, str))
        if not keys:
            return "{}"
        lines = ["{"]
        for k in strs:
            lines.append(f"{pad}    [{lua_str(k)}] = {ser(v[k], ind + 1)},")
        for k in nums:
            lines.append(f"{pad}    [{lua_num(k)}] = {ser(v[k], ind + 1)},")
        lines.append(pad + "}")
        return "\n".join(lines)
    raise TypeError(f"cannot serialise {type(v)}")


def fix_mission(L, m):
    log = []
    T = L.table
    co = m["coalition"]
    if co["neutrals"] is None:
        co["neutrals"] = T(name="neutrals", country=T(), nav_points=T(), bullseye=T(x=0, y=0))
        log.append("added neutrals coalition")
    roster = {}
    for side in ("blue", "red", "neutrals"):
        c = co[side]
        if c is None:
            continue
        if c["nav_points"] is None:
            c["nav_points"] = T(); log.append(f"#4 {side}.nav_points")
        if c["bullseye"] is None:
            c["bullseye"] = T(x=0, y=0)
        countries = c["country"] or T()
        roster[side] = [countries[i]["id"] for i in sorted(countries.keys())]
        for ci in countries:
            ctry = countries[ci]
            cid = ctry["id"]
            n_cs = 0
            for cat in ("plane", "helicopter", "vehicle", "ship", "static"):
                if ctry[cat] is None or ctry[cat]["group"] is None:
                    continue
                groups = ctry[cat]["group"]
                for gk in sorted(groups.keys()):
                    g = groups[gk]
                    u1 = g["units"] and g["units"][1]
                    if g["x"] is None and u1 is not None:
                        g["x"], g["y"] = u1["x"], u1["y"]; log.append(f"group x/y {g['name']}")
                    if g["route"] is None or g["route"]["points"] is None:
                        if cat in ("plane", "helicopter"):
                            log.append(f"UNFIXED aircraft group without route {g['name']}")
                            continue
                        pt = T(alt=0, alt_type="BARO", type="Turning Point" if cat != "static" else "",
                               action="Off Road" if cat == "vehicle" else ("" if cat == "static" else "Turning Point"),
                               speed=0, x=g["x"], y=g["y"], ETA=0, ETA_locked=True, speed_locked=True,
                               formation_template="",
                               task=T(id="ComboTask", params=T(tasks=T())))
                        g["route"] = T(points=T(pt), spans=T())
                        log.append(f"#12 route for {cat} group {g['name']}")
                    pts = g["route"]["points"]
                    for pk in sorted(pts.keys()):
                        p = pts[pk]
                        if cat == "static":
                            continue
                        if p["alt"] is None:
                            p["alt"] = 0; log.append(f"#1 alt {g['name']}/{pk}")
                        if p["alt_type"] is None:
                            p["alt_type"] = "BARO"; log.append(f"#1 alt_type {g['name']}/{pk}")
                    if cat in ("plane", "helicopter"):
                        for uk in sorted(g["units"].keys()):
                            u = g["units"][uk]
                            if u["callsign"] is None:
                                n_cs += 1
                                if cid in WESTERN:
                                    u["callsign"] = T(**{"name": f"Enfield1{n_cs}"})
                                    u["callsign"][1], u["callsign"][2], u["callsign"][3] = 1, 1, n_cs
                                else:
                                    u["callsign"] = 100 + n_cs
                                log.append(f"#14 callsign {u['name']}")
    if m["coalitions"] is None:
        cs = T()
        for side in ("blue", "red", "neutrals"):
            cs[side] = T(*roster.get(side, []))
        m["coalitions"] = cs
        log.append("#11 coalitions roster " + str(roster))
    return log


def ground_start(L, m, unit_type, heading_deg=None):
    """Turn runway / parking starts of `unit_type` into "From Ground Area Hot" at the same point (B-2 guide #008:
    a 52 m span finds no taxi path, so the slot never spawns). Optional heading for the start point."""
    log = []
    for side in ("blue", "red"):
        c = m["coalition"][side]
        for ci in (c["country"] or {}):
            ctry = c["country"][ci]
            if ctry["plane"] is None:
                continue
            for gk in ctry["plane"]["group"]:
                g = ctry["plane"]["group"][gk]
                if not any(g["units"][k]["type"] == unit_type for k in g["units"]):
                    continue
                p1 = g["route"]["points"][1]
                if not str(p1["type"]).startswith("TakeOff") or str(p1["type"]).startswith("TakeOffGround"):
                    continue
                old = p1["type"]
                p1["type"], p1["action"] = "TakeOffGroundHot", "From Ground Area Hot"
                for k in ("airdromeId", "helipadId", "linkUnit"):
                    p1[k] = None
                for uk in g["units"]:
                    u = g["units"][uk]
                    u["parking"] = None; u["parking_id"] = None
                    if heading_deg is not None:
                        u["heading"] = math.radians(heading_deg); u["psi"] = -math.radians(heading_deg)
                log.append(f"#008 {g['name']}: {old} -> TakeOffGroundHot at ({p1['x']:.0f}, {p1['y']:.0f})"
                           + (f", heading {heading_deg} deg" if heading_deg is not None else ""))
    return log


def fix_file(path, backup=True, ground=None):
    path = pathlib.Path(path)
    z = zipfile.ZipFile(path)
    entries = [(i, z.read(i.filename)) for i in z.infolist()]
    z.close()
    L = lupa.LuaRuntime(unpack_returned_tuples=True)
    src = dict((i.filename, d) for i, d in entries)["mission"].decode("utf-8")
    L.execute(src)
    m = L.globals()["mission"]
    log = fix_mission(L, m)
    if ground:
        log += ground_start(L, m, ground[0], ground[1])
    if not [x for x in log if not x.startswith("UNFIXED")]:
        print(f"unchanged {path}"); [print("   ", x) for x in log]
        return
    new = "mission = \n" + ser(m) + "\n"
    L2 = lupa.LuaRuntime()
    L2.execute(new)   # must load back
    if backup:
        shutil.copy2(path, str(path) + ".bak")
    tmp = path.with_suffix(".miz.tmp")
    with zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as out:
        for info, data in entries:
            if info.filename == "mission":
                data = new.encode("utf-8")
            out.writestr(info.filename.replace("\\", "/"), data)
    tmp.replace(path)
    print(f"fixed {path}")
    for x in log:
        print("   ", x)


if __name__ == "__main__":
    args = sys.argv[1:]
    backup = "--no-backup" not in args
    ground = None
    for x in args:
        if x.startswith("--ground-start="):   # --ground-start=B-2_Spirit[:heading_deg]
            t, _, h = x.split("=", 1)[1].partition(":")
            ground = (t, float(h) if h else None)
    for a in [x for x in args if not x.startswith("--")]:
        fix_file(a, backup, ground)
