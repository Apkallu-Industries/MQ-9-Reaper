"""Build an AI-driven [CLAUDE_TEST] smoke-test mission for a BNS aircraft mod.

One AI aircraft (skill High) starts in the air over the Black Sea (Caucasus) and flies a straight route west.
tools/claude_test_driver.lua, run by a mission-start trigger, logs [CLAUDE_TEST] PASS/FAIL lines to dcs.log:
spawn, unit type, airplane category, fuel, altitude and speed bands, in the air, survives, follows the route,
then a SUMMARY and DONE line. Read the result with: findstr CLAUDE_TEST "%USERPROFILE%\\Saved Games\\DCS\\Logs\\dcs.log"

Usage:
  python tools/make_claude_test_mission.py --type B-2_Spirit --alt 10000 --speed 220 --alt-band 9000 11000 \
      --spd-band 150 290 --min-travel 60000 --payload-fuel 75750 --out test_missions/B2_CLAUDE_TEST_AI_Flight.miz

The mission follows DCS_MISSION_HANGS_AND_LUA_ERRORS.md (DCS-AI-Frontline): version 23, failures / forcedOptions /
coalitions / nav_points tables, alt + alt_type on every route point, payload table, structured callsign, contiguous
1-based group indices, '/' archive paths, all text in the dictionary. It is checked by tools/miz_check.py when built.
"""
import argparse, pathlib, sys, zipfile
import lupa

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import miz_fix, miz_check


def build(a):
    T = None
    x0, y0 = -280000.0, 560000.0          # Black Sea, west of Sukhumi (Caucasus map metres)
    legs = [(x0, y0), (x0, y0 - 160000.0), (x0, y0 - 260000.0)]
    pts = []
    for i, (x, y) in enumerate(legs, 1):
        pts.append(f"""                [{i}] = {{
                    ["alt"] = {a.alt:.1f}, ["alt_type"] = "BARO", ["type"] = "Turning Point",
                    ["action"] = "Turning Point", ["speed"] = {a.speed:.1f}, ["x"] = {x:.1f}, ["y"] = {y:.1f},
                    ["ETA"] = 0, ["ETA_locked"] = {"true" if i == 1 else "false"}, ["speed_locked"] = true,
                    ["formation_template"] = "", ["name"] = "WP{i}",
                    ["task"] = {{ ["id"] = "ComboTask", ["params"] = {{ ["tasks"] = {{}} }} }},
                }},""")
    pts = "\n".join(pts)
    mission = f"""mission = {{
    ["theatre"] = "Caucasus",
    ["version"] = 23,
    ["sortie"] = "DictKey_sortie_1",
    ["descriptionText"] = "DictKey_descriptionText_2",
    ["descriptionBlueTask"] = "DictKey_descriptionBlueTask_3",
    ["descriptionRedTask"] = "DictKey_descriptionRedTask_4",
    ["descriptionNeutralsTask"] = "DictKey_descriptionNeutralsTask_5",
    ["date"] = {{ ["Year"] = 2024, ["Month"] = 6, ["Day"] = 15 }},
    ["start_time"] = 36000,
    ["requiredModules"] = {{}},
    ["pictureFileNameB"] = {{}}, ["pictureFileNameR"] = {{}}, ["pictureFileNameServer"] = {{}},
    ["maxDictId"] = 6, ["currentKey"] = 10, ["maxKey"] = 20000,
    ["failures"] = {{}}, ["forcedOptions"] = {{}}, ["resourceCounter"] = {{}}, ["goals"] = {{}},
    ["map"] = {{ ["centerX"] = {x0:.1f}, ["centerY"] = {y0 - 130000.0:.1f}, ["zoom"] = 300000 }},
    ["triggers"] = {{ ["zones"] = {{}} }},
    ["weather"] = {{
        ["atmosphere_type"] = 0, ["type_weather"] = 0, ["name"] = "Winter, clean sky",
        ["wind"] = {{ ["atGround"] = {{ ["speed"] = 0, ["dir"] = 0 }}, ["at2000"] = {{ ["speed"] = 0, ["dir"] = 0 }},
                     ["at8000"] = {{ ["speed"] = 0, ["dir"] = 0 }} }},
        ["turbulence"] = {{ ["atGround"] = 0, ["at2000"] = 0, ["at8000"] = 0 }},
        ["groundTurbulence"] = 0, ["enable_fog"] = false, ["enable_dust"] = false, ["dust_density"] = 0,
        ["fog"] = {{ ["thickness"] = 0, ["visibility"] = 0, ["density"] = 0 }},
        ["visibility"] = {{ ["distance"] = 80000 }}, ["qnh"] = 760, ["cyclones"] = {{}},
        ["season"] = {{ ["iseason"] = 1, ["temperature"] = 15 }},
        ["clouds"] = {{ ["thickness"] = 200, ["density"] = 0, ["base"] = 4000, ["iprecptns"] = 0 }},
    }},
    ["trig"] = {{
        ["actions"] = {{ [1] = "a_do_script_file(getValueResourceByKey(\\"ResKey_ClaudeTest\\"));" }},
        ["conditions"] = {{ [1] = "return(true)" }},
        ["funcStartup"] = {{ [1] = "if mission.trig.conditions[1]() then mission.trig.actions[1]() end" }},
        ["func"] = {{}}, ["flag"] = {{ [1] = true }}, ["events"] = {{}}, ["custom"] = {{}},
        ["customStartup"] = {{
            [1] = "for i,t in ipairs(mission.trig.conditions) do mission.trig.conditions[i]=loadstring(t) end",
            [2] = "for i,t in ipairs(mission.trig.actions) do mission.trig.actions[i]=loadstring(t) end",
        }},
    }},
    ["trigrules"] = {{
        [1] = {{
            ["predicate"] = "triggerStart", ["rules"] = {{}}, ["eventlist"] = "", ["comment"] = "CLAUDE_TEST driver",
            ["actions"] = {{ [1] = {{ ["predicate"] = "a_do_script_file", ["file"] = "ResKey_ClaudeTest",
                                     ["ai_task"] = {{ [1] = "", [2] = "" }} }} }},
        }},
    }},
    ["result"] = {{ ["total"] = 0,
        ["offline"] = {{ ["conditions"] = {{}}, ["actions"] = {{}}, ["func"] = {{}} }},
        ["blue"] = {{ ["conditions"] = {{}}, ["actions"] = {{}}, ["func"] = {{}} }},
        ["red"] = {{ ["conditions"] = {{}}, ["actions"] = {{}}, ["func"] = {{}} }} }},
    ["coalitions"] = {{ ["blue"] = {{ [1] = 2 }}, ["red"] = {{ [1] = 0 }}, ["neutrals"] = {{}} }},
    ["coalition"] = {{
        ["blue"] = {{
            ["name"] = "blue", ["bullseye"] = {{ ["x"] = {x0:.1f}, ["y"] = {y0:.1f} }}, ["nav_points"] = {{}},
            ["country"] = {{ [1] = {{ ["id"] = 2, ["name"] = "USA",
                ["plane"] = {{ ["group"] = {{ [1] = {{
                    ["groupId"] = 1, ["name"] = "{a.group}", ["task"] = "Nothing", ["x"] = {x0:.1f}, ["y"] = {y0:.1f},
                    ["start_time"] = 0, ["hidden"] = false, ["uncontrolled"] = false, ["communication"] = true,
                    ["frequency"] = 251, ["modulation"] = 0, ["radioSet"] = false, ["tasks"] = {{}},
                    ["route"] = {{ ["points"] = {{
{pts}
                    }} }},
                    ["units"] = {{ [1] = {{
                        ["unitId"] = 1, ["name"] = "{a.group}-1", ["type"] = "{a.type}", ["skill"] = "High",
                        ["x"] = {x0:.1f}, ["y"] = {y0:.1f}, ["alt"] = {a.alt:.1f}, ["alt_type"] = "BARO",
                        ["speed"] = {a.speed:.1f}, ["heading"] = -1.5707963, ["psi"] = 1.5707963,
                        ["livery_id"] = "default", ["onboard_num"] = "010",
                        ["callsign"] = {{ [1] = 1, [2] = 1, [3] = 1, ["name"] = "Enfield11" }},
                        ["payload"] = {{ ["pylons"] = {{}}, ["fuel"] = {a.payload_fuel}, ["flare"] = 0,
                                        ["chaff"] = 0, ["gun"] = 100 }},
                    }} }},
                }} }} }},
            }} }},
        }},
        ["red"] = {{ ["name"] = "red", ["bullseye"] = {{ ["x"] = 0, ["y"] = 0 }}, ["nav_points"] = {{}},
                    ["country"] = {{ [1] = {{ ["id"] = 0, ["name"] = "Russia" }} }} }},
        ["neutrals"] = {{ ["name"] = "neutrals", ["bullseye"] = {{ ["x"] = 0, ["y"] = 0 }}, ["nav_points"] = {{}},
                         ["country"] = {{}} }},
    }},
}}
"""
    L = lupa.LuaRuntime(unpack_returned_tuples=True)
    L.execute(mission)
    mission = "mission = \n" + miz_fix.ser(L.globals()["mission"]) + "\n"
    q = miz_fix.lua_str
    brief = (f"[CLAUDE_TEST] AI smoke test for {a.type}. One AI aircraft starts at {a.alt:.0f} m, "
             f"{a.speed:.0f} m/s, and flies west over the Black Sea. The driver logs [CLAUDE_TEST] PASS/FAIL lines "
             f"to dcs.log (spawn, type, fuel, altitude {a.alt_band[0]}..{a.alt_band[1]} m and speed "
             f"{a.spd_band[0]}..{a.spd_band[1]} m/s at {a.t_check} s, survives and covers {a.min_travel} m by "
             f"{a.t_end} s), then SUMMARY and DONE. Watch from F10 / F2; no player slot.")
    dictionary = ("dictionary = \n{\n"
                  f'    ["DictKey_sortie_1"] = {q("CLAUDE_TEST " + a.type + " AI flight")},\n'
                  f'    ["DictKey_descriptionText_2"] = {q(brief)},\n'
                  f'    ["DictKey_descriptionBlueTask_3"] = {q("Fly the route.")},\n'
                  '    ["DictKey_descriptionRedTask_4"] = "",\n'
                  '    ["DictKey_descriptionNeutralsTask_5"] = "",\n}\n')
    cfg = (f"CLAUDE_TEST_CFG = {{ group = {q(a.group)}, type = {q(a.type)}, alt_min = {a.alt_band[0]}, "
           f"alt_max = {a.alt_band[1]}, spd_min = {a.spd_band[0]}, spd_max = {a.spd_band[1]}, "
           f"t_check = {a.t_check}, t_end = {a.t_end}, min_travel = {a.min_travel} }}\n")
    driver = cfg + (HERE / "claude_test_driver.lua").read_text(encoding="utf-8")
    out = pathlib.Path(a.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("mission", mission.encode("utf-8"))
        z.writestr("options", b'options = \n{\n    ["difficulty"] = \n    {\n        ["externalViews"] = true,\n'
                              b'        ["map"] = true,\n    },\n}\n')
        z.writestr("theatre", b"Caucasus")
        z.writestr("warehouses", b'warehouses = \n{\n    ["airports"] = {},\n    ["warehouses"] = {},\n}\n')
        z.writestr("l10n/DEFAULT/dictionary", dictionary.encode("utf-8"))
        z.writestr("l10n/DEFAULT/mapResource",
                   b'mapResource = \n{\n    ["ResKey_ClaudeTest"] = "claude_test_driver.lua",\n}\n')
        z.writestr("l10n/DEFAULT/claude_test_driver.lua", driver.encode("utf-8"))
    res = miz_check.check(out)
    errs = [m for s, m in res if s == "ERROR"]
    print(("built " if not errs else "BUILT WITH ERRORS ") + str(out))
    for s, m in res:
        print("   ", s, m)
    return 1 if errs else 0


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--type", required=True)
    p.add_argument("--group", default="CLAUDE_TEST_AI")
    p.add_argument("--alt", type=float, required=True)
    p.add_argument("--speed", type=float, required=True)
    p.add_argument("--alt-band", type=int, nargs=2, required=True)
    p.add_argument("--spd-band", type=int, nargs=2, required=True)
    p.add_argument("--min-travel", type=int, required=True)
    p.add_argument("--payload-fuel", type=float, required=True)
    p.add_argument("--t-check", type=int, default=120)
    p.add_argument("--t-end", type=int, default=600)
    p.add_argument("--out", required=True)
    sys.exit(build(p.parse_args()))
