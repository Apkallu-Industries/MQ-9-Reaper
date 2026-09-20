# MQ-9 Reaper UCAV — DCS World Standalone Module

<p align="center">
  <img src="assets/mq9_reaper_github_banner.png" alt="MQ-9 Reaper DCS World Module Banner" width="100%">
</p>

<p align="center">
  <a href="https://github.com/Apkallu-Industries/MQ-9-Reaper/releases"><img src="https://img.shields.io/badge/Release-v0.0.1v-blue.svg?style=for-the-badge" alt="Release"></a>
  <img src="https://img.shields.io/badge/DCS_World-2.9+-green.svg?style=for-the-badge" alt="DCS World">
  <img src="https://img.shields.io/badge/Unit-432d_Wing_Hunters-darkred.svg?style=for-the-badge" alt="432d Wing">
  <img src="https://img.shields.io/badge/Station-Creech_AFB-navy.svg?style=for-the-badge" alt="Creech AFB">
  <img src="https://img.shields.io/badge/Avionics-Glass_GCS_HUD-success.svg?style=for-the-badge" alt="Glass GCS HUD">
</p>

---

## 🦅 Overview

The **General Atomics MQ-9 Reaper** (Predator B) is the quintessential armed, multi-mission, medium-altitude long-endurance (MALE) remotely piloted aircraft. This DCS World standalone module accurately simulates the **Ground Control Station (GCS)** pilot experience, featuring an authentic tactical Head-Up Display, electro-optical / infrared (EO/IR) sensor slewing, AGM-114 Hellfire laser-guided strikes, and multi-display Ground Control Station support.

Developed and maintained by **Apkallu Industries** under the *Autonomous Drone Pack* initiative.

---

## ✨ Key Features

- 🖥️ **Ground Control Station (GCS) Glass Cockpit**: Full tactical primary flight display and payload camera interface.
- 🕹️ **Xbox 360 / HOTAS Gimbal Slewing**: Seamless analog stick control for targeting pod azimuth and elevation camera tracking.
- 🎯 **Tactical HUD Reticles**: High-visibility targeting crosshairs, flight path markers, pitch ladders, and sensor orientation indicators.
- 🚀 **Precision Strike Arsenal**: Fully integrated weapon stations supporting AGM-114 Hellfire missiles and GBU-12 Paveway II laser-guided bombs.
- 📺 **Multi-Monitor & Ultrawide Support**: Includes custom viewport profiles (`Reaper_GCS_Fullscreen_CPG.lua` & `Reaper_GCS_Ultrawide_Corner_PIP.lua`).
- 🎨 **Authentic Livery Suite**: USAF 432d Wing, 432d Reapers, 17th Attack Squadron, 11th Reconnaissance Squadron, plus UK RAF, France, and Italy.
- 📋 **In-Cockpit Tactical Kneeboard**: Complete pre-flight check, GCS menu guide, and squadron briefing documents.

---

## 🎨 Squadron Liveries & Markings

<p align="center">
  <img src="assets/squadrons/mq9_reaper_432d_squadron_patch_hq.png" alt="432d Wing Reapers Patch" width="280">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="assets/squadrons/mq9_reaper_432d_reapers_livery_emblem.png" alt="432d Livery Emblem" width="280">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="MQ-9 Reaper/Kneeboard/01_Reaper_Squadron_Briefing.png" alt="In-Cockpit Tactical Briefing" width="280">
</p>

Selectable squadron paint schemes from the DCS Mission Editor and payload menus:

1. **`432d Wing 'Hunters' (Creech AFB)`**: Wing Flagship Command.
2. **`432d Reapers Strike Squadron (Mors Ab Alto)`**: Combat strike scheme with painted Reaper insignia.
3. **`17th Attack Squadron (Creech AFB)`**: Premier hunter-killer operational squadron.
4. **`11th Reconnaissance Squadron (Creech AFB)`**: Tactical ISR operations.
5. **Coalition Allies**: RAF (United Kingdom), French Air & Space Force, and Italian Air Force.

---

## 🚀 Installation

### Option 1: Automatic Sync via PowerShell
```powershell
# Run from repository root:
robocopy ".\MQ-9 Reaper" "$HOME\Saved Games\DCS\Mods\aircraft\MQ-9 Reaper" /MIR /FFT /Z /W:5 /R:2 /XD .git
```
*(For DCS OpenBeta, target `$HOME\Saved Games\DCS.openbeta\Mods\aircraft\MQ-9 Reaper`)*

### Option 2: Manual Drag & Drop
1. Copy the inner **`MQ-9 Reaper`** folder.
2. Paste it into your DCS Saved Games aircraft mods directory:
   ```text
   C:\Users\<YourUsername>\Saved Games\DCS\Mods\aircraft\MQ-9 Reaper\
   ```
3. Restart DCS World.

---

## 🕹️ Controls & GCS Operation Guide

The MQ-9 Reaper module features a fully integrated **Xbox Controller profile** and full **Keyboard & Mouse** flight/combat bindings.

### 🎮 Xbox 360 / Xbox One / Gamepad Controls

The controller layout is optimized for single-operator Ground Control Station (GCS) flight and sensor targeting:

| Controller Input | Drone Function | Cockpit Action & Details |
| :--- | :--- | :--- |
| **Left Thumbstick (X / Y)** | **Flight Pitch & Roll** | Precision analog control of elevators and ailerons |
| **Right Thumbstick (X / Y)** | **MTS-B Camera Slew** | Analog pan (azimuth) & tilt (elevation) / TDC cursor slew |
| **Right Bumper [RB]** | **Throttle Up** | Increases engine power / raises commanded airspeed (holds speed) |
| **Left Bumper [LB]** | **Throttle Down** | Decreases engine power / decelerates to loiter speed (holds speed) |
| **[A] Button** | **Weapon Fire / Release** | **Hold for 1.5–2s** to fire AGM-114K Hellfire or drop GBU-12 |
| **[B] Button** | **Sensor Camera On / Off** | Toggles Raytheon MTS-B electro-optical camera view (`O`) |
| **[X] Button** | **Target Lock (Point Track)** | Locks camera onto ground coordinate or vehicle; activates 3D gyro-track (`Enter`) |
| **[Y] Button** | **Laser Designator On / Off** | Arms and fires PRF 1688 laser designator / rangefinder (`RShift + O`) |
| **[D-Pad Up]** | **Sensor Zoom In** | Increases optical telephoto magnification (up to 23x zoom) (`=`) |
| **[D-Pad Down]** | **Sensor Zoom Out** | Decreases optical magnification to wide-area surveillance (`-`) |
| **[D-Pad Left]** | **FLIR / Thermal Vision** | Toggles MWIR infrared thermal mode (WHOT / BHOT) (`RCtrl + O`) |
| **[D-Pad Right]** | **Cycle Weapons** | Cycles active pylon between AGM-114K Hellfire and GBU-12 Paveway II (`D`) |
| **[LS Click] (Left Stick)** | **Air-to-Ground Mode 7** | Arms combat mode and initializes targeting reticle (`7`) |
| **[RS Click] (Right Stick)** | **Target Unlock** | Disengages ground point-track; stows targeting gate (`Back`) |
| **[Back / View] Button** | **Center Designator** | Boresights sensor camera back to forward flight line (`RCtrl + I`) |
| **[Menu / Start] Button** | **Baro Altitude Hold** | Engages autopilot barometric altitude hold (`H`) |

---

### ⌨️ Keyboard & Mouse Controls

| Category | Key / Input | Action |
| :--- | :--- | :--- |
| **Flight Control** | `W` / `S` | Throttle Up / Throttle Down (Airspeed) |
| | `A` / `D` | Roll Left / Roll Right (Ailerons) |
| | `Q` / `E` | Rudder Left / Rudder Right (Yaw) |
| | `R` / `F` or `Space` / `C` | Pitch Up (Climb) / Pitch Down (Descend) |
| | `Down` / `Up Arrow` | Pitch Up / Pitch Down |
| | `Mouse X / Y` | Flight Yoke Roll / Pitch (when mouse flight is enabled) |
| **Autopilot** | `H` | Barometric Altitude Hold (Hands-off level cruise) |
| | `LAlt + 1` | Attitude Hold |
| | `LAlt + 2` | Altitude & Heading Hold |
| | `LAlt + 3` | Transition to Level Flight |
| | `LAlt + 9` | Disengage Autopilot |
| **Sensor & Camera** | `O` | Electro-Optical System / Sensor Camera On/Off |
| | `RCtrl + O` | Night Vision / FLIR Thermal Imaging (WHOT/BHOT) |
| | `RShift + O` | Laser Rangefinder & Designator (PRF 1688) On/Off |
| | `;` `.` `,` `/` | Slew Sensor Up / Down / Left / Right (TDC) |
| | `=` / `-` | Sensor Optical Zoom In / Zoom Out |
| | `Enter` / `RMB` | Target Lock (Ground Point Track / Vehicle Track) |
| | `Back` | Target Unlock / Reset Sensor |
| | `RCtrl + I` | Sensor Designator to Center Boresight |
| **Combat & Weapons** | `7` | Select Air-to-Ground Combat Mode |
| | `D` | Cycle Weapon Station (Hellfire $\leftrightarrow$ GBU-12) |
| | `Space` / `Return` / `LMB` | **Hold 1.5–2s** to Fire Active Munition |
| **Views** | `F1` | Flight Seat / Forward Sensor View |
| | `F4` | External Chase View |
| | `Tab` | Toggle Clean Sensor / Chase View |

---

### 🎯 MTS-B 3-Axis Gyro-Stabilized Ground Tracking (Point Track)

The MQ-9 features a simulated Raytheon MTS-B targeting turret with true 3-axis gyro-stabilization and ground point-tracking:

1. **Activate Air-to-Ground Mode**: Click **`[LS]`** (or press `7`).
2. **Deploy Sensor Camera**: Press **`[B]`** (or press `O`).
3. **Slew to Target**: Move the **`[Right Thumbstick]`** (or keyboard `; . , /`) to place the crosshair over a vehicle, building, or road.
4. **Engage Point Track**: Press **`[X]`** (or press `Enter` / Right Mouse Click).
   * The tracking gate locks onto that exact 3D geographic spot.
   * **The camera will automatically remain anchored to that ground coordinate** as the Reaper circles, banks, climbs, or loiters, up to the physical gimbal limit (±35° pitch, ±40° yaw).
5. **Unlock / Reset**: Click **`[RS]`** (or press `Back`) to disengage ground tracking and return to manual scan.

---

### 🚀 Weapon Employment & Launch Checklist

To successfully launch AGM-114K Hellfire missiles or GBU-12 laser-guided bombs:

1. **Autopilot Loiter**: Press **`[Start]`** (Altitude Hold `H`) or use the radio menu (`\ -> F10 Other -> F1 Flight -> F3 Maintain Orbit`) for hands-off flight.
2. **Combat Mode**: Click **`[LS]`** (Mode 7 Ground).
3. **Turn On Sensor**: Press **`[B]`** (`O`).
4. **Arm Laser Designator**: Press **`[Y]`** (`RShift + O`). *(Laser designation is required for terminal guidance!)*
5. **Lock Target**: Slew over target with **`[Right Stick]`** and press **`[X]`** (`Enter`).
6. **Cycle Weapon**: Press **`[D-Pad Right]`** (`D`) to select **AGM-114K Hellfire** or **GBU-12**.
7. **Steer into Launch Basket**: Fly so the target square is centered inside the HUD launch boundary circle.
8. **Verify Launch Authorization**: Look for the **`ПР`** (LA / Launch Authorized) cue on the HUD.
9. **Fire Munition**: **Press and HOLD `[A]` (or Spacebar) for 1.5 to 2 seconds** until the missile motor ignites and launches off the rail. Keep the laser firing until impact.

---

### 🌙 FLIR & Night Vision Operation

The MQ-9 Reaper is equipped with an integrated **Mercury FLIR / Low-Light TV (LLTV)** sensor package:
* Press **`[D-Pad Left]`** (or `RCtrl + O`) with the sensor camera active (`O`) to cycle between daylight optical imaging and **MWIR Thermal Infrared (FLIR)**.
* Thermal mode displays high-contrast vehicle heat signatures, engine exhausts, and ground targets in darkness or through adverse weather conditions.

---

### ⚙️ HUD Special Options Menu

Customize your Ground Control Station HUD directly in the DCS World settings:
* Navigate to: **DCS Main Menu $\rightarrow$ Options $\rightarrow$ Special $\rightarrow$ MQ-9 Reaper**.
* Adjust display box scale, border opacity, and telemetry contrast to match your monitor resolution.
* Monitor viewports for dedicated multi-display or Picture-in-Picture targeting cameras are available in [Reaper_GCS_Fullscreen_CPG.lua](MQ-9%20Reaper/Reaper_GCS_Fullscreen_CPG.lua) and [Reaper_GCS_Ultrawide_Corner_PIP.lua](MQ-9%20Reaper/Reaper_GCS_Ultrawide_Corner_PIP.lua).

---

## 📂 Repository Structure

```text
MQ-9-Reaper/
├── MQ-9 Reaper/                      <-- Core DCS World Mod Root
│   ├── Cockpit/                      <-- GCS glass cockpit scripts, HUD definitions, & sensor logic
│   ├── Kneeboard/                    <-- In-cockpit mission briefings & procedures
│   ├── Liveries/MQ-9_Reaper/         <-- 432d Wing, 17th ATKS, 11th RS, RAF, France, Italy
│   ├── Missions/Single/              <-- Ready-to-fly combat air patrol missions
│   ├── Options/                      <-- DCS Special Options UI tab for HUD customization
│   ├── Shapes/                       <-- MQ-9 3D airframe & GCS cockpit models
│   ├── Textures/                     <-- High-resolution airframe & cockpit textures
│   ├── Theme/                        <-- UI backgrounds, loading art, & squadron icons
│   ├── entry.lua                     <-- Module registration & DCS plugin hooks
│   └── MQ-9.lua                      <-- Aerodynamics, turboprop engine, avionics, & pylons
├── assets/                           <-- High-res squadron insignia, patches, & banners
└── README.md                         <-- Project Documentation
```

---

## ⚖️ License & Attribution
Developed for the DCS World flight simulation community by **Apkallu Industries**.  
*For non-commercial flight simulation use only.*
