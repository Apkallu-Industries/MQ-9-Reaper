# MQ-9 Reaper (BNS) handoff

Repo `G:\Dev\MQ-9-Reaper`, branch `main`, GitHub Apkallu-Industries/MQ-9-Reaper. The `MQ-9 Reaper/` folder is the
source and the build; install only through the library drift guard:

    cd C:\Development\BNS-Assets-Libaray-main
    python Tools/install_drift.py --stage "MQ-9 Reaper Flyable" <scratch>/"MQ-9 Reaper Flyable"   # drops miz_extracted/
    python Tools/install_drift.py --install "MQ-9 Reaper Flyable" <scratch>/"MQ-9 Reaper Flyable"  # DCS closed

(Installing straight from the repo folder also copies `miz_extracted/`, and the drift check then reports 7
INSTALL_ONLY files: stage first.)

## RESUME HERE (2026-10-29, mq9-head)

State: **built, passing, integrated (installed), not proven in DCS.**

Owner checks, in a DCS flight in the MQ-9 (any mission with a player MQ-9):
1. F1 view: the sensor camera and the GCS HUD show as before; no cockpit geometry appears.
2. The bottom-left sensor MFD (material `mfd0`, the CWS TV channel) still shows a picture.
3. Target lock under the crosshair (RMB / Xbox X) and a Hellfire or GBU-12 release still work.
4. `dcs.log`: no `can't open` / model error for `BNS-AV-GCS-0001_DCS`.
If 2 or 3 broke, the fallback is to delete the `MainPanel = ...` line in `Cockpit/Scripts/device_init.lua`: the CWS
then uses its default cockpit again, which DCS loads from its own install (nothing shipped). Report it first.

## Clean-room cockpit fix (2026-10-29)

**Fault.** The mod shipped ED content: `Cockpit/Shape/Cockpit_Su-25T.EDM` (a hand-edited copy of ED's Su-25T
cockpit), `Cockpit_Su-25T.EDM.bak` and `Shapes/Cockpit_SU-25T.edm` (both byte-identical to ED's
`Mods/aircraft/Su-25T/Cockpit/Shape/Cockpit_Su-25T.EDM`), the `.edm.ilv` and `.edm.lua` side files,
`Cockpit/Textures/SU-25T-CPT-TEXTURES.zip`, ED's Su-25T Options page (`Options/options.dlg`, `optionsData.lua`,
`optionsDb.lua`: the Su-25T cockpit-livery chooser) and `inspect_su25t.lua` (a script reading ED's Su-25T input
profile). Also found: every exterior file (`Shapes/Mq-9_Reaper.EDM`, LOD1-4, collision + json, oblomok parts, .lods)
and `Textures/mq-9_reaper_textures.zip` were byte-identical (MD5) to ED's own MQ-9 in `Bazar/World/Shapes` and
`Bazar/World/textures`.

**What the cockpit dependency was.** `Cockpit/Scripts/device_init.lua` declares `support_for_cws` (DCS's common weapon
system: the FC3-style C++ avionics) and no `MainPanel`, so DCS loaded the CWS shell aircraft's cockpit shape, which the
mod supplied from its own `Cockpit/Shape` mount. Nothing of the mod used that geometry: the player eye
(`Views.lua` CockpitLocalPoint {7.5, -1.05, 0}, the MTS-B turret under the nose) sits about 4 m ahead of it
(`Documents/REPAIR_AND_MIGRATION_LOG_DCS_2.9.md`, failure mode 7), and the HUD is the mod's own screen-space
`ccIndicator` (`Cockpit/Scripts/GCS_HUD`, render purposes SCREENSPACE_INSIDE/OUTSIDE_COCKPIT and HUD_ONLY_VIEW, flat
colour materials, DCS's `font_dejavu_lgc_sans_22_white`). `GCS_Controller.lua` reads only `get_base_data()` and input
commands. The one avionics link is the `mfd0` render-target material in `GCS_HUD/definitions.lua` (sensor TV feed from
the CWS avionics) and the CWS target lock / weapon release; those are engine features, not shipped files, and stay.

**Facts used (sources).**
- Real aircraft: the MQ-9A has no cockpit; a pilot and a sensor operator fly it from a Ground Control Station (USAF
  fact sheet "MQ-9A Reaper", af.mil, public).
- ED's own MQ-9 (`D:\Eagle Dynamics\DCS World\CoreMods\aircraft\MQ-9 Reaper\entry.lua`) is AI-only: `declare_plugin`
  plus the unit table, no `make_flyable`, no cockpit, no mounts; its model lives in `Bazar/World/Shapes`.
- DCS loads one cockpit shape per flyable, named by `shape_name` in `Cockpit/Scripts/mainpanel_init.lua` and enabled
  by `MainPanel = {"ccMainPanel", ...}` in `device_init.lua`; this works together with `support_for_cws` in the
  installed BNS `Camel_F1_BNS` and `A6M2_BNS` and the community `f-22a` and `JAS39` mods. The community UAV mod
  `DJI-Logistic` (camera-view drone, screen-space OSD) ships a 722-byte near-empty `cockpit_DJI_Matrice_300.edm` for
  exactly this reason.
- DCS defines `WOLALIGHT_*` and `lamp_prototypes` in `Scripts/Aircrafts/_Common/Lights.lua` before aircraft Lua runs
  (the forge sandbox lacked them: that was the known dry-load stop, not a mod fault).

**Option chosen: (a) no cockpit geometry.** The mod is camera-based (sensor view + screen-space HUD), so a GCS console
station (b) is not needed for anything the mod does today. DCS still wants a cockpit shape, so the shape is the new BNS
library part **BNS-AV-GCS-0001** (P/N BN31-GCS0001-01, "SHAPE, COCKPIT, UAV GCS SENSOR VIEW, NO CREW STATION"): a root
node and one connector `PNT_SENSOR_EYE` at the cockpit origin, no mesh, material or texture (377-byte EDM).
Library search first: `library_find.py` found no empty / camera / GCS cockpit part (only crew-station hardware and
consoles). Generator `C:\Development\BNS-Assets-Libaray-main\Tools\build_av_gcs_sensor_view.py`; master
`Library/Modern/Avionics_Hardware/GCS/BNS-AV-GCS-0001.blend` + manifest; runtime
`Library/Modern/Runtime/DCS/Avionics_Hardware/GCS/BNS-AV-GCS-0001_DCS.edm` + manifest; where-used
`Docs/Where_Used/MQ-9A.json`; forge catalogue entry; `trace_gate.py --match AV-GCS` 1/1 traceable. The .blend and .edm
stay local in the library (LFS budget law); the generator rebuilds them; the EDM is committed here in the mod.
Reusable unchanged by any BNS UAV flown from a GCS (ADAP drones).

**Files.** Removed from `MQ-9 Reaper/`: the Su-25T files above, `Options/`, `inspect_su25t.lua`, the ED exterior
EDMs / lods / json and `Textures/mq-9_reaper_textures.zip`, the shipped copy of `Documents/REPAIR_AND_MIGRATION_LOG`
(the repo-root copy is the newer superset). Moved out of the shipped folder to the repo's `Documents/`:
`HOW_TO_MAKE_DCS_MODS_FLYABLE.md`, `MOD_ARCHITECTURE_AND_PIPELINE.md` (history docs that name the old shell).
Added: `Cockpit/Shape/BNS-AV-GCS-0001_DCS.edm`, `Cockpit/Scripts/mainpanel_init.lua`. Changed: `device_init.lua`
(MainPanel), `entry.lua` (no Su-25T / Textures / Shapes mounts, no Options page), comments in `MQ-9.lua`, `Views.lua`,
`ROADMAP.md`, `STATUS.md`, `Documents/FUTURE_ROADMAP.md` (both copies).

**Gate.** `G:\Dev\BNS-DCS-Forge\server\dcs_forge\audit.py` `donor_scan`: an ED module donor name (`su-25t`, `su25t`,
`su-25t-cpt`, `cockpit_su-25t`) in a shipped file name, in shipped text or inside an EDM is an ERROR, and so is any
`gv_common.BANNED` name in a file name or inside an EDM (test `test_audit_fails_on_ed_donor_files`). The library's
`Tools/forum_rules_check.py` already fails any shipped file byte-identical to ED's install. Forge sandbox now reads the
light constants from the DCS install, so the MQ-9 dry-load runs to `plugin_done`.

**Checks (2026-10-29).** Lua 5.1 syntax 36 files 0 errors; forge dry-load OK (declare_plugin, mounts, make_flyable,
add_aircraft, make_view_settings, plugin_done); forge audit on source and install PASS (0 errors; WARN no
bns/manifest.json); `forum_check_all.py --only "MQ-9 Reaper Flyable"` 34 FAIL -> 15 FAIL, none of them cockpit or
ED-shape items (list below); install_drift OK, 0 drift, 67 files hash-verified.

## Open items (not cockpit)
- Livery DDS byte-identical to ED's AI MQ-9 liveries: `'camo' scheme`, `standard France`, `standard Italy`,
  `standard UK`. Need BNS-painted replacements (or drop those liveries). The forum gate fails on them.
- `MQ-9.lua` is ED's AI MQ-9 unit table adapted (same structure and comments): rewrite from MQ-9A data as BNS work.
- Kneeboard, Theme icons, squadron patch, briefing map and the Combat Patrol .miz match files in
  `G:\Dev\AutonomousDronePack\DCS Content` (incl. the retired, third-party `B-2-Spirit-main`): confirm origin.
- Shipped build junk: `install_to_dcs.ps1`, `repack_and_deploy.ps1` (a non-guarded install path, against law 5a),
  `dcs_manifest.x86_64`.
- The ADAP copy (`G:\Dev\AutonomousDronePack\MQ-9 Reaper`) still carries the Su-25T files; it is not installed. Sync or
  retire it.
- A BNS-built MQ-9A airframe (the exterior is ED's, referenced from the DCS install).
- Option (b), a GCS operator station (pilot + sensor-operator consoles), stays a roadmap item
  (`Documents/FUTURE_ROADMAP.md`).
