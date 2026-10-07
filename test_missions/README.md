# MQ-9 test missions and mission checks

## Faults fixed 2026-10-07 (scheduled run)

`MQ-9 Reaper/Missions/Single/MQ-9_Reaper_Combat_Patrol.miz`, found by `tools/miz_check.py` (rows from the
DCS-AI-Frontline fault registry, `docs/DCS_MISSION_HANGS_AND_LUA_ERRORS.md`, rows #1, #14 and #24):

- route points of the Reaper flight and the insurgent convoy had `alt` but no `alt_type` (#1);
- the player MQ-9 (USA) had no `callsign` table; DCS indexes `callsign[1]` for western countries (#14).

Repaired with `python tools/miz_fix.py --no-backup <miz>` (alt_type BARO, callsign Enfield11). Not seen crashing in DCS
yet; found statically.

Not changed (outside Git, owner to decide): the ADAP copy
`C:\Dev\AutonomousDronePack\MQ-9 Reaper\MQ-9 Reaper\Missions\Single\MQ-9_Reaper_Combat_Patrol.miz` has the same two
faults (run `tools/miz_fix.py` on it), and the stale `AutonomousDronePack\DCS Content\MQ-9 Reaper` copy has no aircraft
and no `coalitions` table at all (replace it with the fixed mission or delete it).

## `MQ9_CLAUDE_TEST_AI_Flight.miz` (AI smoke test)

Built by `python tools/make_claude_test_mission.py --type MQ-9_Reaper_Flyable --alt 6000 --speed 80 --alt-band 5000 7000
--spd-band 50 125 --min-travel 25000 --payload-fuel 1300 --out test_missions/MQ9_CLAUDE_TEST_AI_Flight.miz`.
Fuel 1,300 kg is `M_fuel_max` on `main`; the EFM branch raises it to 1,814 kg.

One AI MQ-9 (skill High, no player slot) starts in the air at 6,000 m and 80 m/s over the Black Sea and flies west.
`tools/claude_test_driver.lua` (mission-start trigger) logs to `Saved Games\DCS\Logs\dcs.log`:

| Time | Check |
|---|---|
| 2 s | spawn, unit type `MQ-9_Reaper_Flyable`, airplane category, fuel > 0 |
| 120 s | altitude 5,000-7,000 m, speed 50-125 m/s, in the air |
| any time | crash / dead / ejection of the test aircraft = FAIL |
| 600 s | alive, at least 25 km from the start |

Then `[CLAUDE_TEST] SUMMARY` and `[CLAUDE_TEST] DONE`; read with
`findstr CLAUDE_TEST "%USERPROFILE%\Saved Games\DCS\Logs\dcs.log"`. AI aircraft fly DCS's simple flight model, so
this tests the mod's integration, not the BNS EFM (that is `efm/test/rig.bat` on `efm/mq9-efm-first`).

Checks before commit: `miz_check` MIZ_CHECK_PASS, `lint_mission_scripts` 0 findings, DCS `bin-mt\luae.exe` compiles
every chunk, `dry_load_mission_scripts` runs the driver with no errors (6 PASS; 3 FAIL are the dry-load stub not
moving units). Not yet run in DCS.

## Tools

- `tools/miz_check.py <miz | folder>`: must print `MIZ_CHECK_PASS` before a release.
- `tools/miz_fix.py <miz>`: repairs registry rows #1, #4, #11, #12, #14.
- Same tools as the B-2 repo (Apkallu-Industries/B-2-Spirit `tools/`); keep the copies in step.
