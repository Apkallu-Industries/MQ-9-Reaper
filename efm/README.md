# BNS MQ-9A Reaper external flight model

`BNS_MQ9_EFM.dll`, built against the ED SDK headers (`DCS World\API\include\FM\wHumanCustomPhysicsAPI.h`).
Derived from the BNS B-2 EFM (Apkallu-Industries/B-2-Spirit, `efm/`).

| What | Where |
|---|---|
| Source | `efm/src/BNS_MQ9_EFM.cpp`, data `efm/src/mq9_data.h` |
| Build | `cmd /c <repo>\efm\build.bat` (MSVC via vswhere, `DCS_API` defaults to `D:\Eagle Dynamics\DCS World\API`); copies the DLL to `MQ-9 Reaper/bin/` |
| Offline rig | `cmd /c <repo>\efm\test\rig.bat`; must print `SIM_TEST_PASS - 0 failed` |
| DCS tables | `MQ-9 Reaper/FM/MQ9_FM.lua` |
| Registration | `MQ-9 Reaper/entry.lua`: `BNS_MQ9_USE_EFM` (default **false**) |
| Log | `Saved Games\DCS\Logs\BNS_MQ9_EFM.log` |

## Model

- Public (USAF MQ-9 fact sheet, Creech AFB): TPE331-10GD, 900 shp; span 20.1 m; empty 2,223 kg; MTOW 4,760 kg;
  fuel 1,814 kg; cruise about 200 kt; ceiling up to 50,000 ft. Wing area 23.52 m² and gear from `MQ-9.lua`.
- **ESTIMATED**: all derivatives, flight control computer laws, power flat rating (to about 25,000 ft), propeller
  (2.6 m, 80 %), BSFC 0.56 lb/shp/h, inertias, gear springs. Marked `[EST]`.
- Flight control computer: pitch-rate command / attitude hold (alpha limit 11 deg, 3 g), roll-rate command
  (45 deg/s) with bank hold, yaw damper with sideslip suppression; direct law on the ground below 30 m/s.
- Damage by the DCS cell numbers of the names `MQ-9.lua` uses: ROTOR 63 (engine/propeller), wings 35/29/23 and
  36/30/24, ailerons 25/26, V-tail 49-54.
- Draw args: flaps 9/10, ailerons 11/12, propeller 407, plus the model's own tail arguments 354 (right
  ruddervator), 355 (left) and 357 (ventral rudder) with V-tail mixing; 15/16/17 are still written for other shapes.
  Checked against `Mq-9_Reaper.EDM` on 2026-10-07 (fourth run) with the `dcs_edm_importer` parser: the model animates
  0-6, 9-12, 101-104, 280, 306-311, 354, 355, 357, 407, 413, 449, 450 and has **no 15/16/17**, so before this fix the
  tail never moved under the EFM (or under the Su-25T shell, which drives 15/16/17). Each tail node is keyed
  +/-15 deg about its hinge; whether +1 is trailing edge up is ESTIMATED (`RV_SIGN` / `VR_SIGN` in the EFM): check in
  DCS with stick aft and right pedal, flip the constant if a surface moves the wrong way.

## Rig results (2026-10-07, third scheduled run: drag and part-power fuel flow tuned)

Published targets (GA-ASI MQ-9A page and NAVAIR MQ-9A product page, read 2026-10-07): max speed 240 KTAS, endurance
27 h ("over 27 hours"), max altitude 50,000 ft, MTOW 10,500 lb, fuel 3,900 lb (NAVAIR; the EFM keeps the USAF fact
sheet's 4,000 lb).

| Check | Result |
|---|---|
| 25,000 ft, 200 KTAS, 4,500 kg | level, throttle 0.63, 150 kg/h (12 h on 1,814 kg) |
| Hands-off 60 s | dh 0 m, wings level |
| Top speed, max power, 25,000 ft | 239 KTAS (target 240) |
| 50,000 ft at 3,300 kg | holds level (-36 m) at 99 m/s TAS, AoA 11.0 deg |
| Climb, sea level, 4,760 kg | 6.4 m/s (1,260 ft/min) |
| Full aft stick at idle | AoA held under 12.1 deg, 53 m/s TAS |
| Senses | stick aft nose up, right stick right roll (47 deg/s), bank held, right pedal nose right |
| Engine failure glide | L/D 15.8 at 90 KTAS |
| Propeller hit / left outer wing lost | engine stops / FCC holds the wings within 2.5 deg |
| Loiter, 20,000 ft, 110 KTAS, 3,300 kg (new check [9]) | 67 kg/h = 27.0 h on 1,814 kg (target 27 h) |

Changes: `CD0` 0.030 -> 0.038 (260 -> 239 KTAS); fuel flow on a Willans line (`FF_ZERO` 0.12 of rated flow at zero
shaft power, ESTIMATED) instead of a constant BSFC, which had given 40 h at the loiter point. Check [2] tightened to
228..252 KTAS. Both figures are tuned to the published numbers, not measured.

Re-run on the scheduled run of 2026-10-07 (05:10 local): `build.bat` BUILD_OK against `D:\Eagle Dynamics\DCS World\API`,
rig `SIM_TEST_PASS - 0 failed`. Branch pushed and PR opened for the owner (it had only been committed locally).

Fourth scheduled run (2026-10-07, about 13:00-13:30 local): tail draw args moved onto the model's 354/355/357, new rig
check [10] (V-tail mixing on the draw args); `build.bat` BUILD_OK, rig `SIM_TEST_PASS - 0 failed` (10 checks).

## Not done / to check

- Never flown in DCS; the Su-25T shell (`old = 54`) stays in use until `BNS_MQ9_USE_EFM = true`.
- Fixed 2026-10-07 (third run): top speed 240 KTAS and 27 h loiter endurance now both met (see the table). The loiter
  altitude, speed and weight in check [9] are ESTIMATED; GA-ASI does not publish the endurance profile.
- With the extra drag the ceiling check runs at AoA 11.0 deg, close to the 11 deg limiter: at heavier weights than
  3,300 kg the aircraft will not hold 50,000 ft, which matches "up to 50,000 ft" but should be watched in DCS.
- Fixed 2026-10-07: `MQ-9.lua` `M_fuel_max` was 1,300 kg; now 1,814 kg (4,000 lb, USAF fact sheet), the EFM's
  `FUEL_MAX`. Applied to both ADAP copies too (`AutonomousDronePack\MQ-9 Reaper\MQ-9 Reaper` and
  `AutonomousDronePack\DCS Content\MQ-9 Reaper`). Missions that set fuel explicitly keep their own figure.
- The ADAP copy (`C:\Dev\AutonomousDronePack\MQ-9 Reaper`) is newer than this repo (GCS menu, STATUS.md, combat
  patrol mission) and does not have the EFM: sync both ways when the pipeline is consolidated.
