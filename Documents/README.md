# MQ-9 Reaper (Flyable Mod) :: Official Documentation Suite
## Autonomous Drone Asset Pack (ADAP) — DCS World 2.9+

---

## Document Index

This `Documents/` directory contains the complete technical archive, engineering history, operational guides, and forward-looking strategic roadmap for the **General Atomics MQ-9 Reaper** flyable mod in modern DCS World.

| Document | Description |
| :--- | :--- |
| **[01. Repair & Migration Log (DCS 2.9+)](file:///c:/Dev/AutonomousDronePack/MQ-9%20Reaper/MQ-9%20Reaper/Documents/REPAIR_AND_MIGRATION_LOG_DCS_2.9.md)** | Full breakdown of all legacy failure modes (UTF-8 BOM, spawn drops, memory violations, missing textures, camera misalignment, forward-slash zip bug, missing crosshair) and the engineering solutions implemented to restore full flight and combat capability. |
| **[02. Operations & Combat Manual](file:///c:/Dev/AutonomousDronePack/MQ-9%20Reaper/MQ-9%20Reaper/Documents/CURRENT_CAPABILITIES_AND_OPERATIONS.md)** | Comprehensive flight, sensor, and combat manual: GCS tactical radio menu, flight director autopilot modes, MTS-B targeting gimbal reticle, precision ground marking, Hellfire & Paveway delivery, and kneeboard usage. |
| **[03. Strategic Development Roadmap](file:///c:/Dev/AutonomousDronePack/MQ-9%20Reaper/MQ-9%20Reaper/Documents/FUTURE_ROADMAP.md)** | The evolutionary roadmap for pending capabilities: dedicated 3D GCS shipping container interior, dual MFD glass displays (TSD + Sensor), FLIR thermal rendering, and multi-domain drone integration (RQ-28A & ASD-1 UGV). |
| **[04. Next-Level Innovations (Pushing DCS Limits)](file:///c:/Dev/AutonomousDronePack/MQ-9%20Reaper/MQ-9%20Reaper/Documents/NEXT_LEVEL_INNOVATIONS_DCS_LIMITS.md)** | Bleeding-edge concepts feasible within DCS World architecture: WebRTC live ROVER video streaming to real tablets, ATAK/CivTAK live Cursor-on-Target UDP bridge, Voice AI JTAC operator, Computer Vision auto-tracking, and MUM-T swarm mesh networks. |

---

## Core System Architecture Overview

```
Mods/aircraft/MQ-9 Reaper/
├── entry.lua                           # Layer 1: Plugin declaration, VFS mounts, flyable binding
├── MQ-9.lua                            # Layer 2: Aircraft descriptor (SFM, weights, pylons, crew_members)
├── Views.lua                           # Layer 3: MTS-B gimbal camera geometry & 6-DOF limits
├── Cockpit/                            # Layer 4: Avionics, Cockpit Weapon System (CWS), HUD & Kneeboard
│   ├── Scripts/
│   │   ├── device_init.lua             # CWS + Kneeboard + GCS_HUD indicators declaration
│   │   ├── GCS_HUD/                    # Screenspace 2D targeting crosshair & telemetry OSD
│   │   │   ├── init.lua
│   │   │   ├── definitions.lua
│   │   │   ├── base_page.lua
│   │   │   └── indication_page.lua
│   │   └── kneeboard_init.lua
│   ├── KneeboardLeft/                  # Left kneeboard device scripts
│   ├── Shape/                          # Cockpit 3D interior meshes
│   └── Textures/                       # Cockpit texture archives
├── Input/                              # Layer 5: Control profile mappings (keyboard, mouse, joystick)
│   └── MQ-9 Reaper/
│       ├── keyboard/default.lua        # Flight controls, camera views, autopilot hotkeys
│       └── mouse/default.lua           # Mouse flight yoke, LMB fire, RMB target lock/mark
├── Kneeboard/                          # In-game tactical flight chart (432d Wing briefing & specs)
├── Liveries/                           # Aircraft paint schemes (432d Reapers, Camo, UK, FR, IT)
├── Missions/                           # Single-player combat patrol mission (.miz)
├── Theme/                              # GUI theme: 86x86 icons, ME logos, Main Menu branding
├── reaper_gcs_menu.lua                 # Tactical GCS mission director & controller task script
├── repack_and_deploy.ps1               # Automated deployment pipeline with DCS Lua validation
└── Documents/                          # Master technical documentation suite
```
