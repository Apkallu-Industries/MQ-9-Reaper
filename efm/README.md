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
- Draw args (DCS standard, as the shell drove them): flaps 9/10, ailerons 11/12, ruddervators 15/16 and 17,
  propeller 407. Not checked against the `Mq-9_Reaper.EDM` argument list.

## Rig results (2026-10-07)

| Check | Result |
|---|---|
| 25,000 ft, 200 KTAS, 4,500 kg | level, throttle 0.51, 117 kg/h (15 h on 1,814 kg) |
| Hands-off 60 s | dh 0 m, wings level |
| Top speed, max power, 25,000 ft | 260 KTAS (GA-ASI quotes about 240) |
| 50,000 ft at 3,300 kg | holds level at 106 m/s TAS |
| Climb, sea level, 4,760 kg | 9.3 m/s |
| Full aft stick at idle | AoA held under 12.2 deg, 53 m/s TAS |
| Senses | stick aft nose up, right stick right roll (47 deg/s), bank held, right pedal nose right |
| Engine failure glide | L/D 17.4 at 90 KTAS |
| Propeller hit / left outer wing lost | engine stops / FCC holds the wings within 2.5 deg |

## Not done / to check

- Never flown in DCS; the Su-25T shell (`old = 54`) stays in use until `BNS_MQ9_USE_EFM = true`.
- Top speed and endurance pull against each other with one drag figure: 260 KTAS is above the quoted 240 and the
  cruise fuel flow gives 15 h, short of the 20+ h endurance usually quoted. Needs a better drag polar.
- `MQ-9.lua` `M_fuel_max` is 1,300 kg; the fact sheet says 4,000 lb (1,814 kg).
- The ADAP copy (`C:\Dev\AutonomousDronePack\MQ-9 Reaper`) is newer than this repo (GCS menu, STATUS.md, combat
  patrol mission) and does not have the EFM: sync both ways when the pipeline is consolidated.
