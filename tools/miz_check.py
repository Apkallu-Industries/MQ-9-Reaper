"""Static .miz checker for the registry faults in DCS_MISSION_HANGS_AND_LUA_ERRORS.md (DCS-AI-Frontline docs).

Usage: python miz_check.py <file.miz | folder> [...]
Prints one line per finding and MIZ_CHECK_PASS / MIZ_CHECK_FAIL. Needs lupa (pip install lupa).

Registry rows checked: #1 waypoint alt / alt_type, #2 failures table, #3 version, #4 coalition nav_points,
#5 / #21 aircraft payload is a table with fuel, #8 zip entries use '/', #11 root coalitions table,
#12 static groups have a route, #13 mission / options / warehouses / dictionary compile, #14 structured callsign
for western countries (and present at all), #22 numeric parking on ramp starts, #23 contiguous group indices.
Also: every DictKey_ / ResKey_ the mission uses is defined, and every resource file is in the archive.
"""
import sys, zipfile, re, pathlib
import lupa

WESTERN = {2: "USA", 4: "UK", 5: "France", 6: "Germany", 8: "Canada", 9: "Spain", 10: "The Netherlands",
           11: "Belgium", 12: "Norway", 13: "Denmark", 15: "Israel", 20: "Italy", 21: "Australia"}
# Aircraft too wide for DCS taxi routing: runway and parking starts never spawn (B-2 troubleshooting guide #008).
WIDE = {"B-2_Spirit"}


def check(path):
    out = []
    err = lambda m: out.append(("ERROR", m))
    warn = lambda m: out.append(("WARN", m))
    z = zipfile.ZipFile(path)
    names = z.namelist()
    for n in names:
        if "\\" in n:
            err(f"#8 zip entry with backslash: {n}")
    L = lupa.LuaRuntime(unpack_returned_tuples=True)
    tables = {}
    for entry, var in (("mission", "mission"), ("options", "options"), ("warehouses", "warehouses"),
                       ("l10n/DEFAULT/dictionary", "dictionary"), ("l10n/DEFAULT/mapResource", "mapResource"),
                       ("theatre", None)):
        if entry not in names:
            (err if entry in ("mission", "l10n/DEFAULT/dictionary", "warehouses", "options") else warn)(
                f"missing archive entry {entry}")
            continue
        src = z.read(entry).decode("utf-8", "replace")
        if var is None:
            continue
        try:
            L.execute(src)
            tables[var] = L.globals()[var]
        except Exception as e:
            err(f"#13 {entry} does not compile/run: {str(e)[:160]}")
    m = tables.get("mission")
    if m is None:
        return out
    if not isinstance(m["version"], (int, float)):
        err("#3 mission.version missing")
    for k in ("failures", "forcedOptions"):
        if m[k] is None:
            err(f"#2 mission.{k} missing")
    if m["coalitions"] is None:
        err("#11 root ['coalitions'] table missing")
    dic = tables.get("dictionary")
    res = tables.get("mapResource")
    mtext = z.read("mission").decode("utf-8", "replace")
    for key in sorted(set(re.findall(r'"(DictKey_[A-Za-z0-9_]+)"', mtext))):
        if dic is None or dic[key] is None:
            err(f"dictionary key {key} used but not defined")
    for key in sorted(set(re.findall(r'(ResKey_[A-Za-z0-9_]+)', mtext))):
        if res is None or res[key] is None:
            err(f"resource key {key} used but not in mapResource")
        elif not any(n.endswith("/" + res[key]) for n in names):
            err(f"resource {key} -> {res[key]} not in the archive")
    co = m["coalition"]
    if co is None:
        err("mission.coalition missing")
        return out
    for side in ("blue", "red", "neutrals"):
        c = co[side]
        if c is None:
            warn(f"coalition {side} missing")
            continue
        if c["nav_points"] is None:
            err(f"#4 coalition {side} has no nav_points")
        countries = c["country"] or {}
        for ci in countries:
            ctry = countries[ci]
            cid = ctry["id"]
            for cat in ("plane", "helicopter", "vehicle", "ship", "static"):
                if ctry[cat] is None or ctry[cat]["group"] is None:
                    continue
                groups = ctry[cat]["group"]
                keys = sorted(k for k in groups)
                if keys != list(range(1, len(keys) + 1)):
                    err(f"#23 {side}/{ctry['name']}/{cat} group indices not contiguous: {keys}")
                for gk in keys:
                    g = groups[gk]
                    gname = g["name"]
                    pts = g["route"] and g["route"]["points"]
                    if pts is None:
                        err(f"#12 {cat} group {gname} has no route.points")
                        pts = L.table()
                    for pk in pts:
                        p = pts[pk]
                        if cat == "static":
                            continue
                        if not isinstance(p["alt"], (int, float)):
                            err(f"#1 {cat} group {gname} point {pk} has no alt")
                        if p["alt_type"] is None:
                            err(f"#1 {cat} group {gname} point {pk} has no alt_type")
                    if cat != "static" and (g["x"] is None or g["y"] is None):
                        warn(f"{cat} group {gname} has no group x / y")
                    if cat in ("plane", "helicopter"):
                        p1 = pts[1]
                        ramp = p1 is not None and str(p1["type"]).startswith("TakeOffParking")
                        units = g["units"]
                        for uk in units:
                            u = units[uk]
                            if (u["type"] in WIDE and p1 is not None and str(p1["type"]).startswith("TakeOff")
                                    and not str(p1["type"]).startswith("TakeOffGround")):
                                err(f"B-2 guide #008 {gname}/{u['name']}: {u['type']} with a {p1['type']} start "
                                    f"(no taxi path for its span; use TakeOffGroundHot)")
                            pl = u["payload"]
                            if pl is None:
                                err(f"#5 {gname}/{u['name']} has no payload")
                            elif not lupa.lua_type(pl) == "table":
                                err(f"#21 {gname}/{u['name']} payload is not a table")
                            elif pl["fuel"] is None:
                                err(f"#5 {gname}/{u['name']} payload has no fuel")
                            cs = u["callsign"]
                            if cs is None:
                                err(f"#14 {gname}/{u['name']} has no callsign")
                            elif cid in WESTERN and lupa.lua_type(cs) != "table":
                                err(f"#14 {gname}/{u['name']} numeric callsign for {WESTERN[cid]}")
                            if ramp and not isinstance(u["parking"], (int, float)) and not (
                                    isinstance(u["parking"], str) and u["parking"].isdigit()):
                                err(f"#22 {gname}/{u['name']} ramp start without numeric parking")
                            if ramp and u["parking_id"] is not None and p1["parking_id"] is None:
                                warn(f"#22 {gname} route point 1 has no parking_id")
    return out


def main(argv):
    files = []
    for a in argv:
        p = pathlib.Path(a)
        files += sorted(p.rglob("*.miz")) if p.is_dir() else [p]
    bad = 0
    for f in files:
        res = check(f)
        e = sum(1 for s, _ in res if s == "ERROR")
        bad += e
        print(f"{'FAIL' if e else 'ok  '} {f}")
        for s, msg in res:
            print(f"      {s} {msg}")
    print("MIZ_CHECK_FAIL" if bad else "MIZ_CHECK_PASS", f"- {len(files)} missions, {bad} errors")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
