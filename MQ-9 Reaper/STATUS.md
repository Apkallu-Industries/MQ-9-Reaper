# MQ-9 Reaper — Build Status & Paper Trail

_Living tracker of what is fixed, where, and what is still open. Last updated: **2026-09-14**._

There are **two on-disk copies** of the mod — keep both in sync:
- **Saved Games** (what DCS actually loads): `C:\Users\danym\Saved Games\DCS\Mods\aircraft\MQ-9 Reaper`
- **Dev source** (canonical): `c:\Dev\AutonomousDronePack\MQ-9 Reaper\MQ-9 Reaper`
- **GitHub**: `github.com/Apkallu-Industries/MQ-9-Reaper` (`main`)

---

## ✅ Done & verified

| Fix | Why | Saved Games | Dev | GitHub |
|:--|:--|:--:|:--:|:--:|
| **entry.lua registration order** — `make_flyable` **before** `make_view_settings` | Old order aborted `entry.lua` before `plugin_done()` → "installed but not in ME" | ✅ | ✅ | ⬜ not pushed |
| **Mission spawn speed 65 → 90 m/s** (`MQ-9_Reaper_Combat_Patrol.miz`) | Loaded jet air-started below stall → sank on spawn | ✅ | ✅ | ✅ |
| **Branding** — Yutani Industries + motto (entry.lua `developerName`, README) | Studio identity | ✅ | ⬜ verify | ✅ |
| **README + hero banner** (432d patch) | Presentation | ✅ | ⬜ verify | ✅ |
| **ROADMAP** — North Star GCS container section | Paid flagship on record | ✅ | ⬜ verify | ✅ |
| **Acceptance test card** (`Documents/`) | Flight-test plan | ✅ | ⬜ verify | ✅ |
| **ADAP sync (2026-10-08 run, branch `fix/mq9-adap-sync-2026-10-08`)**: repo brought level with the ADAP canonical copy: internal fuel `M_fuel_max` 1300 -> 1814 kg (4,000 lb, USAF MQ-9A fact sheet); GCS menu Frontline telemetry (`[FRONTLINE_EVENT]` type `BNS_MQ9`) in `reaper_gcs_menu.lua` and in the Combat Patrol .miz; repo copy's UTF-8 BOM and mangled em dash in the menu header gone | Repo had drifted behind ADAP (the fuel fix lived only on the EFM branch, telemetry only in ADAP) | n/a | ✅ (source) | PR |
| **Credit: `developerName` = "Blacknet Systems"** (owner 2026-10-08: every BNS mod credits BNS; Weyland-Yutani own BNS in the lore only. Reverses the earlier "Eagle Dynamics / Yutani Industries" credit) | Owner rule | ✅ installed | ✅ 2026-10-08 | PR #5 |
| **B-2: disabled duplicate mod** (`_B-2_Spirit_CONFLICT_BACKUP/entry.lua` → `.disabled`) | Two B-2 plugins → B-2 dropped from ME | ✅ (parent folder) | n/a | n/a |

---

## ⬜ Open — needs testing or a decision

| Item | Blocking? | Owner | Notes |
|:--|:--:|:--|:--|
| **MQ-9 flyable check** | 🔴 **YES** | Yutani | In ME, select MQ-9 → does **Skill** offer **Player/Client**, or AI-only? Decides if it's registered-but-not-flyable. |
| **Spawn-hold flight test** (§A) | — | Yutani | Confirm holds 2,500 m off spawn now. |
| **Weapon kills** (§C) — Hellfire + GBU-12 | — | Yutani | Last Phase-1 item. Laser-to-impact, end to end. |
| **Shkval thermal probe** | — | Yutani | Hot vehicle + IR channel: real heat or legacy low-light? Decides sensor path. |
| **Push entry.lua fix to GitHub** | — | Yutani/Wayland | Reorder fix is local only; push from ONE canonical repo. |
| **Consolidate two-repo pipeline** | — | Wayland | Make Dev canonical; deploy to Saved Games by copy, not a 2nd pushing repo. |
| **BNS EFM switch-on** (`BNS_MQ9_USE_EFM`, branch `efm/mq9-efm-first`, PR #2) | — | Owner | 2026-10-08: the EFM now flies the A (62) / H (59) autopilot keys the shell used to; rig `SIM_TEST_PASS` (11 checks). Still off by default; needs a DCS flight with it on. The ADAP copy has no EFM yet. |
| **F10 GCS menu titles too long** | — | Owner | 2026-10-08 dry-load: 42 of 46 GCS menu titles are over 35 characters and wrap onto two lines in DCS (Frontline registry #20). Not changed: the wording is the owner's; shorten when convenient. |

Checks on 2026-10-08 (branch `fix/mq9-adap-sync-2026-10-08`): `tools/miz_check.py` MIZ_CHECK_PASS (Combat Patrol + CLAUDE_TEST); dcs-frontline `lint_mission_scripts` 0 errors; `dry_load_mission_scripts` on a scratch copy with the T+1 s menu trigger moved to mission start: `reaper_gcs_menu.lua` loads, 46 F10 entries, telemetry line logged, no errors. The stock dry-load does not run the T+1 s trigger (it is not a mission-start trigger), so it reports 0 scripts on the shipped mission; that is expected.

Run 62 (2026-10-15, branch `fix/mq9-miz-extracted-sync-2026-10-15`):
- EFM rebuilt against `D:\Eagle Dynamics\DCS World\API` with MSVC (`efm\build.bat`): BUILD_OK; rig `efm\test\rig.bat` SIM_TEST_PASS, 0 failed. `entry.lua` registers `BNS_MQ9_EFM.dll` (binaries + FM[2]) with `BNS_MQ9_USE_EFM = true`.
- ADAP canonical copy (`G:\Dev\AutonomousDronePack\MQ-9 Reaper\MQ-9 Reaper`) brought level with this repo: EFM registration in `entry.lua`, `FM\MQ9_FM.lua`, `bin\BNS_MQ9_EFM.dll` (rig-tested build) and the `BNS MQ-9 Reaper` display name. Originals kept in `AutonomousDronePack\_backups\run62_2026-10-15_mq9`. All three Lua files compile with DCS `luae.exe`.
- This repo's `miz_extracted/l10n/DEFAULT/reaper_gcs_menu.lua` was the pre-telemetry copy; now identical to the shipped `reaper_gcs_menu.lua` (and to ADAP).
- Still different between the copies: `fires_pos` (ADAP has the wing-slot fix; this repo gets it with PR #6, waiting on the owner).

Run 64 (2026-10-16, branch `docs/mq9-run64-notes-2026-10-16`):
- Start state: no open PRs; #6 (fires_pos) and #8 (run 62) merged, so the fires_pos difference above is closed.
- EFM on main (129c73f): `efm\build.bat` BUILD_OK (MSVC, `D:\Eagle Dynamics\DCS World\API`); `efm\test\rig.bat` SIM_TEST_PASS, 0 failed. Rebuilt DLL not committed (source unchanged). `entry.lua` registers `BNS_MQ9_EFM.dll` (binaries + FM[2]), `BNS_MQ9_USE_EFM = true`.
- ADAP copy compared file by file (liveries, EDM and DDS excluded): every Lua and input file is identical apart from line endings; only `STATUS.md` (notes) and `bin\BNS_MQ9_EFM.dll` differ. The DLL is the run 62 build of the same source (MSVC stamps the link time, so builds never match byte for byte). Nothing to sync.
- Owner item unchanged: `developerName` "Blacknet Systems" (owner rule 2026-10-08) vs the routine brief's "Eagle Dynamics / Yutani Industries".

---

## 🧭 Known context / gotchas
- **Two copies + one GitHub remote** = clobber risk. Fix a bug in **both** until the pipeline is consolidated.
- **Registration order rule** (all homebrew flyables): `make_flyable` must run **before** `make_view_settings`, or the plugin aborts before `plugin_done()` and the aircraft is installed-but-missing-from-ME.
- **mapclasskey** is a shared MIL-STD-2525 symbol class — duplicates are **fine**, not a conflict.
- **F10 GCS menu is cosmetic** (info overlay only): real weapon employment + laser is the Su-25T cockpit chain.

---

_Update this file as items move from Open → Done._
- Run 65 (2026-10-16): EFM on main 129c73f: build.bat BUILD_OK, rig.bat SIM_TEST_PASS 0 failed; rebuilt DLL not committed. ADAP copy (`G:\Dev\AutonomousDronePack\MQ-9 Reaper\MQ-9 Reaper`) re-compared: 100 / 100 files, only STATUS.md and the DLL build differ. Nothing to sync.
- Run 66 (2026-10-16): EFM on main 129c73f: build.bat BUILD_OK, rig.bat SIM_TEST_PASS 0 failed; rebuilt DLL not committed. ADAP copy (AutonomousDronePack\MQ-9 Reaper\MQ-9 Reaper) re-compared: identical apart from line endings, STATUS.md and the DLL.
- Run 67 (2026-10-16): EFM on main 129c73f (unchanged): build.bat BUILD_OK, rig.bat SIM_TEST_PASS 0 failed; rebuilt DLL not committed. ADAP copy (AutonomousDronePack\MQ-9 Reaper\MQ-9 Reaper) re-compared: every Lua file identical apart from line endings; the DLL differs only as a rebuild.
- Run 68 (2026-10-16): EFM on main 129c73f (unchanged): build.bat BUILD_OK, rig.bat SIM_TEST_PASS 0 failed; rebuilt DLL not committed. ADAP copy (AutonomousDronePack\MQ-9 Reaper\MQ-9 Reaper) re-compared: 100 / 100 files, only STATUS.md and the DLL build differ (line endings ignored). Nothing to sync.
