# Forensics, Repair & Migration Log: MQ-9 Reaper in DCS World 2.9+
## Technical Post-Mortem and Architectural Reconstruction Guide

---

## Executive Summary

The legacy community **MQ-9 Reaper** mod (originally created around 2014) had been non-functional for multiple DCS World release cycles. When loaded in modern DCS World (version 2.9+), the mod suffered from immediate script syntax errors, silent player spawn dropping, engine memory crashes (`0xC0000005`), untextured pink cockpits, camera disorientation, and a complete absence of targeting reticles on the sensor ball.

This document provides a comprehensive technical breakdown of every failure mode identified during teardown, the root causes discovered, and the architectural solutions engineered to make the MQ-9 a fully operational, combat-ready UAV with persistent overwatch, automated orbit loiter, precision targeting HUD, and cooperative multi-domain weapons delivery.

---

## The 7 Core Failure Modes & Engineering Solutions

```mermaid
graph TD
    A[Legacy Mod: Broken in Modern DCS] --> B{Forensic Investigation}
    B -->|Bug 1: Lua UTF-8 BOM| C[Lua Parser Crashes on Line 1]
    B -->|Bug 2: crew_members = {}| D[Player Slot Dropped into Spectator]
    B -->|Bug 3: Missing Kneeboard| E[0xC0000005 Access Violation Crash]
    B -->|Bug 4: Missing VFS Mounts| F[Pink Glass & Missing Cockpit EDM]
    B -->|Bug 5: Backslash Zip Paths| G[Linux / VFS Unpack Failure in .miz]
    B -->|Bug 6: Camera at Origin| H[Floating Disoriented Free-Look View]
    B -->|Bug 7: No Crosshair / Reticle| I[Impossible to Point/Mark Ground Targets]
    
    C --> J[Re-encode Clean ASCII / UTF-8 Without BOM]
    D --> K[Define crew_members[1] with can_be_playable=true]
    E --> L[Declare Valid Kneeboard Scripts & VFS Mounts]
    F --> M[Mount AvionicsCommon & Su-25T Textures]
    G --> N[Enforce POSIX Forward Slashes in Zip Pipeline]
    H --> O[Align CockpitLocalPoint to MTS-B Sensor Ball]
    I --> P[Engineer Custom Screenspace GCS_HUD Reticle]
```

---

### Failure Mode 1: Unexpected Symbol Near `?` (UTF-8 Byte Order Mark Crash)

#### Symptom:
Upon launching DCS World, the DCS log immediately recorded a critical Lua syntax error on Line 1 of `entry.lua` or `MQ-9.lua`:
```
LUA error: [string ".../entry.lua"]:1: unexpected symbol near '?'
```
The mod failed to register in DCS; the aircraft did not appear in the Mission Editor or Module Manager.

#### Root Cause:
PowerShell's default text redirection (`Out-File` or `Set-Content` without specific encoding flags) writes a 3-byte UTF-8 **Byte Order Mark (BOM)** (`0xEF, 0xBB, 0xBF`) at the very beginning of the file. While standard Windows text editors ignore this mark, DCS World's internal Lua 5.1/LuaJIT engine treats these three bytes as invalid ASCII characters before the first statement, causing the parser to abort immediately on byte 0.

#### Solution:
* Enforce strict pure ASCII or UTF-8 without BOM across all `.lua` files.
* Configured all deployment and generation scripts in Python and PowerShell to use `System.Text.UTF8Encoding($false)`.
* Verified all scripts using DCS World's native compiler `D:\Eagle Dynamics\DCS World\bin-mt\luae.exe`.

---

### Failure Mode 2: Silent Player Spawn Drop (AI Spawns, Player Enters Spectator)

#### Symptom:
When placing an MQ-9 Reaper in the Mission Editor set to **Skill: Player** or **Client**, upon loading the mission, DCS silently dropped the player into the F10 map or external spectator view. The Reaper spawned, but flew as an autonomous AI vehicle with zero human control.

#### Root Cause:
In DCS World core files (`CoreMods/aircraft/MQ-9 Reaper/`), the Reaper was originally defined as an unmanned AI vehicle with an empty crew table:
```lua
crew_members = {}
```
Modern DCS World (2.8+) includes an engine-level gate during mission spawn: if `crew_members` is empty or lacks a playable role definition, the mission engine concludes the airframe has no physical cockpit/station for a human player. Rather than crashing, DCS silently demotes the unit to AI and drops the player slot.

#### Solution:
Created an explicit aircraft descriptor (`MQ-9.lua`) with a valid, fully configured human crew member:
```lua
Reaper.HumanCockpit = true
Reaper.crew_size = 1
Reaper.crew_members = {
    [1] = {
        ejection_seat_name = 0,
        drop_canopy_name   = 0,
        pos                = {10.050000, -0.620000, 0.000000},
        can_be_playable    = true,
        role               = "pilot",
        role_display_name  = _("Pilot / Sensor Operator"),
        g_suit             = 50.0, -- Remote operator immune to cockpit G-forces
    },
}
add_aircraft(Reaper)
```

---

### Failure Mode 3: Memory Access Violation (`0xC0000005`) at Mission Spawn

#### Symptom:
When attempting to enter the 3D simulation, DCS froze during the loading screen and crashed to desktop with an unhandled memory exception in `edCore.dll` or `CockpitBase.dll` (`0xC0000005: Access Violation Reading 0x00000000`).

#### Root Cause:
The legacy mod's `entry.lua` invoked:
```lua
make_flyable('MQ-9_Reaper', current_mod_path .. '/Cockpit/Scripts/', nil, current_mod_path .. '/comm.lua')
```
While passing hardcoded paths to `/Cockpit/KneeboardLeft/` that did not exist on disk. Simultaneously, `device_init.lua` called non-existent sub-scripts. When the C++ cockpit loader attempted to instantiate the kneeboard device and render target pointers from null file descriptors, it triggered a null-pointer dereference.

#### Solution:
1. Created the proper directory structure on disk: `Cockpit/KneeboardLeft/` with valid `device_init.lua` and `kneeboard_init.lua`.
2. Updated `device_init.lua` to safely declare core avionics attributes:
   ```lua
   attributes = {
       "support_for_cws", -- Cockpit Weapon System (Su-25T core avionics)
   }
   dofile(LockOn_Options.common_script_path .. "KNEEBOARD/declare_kneeboard_device_left.lua")
   indicators = indicators or {}
   indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path .. "GCS_HUD/init.lua", nil}
   ```

---

### Failure Mode 4: Missing Textures & "Pink Glass" Syndrome

#### Symptom:
If the 3D cockpit loaded, all digital displays, HUD glass, and control panels were covered in bright neon pink/magenta textures, indicating missing shader textures.

#### Root Cause:
The Su-25T Cockpit Weapon System (CWS) relies on shared avionics textures located in the core DCS installation (`Bazar/Textures/AvionicsCommon` and `Mods/aircraft/Su-25T/Cockpit/Textures/SU-25T-CPT-TEXTURES.zip`). Because the legacy mod did not declare these paths in its Virtual File System (VFS), the rendering engine could not find HUD reticle textures, droplet maps, or optical glass shaders.

#### Solution:
Explicitly registered all required VFS texture paths in `entry.lua`:
```lua
mount_vfs_texture_path(current_mod_path .. "/Theme/ME")
mount_vfs_texture_path(current_mod_path .. "/Textures")
mount_vfs_texture_path(current_mod_path .. "/Textures/mq-9_reaper_textures.zip")
mount_vfs_texture_path(current_mod_path .. "/Cockpit/Textures/SU-25T-CPT-TEXTURES.zip")
mount_vfs_texture_path("Bazar/Textures/AvionicsCommon")
mount_vfs_model_path(current_mod_path .. "/Shapes")
mount_vfs_model_path(current_mod_path .. "/Cockpit/Shape")
mount_vfs_liveries_path(current_mod_path .. "/Liveries")
```

---

### Failure Mode 5: Floating Disoriented "Freelook" Camera

#### Symptom:
When the player pressed `F1`, the camera was placed at `{2.40, -0.35, 0.0}`, floating loosely inside the exterior fuselage mesh without orientation limits. TrackIR and mouse movements drifted through the empty airframe, creating severe visual disorientation.

#### Root Cause:
`Views.lua` defined an arbitrary cockpit viewpoint that sat between the exterior skin and the landing gear well, neither aligning with the Su-25T cockpit instruments nor acting as an authentic UAV sensor ball.

#### Solution:
Redesigned `Views.lua` to establish the player's primary view as the **Raytheon MTS-B Electro-Optical / Infrared Sensor Turret**:
* **Position**: Set `CockpitLocalPoint = {7.150000, -0.620000, 0.000000}`, placing the virtual camera 200cm forward of the nose and pitot tube.
* **Gimbal Limits**:
  * Azimuth: ±160° horizontal pan
  * Elevation: -85° pitch down (steep ground surveillance) to +30° pitch up
* **Rigid Gyro Mount**: Locked 6-DOF translation limits (`limits_6DOF = {x={0,0}, y={0,0}, z={0,0}, roll=0}`) to simulate a rigid, gyro-stabilized sensor turret rather than a human head on a neck.
* **Optical Zoom Range**: Set `CameraViewAngleLimits = {10.0, 110.0}`, allowing seamless zoom from wide situational awareness (110°) to extreme 23x optical telephoto (10°).

---

### Failure Mode 6: Backslash Path Glitch in `.miz` Zip Archives (Linux / Dedicated Server Bug)

#### Symptom:
Custom combat missions repacked using standard Windows utilities failed to load on Linux dedicated servers or threw missing dictionary/trigger errors in DCS World.

#### Root Cause:
Windows native zip compression uses backslashes (`\`) for directory separators in the zip central directory table (e.g. `l10n\DEFAULT\reaper_gcs_menu.lua`). The DCS World Virtual File System and Linux servers strictly require POSIX forward slashes (`/`). Backslashes are treated as literal filename characters, causing the engine to fail to find `mission`, `options`, or localized trigger scripts.

#### Solution:
Engineered a custom PowerShell deployment pipeline (`repack_and_deploy.ps1`) that walks the extracted mission directory and converts every path separator to a forward slash before writing to the zip archive stream:
```powershell
Get-ChildItem -Path $sourceDir -Recurse -File | ForEach-Object {
    $relPath = $_.FullName.Substring($sourceDir.Length + 1).Replace('\', '/')
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $relPath, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
}
```

---

### Failure Mode 7: Bare Camera with Zero Crosshair Reticle (Ground Marking Blindness)

#### Symptom:
When the operator entered the gimbal camera view (F1), they were presented with a completely bare 3D camera. When slewing the camera over ground targets, buildings, or vehicles, there was **no crosshair or reticle of any kind**. It was impossible to know the exact center boresight, impossible to aim Hellfire missiles, and impossible to confirm what ground coordinate was being marked or locked.

#### Root Cause:
The Su-25T CWS HUD and IT-23M TV screen (Shkval) were designed as physical 3D collimated meshes situated in the Su-25T cockpit at `X=3.406`. Because `CockpitLocalPoint` was advanced to `{7.15, -0.62, 0.0}` to act as the forward drone sensor ball, the 3D cockpit model was left 4 meters behind the camera. Furthermore, DCS World does not render HUD overlays on bare screenspace unless a dedicated `ccIndicator` is declared with screenspace render purposes.

#### Solution:
Engineered an authentic, military-grade **MTS-B Screenspace Targeting HUD** in `Cockpit/Scripts/GCS_HUD/`:
1. **Indicator Registration (`init.lua`)**:
   * Declared as `indicator_types.COMMON` with `screenspace_scale = 4`.
   * Bound to both `render_purpose.SCREENSPACE_INSIDE_COCKPIT` and `render_purpose.HUD_ONLY_VIEW` to ensure continuous rendering.
2. **Dual-Layer High-Contrast Architecture (`definitions.lua`)**:
   * Every line, bracket, and tick mark is rendered in dual layers: a 3.5px dark charcoal outline (`{0, 0, 0, 210}`) behind a 2.0px phosphor green line (`{0, 255, 70, 240}`).
   * Guarantees 100% crystal-clear readability against desert sand, snow, foliage, night thermals, and water.
3. **MTS-B Reticle Geometry (`indication_page.lua`)**:
   * **Precision Center Aiming Dot**: Pixel-accurate pip at `(0, 0)` for pin-point ground designation.
   * **4 Crosshair Arms with Aiming Gap**: Horizontal and vertical mil-graduated stadia lines with an open center gap (`±0.024`) so ground targets are never obscured by lines.
   * **Target Acquisition Gate (`[   ]`)**: 4 L-shaped corner brackets defining the optical tracking gate.
   * **Outer Circular FOV Reticle**: Segmented 4-quadrant ring with 12/3/6/9 o'clock cardinal cues.
   * **Azimuth Compass Tape**: Heading bar at top of HUD with center index caret (`V`) and digital readout.
   * **Elevation Depression Ladder**: Right-side pitch index from `+10°` down to `-90° (Nadir)`.
   * **Tactical Telemetry**: Live readouts for sensor mode, 23x zoom, laser code (1688), and weapon status.
4. **Input & Ground Marking Integration**:
   * Re-mapped **Right Mouse Button (`MOUSE_BTN2`)** to `iCommandPlaneChangeLock` in `mouse/default.lua` so right-clicking locks the target directly under the crosshair.
   * Integrated `trigger.action.markToAll` and red phosphorus marking smoke (`trigger.action.smoke`) in `reaper_gcs_menu.lua`.

---

## Technical Comparison: Legacy vs. Modern DCS 2.9+

| Parameter | Legacy Community Mod (2014) | Modern Refactored Mod (DCS 2.9+) |
| :--- | :--- | :--- |
| **Plugin Declaration** | Hacked F-15E / MiG-31 leftover files | Clean `declare_plugin()` with proper VFS mounts |
| **Aircraft Descriptor** | Missing; relied on core AI table | Dedicated `MQ-9.lua` with custom SFM and pylons |
| **Human Playability** | `crew_members = {}` (Failed to spawn) | `crew_members[1]` configured with playable role |
| **Cockpit Camera** | Loose free camera inside fuselage | Calibrated Raytheon MTS-B sensor ball (`{7.15, -0.62, 0.0}`) |
| **Sensor Reticle** | **None** (Blind ground targeting) | Dual-layer high-contrast screenspace HUD & crosshair |
| **Target Marking** | Broken / unmapped controls | RMB target lock + Red smoke + F10 map SPI markers |
| **Flight Automation** | Manual flight only; violent pitch stalls | F10 GCS Flight Director: autonomous tangent-circle orbit |
| **Kneeboard** | Missing path (Caused CTD) | High-res 432d Wing combat briefing sheet (`RShift + K`) |
| **Heraldry & Livery** | Generic low-res textures | 432d Attack Wing "Mors Ab Alto" insignia & liveries |
| **Build Pipeline** | Manual zip compression with backslashes | Automated POSIX forward-slash build & validation script |
