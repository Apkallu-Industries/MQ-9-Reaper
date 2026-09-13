# Autonomous Drone Asset Pack (ADAP) :: Future Development Roadmap
## Pending Features & Strategic Evolution

---

## 1. Feature Status Matrix

| Capability / Feature | Status | Priority | Target Milestone |
| :--- | :--- | :--- | :--- |
| **DCS 2.9+ Engine Compatibility & Spawn Fixes** | **COMPLETE** | Highest | v2.9.0 |
| **MTS-B Screenspace Targeting HUD & Crosshair** | **COMPLETE** | Highest | v2.9.1 |
| **Mouse Target Lock (RMB) & Smoke Marking** | **COMPLETE** | High | v2.9.1 |
| **Autonomous Tangent-Orbit Flight Director** | **COMPLETE** | High | v2.9.1 |
| **432d Wing Insignia, Kneeboard & Liveries** | **COMPLETE** | High | v2.9.2 |
| **Dedicated 3D GCS Container Cockpit Model** | **IN PROGRESS** | High | v3.0.0 |
| **Dual Interactive MFDs (TSD Moving Map + Sensor)** | **PLANNED** | High | v3.1.0 |
| **True FLIR White-Hot / Black-Hot Thermal Shaders** | **PLANNED** | Medium | v3.2.0 |
| **Dynamic AI-to-Human Handover (`BlackHorseISR.lua`)** | **PLANNED** | Medium | v3.3.0 |
| **RQ-28A Micro Recon Drone Integration** | **PLANNED** | Medium | ADAP Phase 2 |
| **ASD-1 'Ghost Sniper' UGV Integration** | **PLANNED** | Medium | ADAP Phase 3 |

---

## 2. Detailed Pending Feature Specifications

### 2.1. Dedicated 3D Ground Control Station (GCS) Container Cockpit
* **Problem Statement**:
  The mod currently uses the Su-25T 3D cockpit model hidden behind the nose sensor camera. While functional, it does not provide the authentic experience of sitting inside an unmanned operations center.
* **Proposed Solution**:
  * Create a custom 3D interior model (`Cockpit_Reaper_GCS.EDM`) depicting an authentic **USAF MQ-9 GCS shipping container console**:
    * Dual operator workstations: Pilot station (Left) and Sensor Operator station (Right).
    * Dual high-definition monitors per station with anti-glare hoods.
    * Server racks with status LEDs, tactical air conditioning ducting, and communication audio panels.
    * Dual HOTAS throttle quadrants and flight sticks modeled accurately.
  * Full 6-DOF head-tracking support (TrackIR / VR) allowing the player to look around the interior of the ground trailer while viewing the combat zone on the console monitors.

```
       +-------------------------------------------------------------+
       |             USAF MQ-9 GCS CONTAINER COCKPIT MESH            |
       +-------------------------------------------------------------+
       |                                                             |
       |    [ PILOT STATION (LEFT) ]     [ SENSOR OPERATOR (RIGHT) ] |
       |    +----------------------+     +-------------------------+ |
       |    | [SCREEN 1] [SCREEN 2]|     | [SCREEN 3]  [SCREEN 4]  | |
       |    |  TSD Map    HUD Feed |     |  EO/IR Cam   Datalink   | |
       |    +----------------------+     +-------------------------+ |
       |        [YOKE & THROTTLE]             [SENSOR JOYSTICK]      |
       |                                                             |
       +-------------------------------------------------------------+
```

---

### 2.2. Dual Interactive Multi-Function Displays (MFDs)
* **Left MFD: Tactical Situation Display (TSD) / Moving Map**:
  * Real-time vector map rendering terrain elevation, flight path breadcrumbs, waypoints, and bullseye reference.
  * Live SAM threat rings and radar coverage envelopes.
  * Engine telemetry: Fuel remaining (kg), fuel flow rate (kg/min), oil pressure, and turbine RPM.
* **Right MFD: Multi-Spectral Sensor Feed**:
  * Real-time Raytheon MTS-B camera feed with optical zoom and depression readouts.
  * Push-button bezel keys (OSBs) allowing the operator to cycle sensor modes (EO Color, LLTV Low-Light, MWIR FLIR).
  * Direct clickable interface for laser coding, tracker mode selection (Area Track / Point Track), and laser rangefinder arming.

---

### 2.3. True Dual-Band FLIR Thermal Shaders
* **Current State**:
  DCS CWS provides standard daylight TV with basic monochrome contrast (`RCtrl + O`).
* **Target Feature**:
  * Integration with modern DCS World 2.9+ FLIR rendering technology.
  * True **White-Hot / Black-Hot** thermal rendering where running vehicle engines, exhaust manifolds, tank tracks, and live human troops emit distinct infrared heat signatures.
  * Ambient ground thermal inertia simulation (hot asphalt roads vs cool river valleys at sunset).

---

### 2.4. Autonomous AI-to-Human Dynamic Handover (`BlackHorseReaperISR.lua`)
* **Mission Need**:
  In long-duration combat missions and dynamic campaigns, human players should not have to manually fly the drone through 45 minutes of transit flight.
* **Functionality**:
  * The Reaper spawns as an autonomous AI asset, takes off from base, climbs to 25,000 ft, and flies to its designated combat overwatch zone.
  * When a human player slots in, the script detects the connection and transitions control seamlessly to the player station.
  * If the player disconnects, crashes, or commands `Loiter & Handover`, the aircraft automatically returns to autonomous AI patrol, preserving the asset in persistent campaigns.

---

### 2.5. Multi-Domain Autonomous Drone Asset Pack (ADAP) Expansion

#### Phase 2: RQ-28A Micro Tactical Recon Drone
* Backpack-deployable squad-level micro-UAV.
* Provides low-altitude urban recon for infantry platoons and forward air controllers.
* Equipped with Laser Spot Tracker / Relay on PRF code `1685`, allowing infantry to illuminate targets for overhead MQ-9 Hellfire strikes.

#### Phase 3: ASD-1 "Ghost Sniper" UGV
* Tracked autonomous ground combat robot for perimeter defense and compound assault.
* Independent 360° stabilized remote weapon station (RWS) with precision heavy sniper rifle.
* Synchronized laser hand-off (PRF `1681`) to receive target coordinates directly from overhead Reaper surveillance.
