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

## 🕹️ Controls & GCS Operation

- **Sensor Gimbal Slew**:
  - `Xbox Left Stick / Mouse / HOTAS Slew`: Direct continuous pan & tilt of EO/IR targeting pod.
  - `FOV / Zoom`: Step zoom levels for wide-area surveillance and high-magnification target ID.
- **HUD Options Menu**:
  - Configure HUD box scaling and opacity directly via DCS Main Menu $\rightarrow$ Options $\rightarrow$ Special $\rightarrow$ **MQ-9 Reaper**.

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
