# Comprehensive Guide: How to Make Any DCS Aircraft Mod Flyable

This technical guide documents the complete end-to-end architecture, files, and techniques used to transform the **MQ-9 Reaper** from an AI-only background asset into a **fully flyable, player-controllable aircraft** in DCS World.

If you have other aircraft 3D models or non-flyable AI mods and want to make them player-flyable, this blueprint details every necessary step, file structure, and common pitfall.

---

## Table of Contents
1. [Core Architecture: What Makes an Aircraft "Flyable" in DCS?](#1-core-architecture-what-makes-an-aircraft-flyable-in-dcs)
2. [Step 1: The Plugin Descriptor (`entry.lua`)](#2-step-1-the-plugin-descriptor-entrylua)
3. [Step 2: The Aircraft Descriptor (`[Aircraft].lua`)](#3-step-2-the-aircraft-descriptor-aircraftlua)
4. [Step 3: View Settings & Cockpit Camera (`Views.lua`)](#4-step-3-view-settings--cockpit-camera-viewslua)
5. [Step 4: Input Profiles & Controls (`Input/`)](#5-step-4-input-profiles--controls-input)
6. [Step 5: Cockpit Avionics & Displays (`Cockpit/`)](#6-step-5-cockpit-avionics--displays-cockpit)
7. [Step 6: Avoiding Collisions with Built-in AI Assets](#7-step-6-avoiding-collisions-with-built-in-ai-assets)
8. [Step 7: Installation & Deployment Structure](#8-step-7-installation--deployment-structure)
9. [Master Conversion Checklist](#9-master-conversion-checklist)

---

## 1. Core Architecture: What Makes an Aircraft "Flyable" in DCS?

In DCS World, an AI aircraft only needs:
- A 3D model (`.EDM`)
- Textures (`.dds` / `.zip`)
- An aircraft descriptor with basic flight parameters for the AI flight model (SFM).

To make an aircraft **Flyable (Player-Controllable)**, DCS requires four critical systems:
1. **`make_flyable()` call**: Tells the DCS core engine that a human player can occupy slot 1 of this aircraft.
2. **Avionics & Flight Model Shell**: Bridges the aircraft to a DCS cockpit/avionics system (either a Flaming Cliffs 3 shell like the Su-25T or a full SDK external flight model DLL).
3. **Cockpit / View System**: Defines where the player's eyes sit, camera pan/pitch limits, and zoom constraints (`Views.lua`).
4. **Input Profile**: Defines joystick, gamepad, mouse, and keyboard bindings so the player can actually steer, throttle, and fire weapons (`Input/`).

```
                              DCS WORLD CORE
                                    │
                         ┌──────────┴──────────┐
                         │      entry.lua      │
                         └──────────┬──────────┘
                                    │
         ┌──────────────────────────┼──────────────────────────┐
         ▼                          ▼                          ▼
  MQ-9.lua (Data)           make_flyable(...)          Views.lua (Camera)
  • HumanCockpit = true     • Shell: Su-25T (old=54)   • CockpitLocalPoint
  • crew_members = {..}     • support_cockpit path     • CameraAngleLimits
  • add_aircraft(Reaper)    • comm.lua                 • SnapViews (FOV/HUD)
         │                          │                          │
         └──────────────────────────┼──────────────────────────┘
                                    │
                     ┌──────────────┴──────────────┐
                     ▼                             ▼
              Input Profiles               Cockpit / Avionics
         • joystick/default.lua       • device_init.lua
         • keyboard/default.lua       • GCS_HUD/init.lua (Screenspace)
         • diff.lua (Xbox / HOTAS)    • mfd0 Material (Live Camera Feed)
```

---

## 2. Step 1: The Plugin Descriptor (`entry.lua`)

`entry.lua` is the front door of your mod. It is the first script DCS executes when loading mods from `Saved Games/DCS/Mods/aircraft/<ModName>/`.

### Critical Components in `entry.lua`

```lua
local self_ID = "MQ-9 Reaper Flyable"
declare_plugin(self_ID,
{
    displayName     = _("MQ-9 Reaper (Flyable)"),
    shortName       = "MQ-9_Reaper_Flyable",
    developerName   = "Blacknet Systems",
    installed       = true,
    dirName         = current_mod_path,
    fileMenuName    = _("MQ-9 Reaper Flyable"),
    update_id       = "MQ-9_Reaper_Flyable",
    version         = "0.0.1v",
    state           = "installed",
    info            = _("MQ-9 Reaper Flyable UAV Mod"),

    -- 1. Register the Input Profiles directory
    InputProfiles =
    {
        ["MQ-9_Reaper_Flyable"] = current_mod_path .. '/Input/MQ-9_Reaper_Flyable',
    },

    -- 2. Optional Options GUI page
    Options =
    {
        {
            name   = _("MQ-9 Reaper Flyable"),
            nameId = "MQ-9_Reaper_Flyable",
            dir    = "Options",
            CLSID  = "{MQ-9_Reaper_Flyable options}"
        },
    },
})

-- Mount 3D shapes, textures, and liveries into the DCS Virtual File System (VFS)
mount_vfs_texture_path(current_mod_path .. "/Textures")
mount_vfs_texture_path(current_mod_path .. "/Textures/mq-9_reaper_textures.zip")
mount_vfs_texture_path(current_mod_path .. "/Cockpit/Textures/SU-25T-CPT-TEXTURES.zip")
mount_vfs_model_path(current_mod_path   .. "/Shapes")
mount_vfs_model_path(current_mod_path   .. "/Cockpit/Shape")
mount_vfs_liveries_path(current_mod_path .. "/Liveries")

local support_cockpit = current_mod_path .. '/Cockpit/Scripts/'

-- 3. THE KEY FUNCTION: make_flyable
make_flyable('MQ-9_Reaper_Flyable', support_cockpit, {nil, old = 54}, current_mod_path .. '/comm.lua')

-- 4. Load the aircraft physics & database descriptor
dofile(current_mod_path .. "/MQ-9.lua")

-- 5. Attach the camera and view limits
dofile(current_mod_path .. "/Views.lua")
make_view_settings('MQ-9_Reaper_Flyable', ViewSettings, SnapViews)

plugin_done()
```

### Why `{nil, old = 54}` (Su-25T) is the Gold Standard for Community Mods
The 3rd parameter of `make_flyable` selects the underlying avionics and flight-model shell:
- **`old = 54` is the Su-25T**. 
- **Crucial Advantage**: The Su-25T is included **100% free** in every copy of DCS World (Steam and Standalone). Anyone can download and fly your mod without purchasing FC3 or other modules.
- **Avionics Capabilities**:
  - Full optical targeting camera (I-251 Shkval / Mercury LLTV) with TV and FLIR modes.
  - Laser ranger and designator (compatible with Hellfire / Vikhr laser beam-riding missiles).
  - Collimated Flight HUD with pitch ladder, waypoint steering, and target designator reticle.
  - Full air-to-ground and weapon management system.

Other FC3 shell IDs (require user to own Flaming Cliffs 3):
- `old = 1`: A-10A
- `old = 2`: F-15C
- `old = 3`: Su-27
- `old = 4`: MiG-29
- `old = 5`: Su-33

---

## 3. Step 2: The Aircraft Descriptor (`[Aircraft].lua`)

In `MQ-9.lua`, you define the aircraft's mass, aerodynamics, engines, pylons, and damage model. To enable player flight, the following fields **must** be present:

### 1. Human Cockpit Flag & Crew Definition
```lua
Reaper = {
    Name        = 'MQ-9_Reaper_Flyable', -- MUST match make_flyable and InputProfiles!
    DisplayName = _('MQ-9 Reaper (Flyable)'),
    ...
    HumanCockpit = true,  -- Crucial: marks the aircraft as human-flyable in Mission Editor
    crew_size    = 1,
    crew_members = {
        [1] = {
            ejection_seat_name = 0, -- 0 for no ejection seat (drones/civilian)
            pilot_name         = 0,
            pos                = {7.5, -1.05, 0.0},
        },
    },
```

### 2. Radio & ViewSettings Binding
```lua
    ViewSettings = ViewSettings,

    HumanRadio = {
        frequency    = 124.0,
        editable     = true,
        minFrequency = 118.0,
        maxFrequency = 143.975,
        modulation   = MODULATION_AM,
    },
    panelRadio = {
        [1] = {
            name  = _("VHF AM Radio"),
            range = {{min = 118.0, max = 143.975}},
            channels = {
                [1] = { name = _("Channel 1"), default = 124.0, modulation = _("AM") },
            }
        },
    },
}

-- Finally register the table into the DCS core database:
add_aircraft(Reaper)
```

---

## 4. Step 3: View Settings & Cockpit Camera (`Views.lua`)

`Views.lua` dictates where the human camera is located, how far it can pan and tilt, and what the player sees when pressing `F1`.

```lua
ViewSettings = {
    Cockpit = {
        [1] = {
            CameraViewAngleLimits  = {10.000000, 110.000000}, -- Zoom limits (FOV min/max)
            CockpitLocalPoint      = {7.500000, -1.050000, 0.000000}, -- 3D coordinate on aircraft
            CameraAngleRestriction = {false, 90.000000, 0.500000},
            CameraAngleLimits      = {180.000000, -90.000000, 45.000000}, -- Yaw +/-180, Pitch down -90 (nadir), up +45
            EyePoint               = {0.000000, 0.000000, 0.000000},
            ShoulderSize           = 0.000000,
            Allow360rotation       = false,
            limits_6DOF            = {x = {-0.20, 0.60}, y = {-0.20, 0.20}, z = {-0.20, 0.20}, roll = 0.0},
        },
    },
}
```

### Key Lesson: The HUD Aperture & Missing Target Indicator
- In DCS, collimated HUD symbology is projected onto a 3D glass aperture inside the cockpit model.
- If the default camera sits too far back (`x_trans = 0.0`), the HUD glass appears small on screen. When you slew the sensor pod down, the target designator circle moves past the physical edges of the glass and vanishes!
- **The Solution**: Move `x_trans` forward (e.g. `0.38m`) directly behind the HUD glass in `SnapViews[1][13]`:

```lua
SnapViews = {
    [1] = {
        -- Slot 13 is the default forward F1 cockpit view
        [13] = head_pos_default({
            viewAngle = 50.0,
            hAngle    = 0.0,
            vAngle    = -6.0,
            x_trans   = 0.38,  -- Forward towards HUD glass: expands visible angular aperture!
            y_trans   = -0.04, -- Vertical centering
        }),
    },
}
```

---

## 5. Step 4: Input Profiles & Controls (`Input/`)

DCS looks inside `Input/<Aircraft_Name>/` for:
- `joystick/default.lua`
- `keyboard/default.lua`
- Device-specific diff files (e.g. `Controller (XBOX 360 For Windows).diff.lua`)

### Inheriting Base DCS Commands Cleanly
Instead of defining hundreds of basic flight commands from scratch, inherit from DCS base bindings:

```lua
local res = external_profile("Config/Input/Aircrafts/base_joystick_binding.lua")

-- Add aircraft-specific sensor and weapons controls:
join(res.keyCommands, {
    -- [A] Weapon Release
    {combos = {{key = 'JOY_BTN1'}}, down = iCommandPlaneFire, name = _('Weapon Fire'), category = _('Weapons')},
    -- [B] Camera / Electro-Optical System On/Off
    {combos = {{key = 'JOY_BTN2'}}, down = iCommandPlaneEOSOnOff, name = _('Electro-Optical System On/Off'), category = _('Sensors')},
    -- [X] Target Lock
    {combos = {{key = 'JOY_BTN3'}}, down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock'), category = _('Sensors')},
    -- [Y] Laser Ranger / Designator On/Off
    {combos = {{key = 'JOY_BTN4'}}, down = iCommandPlaneLaserRangerOnOff, name = _('Laser Ranger On/Off'), category = _('Sensors')},
    -- D-Pad / POV Hat Slew
    {combos = {{key = 'JOY_BTN_POV1_U'}}, pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
    {combos = {{key = 'JOY_BTN_POV1_D'}}, pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
})

-- Add Axis Commands (Flight Stick & Sensor Slew)
join(res.axisCommands, {
    {combos = defaultDeviceAssignmentFor("roll"),  action = iCommandPlaneRoll,  name = _('Roll')},
    {combos = defaultDeviceAssignmentFor("pitch"), action = iCommandPlanePitch, name = _('Pitch')},
    -- Right Thumbstick Sensor Slew
    {combos = {{key = 'JOY_RX'}}, action = iCommandPlaneSelecterHorizontalAbs, name = _('I-251 Slew Horizontal')},
    {combos = {{key = 'JOY_RY'}}, action = iCommandPlaneSelecterVerticalAbs,   name = _('I-251 Slew Vertical')},
})

return res
```

### Critical Gotcha: The Inverted Vertical Slew Axis
In gamepad / joystick diff files:
- If `["invert"] = true` is set on `I-251 Slew Vertical` (`JOY_RY`), pushing the stick forward commands positive pitch (up into the sky).
- Because optical targeting sensors typically have limited upward elevation (+15°) but large downward depression (-80°), pushing forward immediately hits the upward stop! The user thinks: *"I cannot look down, only up!"*
- **Fix**: Ensure `["invert"] = false` on vertical slew axes.

---

## 6. Step 5: Cockpit Avionics & Displays (`Cockpit/`)

### Registering Indicators (`Cockpit/Scripts/device_init.lua`)
```lua
attributes = { "support_for_cws" }

devices = devices or {}
devices["GCS_CONTROLLER"] = 1

creators = creators or {}
creators[devices.GCS_CONTROLLER] = {"avLuaDevice", LockOn_Options.script_path .. "GCS_Controller.lua"}

indicators = indicators or {}
indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path .. "GCS_HUD/init.lua", devices.GCS_CONTROLLER}
```

### Building Screenspace Tactical Displays (`GCS_HUD`)
In `GCS_HUD/definitions.lua`, set `screenspace = ScreenType.SCREENSPACE_TRUE` so your HUD elements draw directly on the player's 2D monitor rather than requiring a physical glass mesh in the 3D model.

#### Rendering the Live Camera Feed
DCS exposes the optical sensor texture under the material name `"mfd0"`.

```lua
-- Create a 100% solid, opaque video feed material
matMfd0 = MakeMaterial("mfd0", {255, 255, 255, 255})

function addSensorScreen(name, x, y, width, height)
    local hw = width / 2
    local hh = height / 2

    -- 1. Solid opaque black backing plate (prevents background bleed-through)
    local bg           = CreateElement "ceMeshPoly"
    bg.name            = name .. "_bg"
    bg.material        = matBlack
    bg.init_pos        = {x, y, 0}
    bg.screenspace     = ScreenType.SCREENSPACE_TRUE
    bg.level           = DEFAULT_LEVEL - 2
    bg.vertices        = {{-hw - 0.015, -hh - 0.015}, {hw + 0.015, -hh - 0.015}, {hw + 0.015, hh + 0.015}, {-hw - 0.015, hh + 0.015}}
    bg.indices         = {0, 1, 2, 0, 2, 3}
    AddElement(bg)

    -- 2. Live Targeting Sensor Video Feed
    local tv           = CreateElement "ceTexPoly"
    tv.name            = name .. "_tv"
    tv.material        = matMfd0
    tv.init_pos        = {x, y, 0}
    tv.screenspace     = ScreenType.SCREENSPACE_TRUE
    tv.level           = DEFAULT_LEVEL - 1
    tv.vertices        = {{-hw, -hh}, {hw, -hh}, {hw, hh}, {-hw, hh}}
    tv.indices         = {0, 1, 2, 0, 2, 3}
    tv.tex_coords      = {{0, 1}, {1, 1}, {1, 0}, {0, 0}}
    AddElement(tv)
end
```

#### Ultrawide & Dynamic Aspect Handling
To support standard 16:9, 21:9 ultrawide, and 32:9 super ultrawide monitors without items clustering in the middle:
```lua
local aspect = (LockOn_Options and LockOn_Options.screen and LockOn_Options.screen.aspect) or (16 / 9)

-- Top-Left Corner:
local tlX = -aspect + (tlW / 2) + marginX
local tlY =  1.0 - (tlH / 2) - marginY

-- Top-Right Corner:
local trX =  aspect - (trW / 2) - marginX
local trY =  1.0 - (trH / 2) - marginY

-- Bottom-Left Corner (MFD):
local mfdX = -aspect + (mfdW / 2) + marginX
local mfdY = -1.0 + (mfdH / 2) + marginY

-- Bottom-Right Corner (Weapons):
local brX =  aspect - (brW / 2) - marginX
local brY = -1.0 + (brH / 2) + marginY
```

---

## 7. Step 6: Avoiding Collisions with Built-in AI Assets

One of the biggest issues modders face:
> *"I installed my mod, but DCS says it cannot load module, or the aircraft still appears as AI."*

### Why This Happens
DCS already has a non-flyable AI asset named `MQ-9 Reaper` in its core database. If your mod declares the exact same internal `Name`:
1. DCS encounters a database key collision.
2. The core DCS database overwrites your `make_flyable` registration with the default AI-only descriptor.
3. The Mission Editor refuses to let the player select "Player" or "Client" skill level.

### The Rule: Use a Unique Internal Name
- **Wrong**: `Name = 'MQ-9 Reaper'`
- **Right**: `Name = 'MQ-9_Reaper_Flyable'`
- Keep the user-facing `DisplayName = _('MQ-9 Reaper (Flyable)')` clean and readable for the Mission Editor menu.

---

## 8. Step 7: Installation & Deployment Structure

Never modify the core DCS installation files (`C:\Program Files\Eagle Dynamics\DCS World\`). Always install community mods into the **Saved Games** directory:

```
C:\Users\<User>\Saved Games\DCS\
└── Mods\
    └── aircraft\
        └── MQ-9 Reaper Flyable\
            ├── entry.lua
            ├── MQ-9.lua
            ├── Views.lua
            ├── comm.lua
            ├── Cockpit\
            │   ├── Scripts\
            │   │   ├── device_init.lua
            │   │   ├── GCS_Controller.lua
            │   │   └── GCS_HUD\
            │   │       ├── init.lua
            │   │       ├── definitions.lua
            │   │       ├── base_page.lua
            │   │       └── indication_page.lua
            │   ├── Shape\
            │   └── Textures\
            ├── Input\
            │   └── MQ-9_Reaper_Flyable\
            │       ├── joystick\
            │       │   └── default.lua
            │       └── keyboard\
            │           └── default.lua
            ├── Shapes\
            │   └── mq-9_reaper.edm
            ├── Textures\
            │   └── mq-9_reaper_textures.zip
            └── Theme\
```

---

## 9. Master Conversion Checklist

Use this quick checklist whenever you want to convert any AI aircraft mod into a flyable aircraft:

| Step | Action | Key Files |
|---|---|---|
| **1** | Choose a unique internal aircraft identifier (e.g. `MyPlane_Flyable`) | `entry.lua`, `[Aircraft].lua` |
| **2** | Add `declare_plugin()` and mount all VFS paths | `entry.lua` |
| **3** | Add `make_flyable('MyPlane_Flyable', cockpit_path, {nil, old = 54}, comm_path)` | `entry.lua` |
| **4** | Set `HumanCockpit = true` and define `crew_members` | `[Aircraft].lua` |
| **5** | Set `CockpitLocalPoint`, `CameraAngleLimits`, and forward `x_trans` in SnapViews | `Views.lua` |
| **6** | Create `Input/MyPlane_Flyable/joystick/default.lua` and `keyboard/default.lua` | `Input/` |
| **7** | Verify vertical slew axes have `invert = false` | `joystick/*.diff.lua` |
| **8** | Create `Cockpit/Scripts/device_init.lua` with indicators and HUD pages | `Cockpit/Scripts/` |
| **9** | Deploy strictly to `Saved Games/DCS/Mods/aircraft/<ModFolder>` | Deployment |
| **10** | Verify in Mission Editor: Aircraft Skill dropdown has **Player** / **Client** | DCS Mission Editor |
