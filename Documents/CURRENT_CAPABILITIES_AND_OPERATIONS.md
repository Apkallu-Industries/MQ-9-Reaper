# MQ-9 Reaper Operations & Combat Manual
## Autonomous Drone Asset Pack (ADAP) — Pilot & Sensor Operator Guide

---

## 1. Aircraft Specifications & Performance

| Parameter | Specification | Tactical Relevance |
| :--- | :--- | :--- |
| **Wingspan** | 20.0 m (66 ft) | High aspect-ratio glider-style wing for maximum endurance. |
| **Empty / Max Weight** | 2,223 kg / 4,760 kg | Heavy armed payload capacity for multi-hour loiter. |
| **Propulsion** | Honeywell TPE331-10GD Turboprop (900 shp) | Pusher-propeller configuration behind V-tail. |
| **Operational Ceiling** | 15,000 m (50,000 ft MSL) | Standoff altitude above short-range MANPADS & AAA. |
| **Optimum Cruise Speed** | 130 – 160 kts (65 – 80 m/s) | Steady loiter speed for stable optical tracking. |
| **Standard Orbit Altitude** | 2,420 m – 2,500 m MSL (approx 8,200 ft) | Optimal cloud clearance and Hellfire seeker acquisition. |
| **Radar Cross Section (RCS)**| 0.5 m² | Low acoustic and radar observable footprint. |

---

## 2. Decoupled Two-Station Control Architecture

The MQ-9 Reaper is operated as two synchronized stations:

```
               +======================================================+
               |        MQ-9 REAPER TACTICAL FLIGHT ARCHITECTURE       |
               +======================================================+
                                          |
                 +------------------------+------------------------+
                 |                                                 |
                 v                                                 v
    [ STATION 1: FLIGHT PILOT ]                  [ STATION 2: SENSOR OPERATOR ]
    ---------------------------                  ------------------------------
    * Forward Navigation & Thrust                * Raytheon MTS-B Gimbal Turret
    * Barometric Altitude Hold (H)               * 23x Optical Telephoto Zoom
    * Autonomous Tangent Orbit                   * Precision Boresight Aiming Pip
    * F1: Clean Sensor View                      * Right Mouse Button (RMB) Lock
    * F4: External Chase View                    * NATO Laser Designator (PRF 1688)
    * Tab: Instant View Toggle                   * AGM-114K Hellfire & GBU-12 Release
```

---

## 3. Flight Controls & Autopilot System

### Primary Keyboard & Mouse Flight Controls:
* **Throttle**: `[ W ]` (Increase Speed) / `[ S ]` (Decrease Speed)
* **Roll (Ailerons)**: `[ A ]` (Left) / `[ D ]` (Right)
* **Yaw (Rudder)**: `[ Q ]` (Left) / `[ E ]` (Right)
* **Pitch (Elevator)**:
  * Climb: `[ R ]`, `[ Space ]`, or `[ Down Arrow ]`
  * Descend: `[ F ]`, `[ C ]`, or `[ Up Arrow ]`
* **Mouse Flight Yoke**: `Mouse X` (Roll) / `Mouse Y` (Pitch)
* **View Toggle**: `[ F1 ]` or `[ Tab ]` toggles between Clean Drone Sensor View and Chase View.

### Xbox Controller Layout (US GCS "Sensor Operator" Style):

The controller is mapped so a single pad flies the aircraft **and** runs the MTS-B sensor, with one function per button (no double-binds) and a throttle that **holds its setting** so the drone stays in orbit hands-off.

```
      LB  ── Throttle DOWN            RB  ── Throttle UP            (hold to ramp, holds power on release)
     ┌───────────────────────────────────────────────────────────┐
     │   [LS]  Fly: Roll / Pitch              [RS]  Slew MTS-B     │
     │   [LS click] A-G Mode (7)              [RS click] Recenter  │
     │                                                             │
     │        View/Back ── Sensor/Chase view toggle               │
     │        Menu/Start ── Barometric Altitude Hold              │
     │                                                             │
     │     D-Pad Up ── Zoom In            (Y) ── Cycle Weapon      │
     │     D-Pad Dn ── Zoom Out           (B) ── EO Camera On/Off  │
     │     D-Pad Lt ── Night/Thermal      (X) ── Target Lock       │
     │     D-Pad Rt ── Laser Designator   (A) ── Launch Hellfire   │
     └───────────────────────────────────────────────────────────┘
```

| Control | Function |
| :--- | :--- |
| **Left Stick** | Fly the aircraft — Roll (X) / Pitch (Y) |
| **Right Stick** | Slew the MTS-B sensor ball / target gate |
| **RB** / **LB** | Throttle Up / Down — hold to ramp, **power holds** when released (keeps orbit) |
| **A** | Weapon Release / Launch Hellfire |
| **B** | Electro-Optical (EO) Camera On/Off |
| **X** | Target Lock / Tracking Gate |
| **Y** | Cycle Weapon (AGM-114 Hellfire ↔ GBU-12) |
| **D-Pad Up / Down** | Sensor Zoom In / Out |
| **D-Pad Left** | Night Vision / FLIR Thermal (WHOT/BHOT) |
| **D-Pad Right** | Laser Ranger / Designator (PRF 1688) |
| **View / Back** | Toggle Clean Sensor View ↔ Chase View |
| **Menu / Start** | Barometric Altitude Hold Autopilot |
| **LS Click** | Air-to-Ground Mode (7) |
| **RS Click** | Recenter Camera / Flight Seat View |

> **Why throttle is on the bumpers, not the triggers:** the Xbox triggers share a single axis that re-centers to ~50% when released, which would snap engine power to half and drop the drone out of its orbit. Mapping throttle to **RB/LB as press-and-hold ramps** means the power stays exactly where you leave it — the way a real GCS throttle quadrant behaves.

### Autonomous Flight Director (F10 Radio Menu):
Open the menu by pressing **`[ \ ]`** (or communication key) $\rightarrow$ **`[ F10 Other ]`** $\rightarrow$ **`[ F1: FLIGHT & AUTOPILOT ]`**:
1. **F1: Maintain Heading**: Wings-level magnetic compass vector hold. Locks current heading and dampens yaw drift.
2. **F2: Maintain Altitude**: Barometric altitude hold. Engages pitch trim and engine power modulation to lock reference altitude (e.g. 2,500m).
3. **F3: Maintain Orbit (Tangent Loiter)**:
   * Commands the aircraft into an automated **2,500m radius orbit**.
   * Employs a mathematically calculated circle center 2,500m tangent to the current heading, resulting in a gentle, level **12-degree bank angle**.
   * Drone holds altitude and airspeed indefinitely hands-off, allowing the operator to focus entirely on sensor slewing and weapons delivery.
4. **F4: Toggle Orbit Direction**: Reverses circle between Clockwise (Right turn) and Counter-Clockwise (Left turn).
5. **F5: Navigate to Next Waypoint**: Directs the flight director to proceed to target area waypoints.
6. **F6: Manual Flight Control Override**: Disengages all autonomous tasks and returns 100% manual control to the player stick.

---

## 4. Raytheon MTS-B Targeting Reticle & Sensor HUD

The custom **GCS_HUD** (`Cockpit/Scripts/GCS_HUD/`) renders an authentic, military-grade targeting display directly on the operator's screen:

```
        MQ-9 REAPER MTS-B SENSOR          AZ  000°          LASER: 1688 PRF [ARMED]
        OPTIC : 23x OPTICAL ZOOM       ---|---|---|---      MODE : GROUND TARGET MARK
        STAB  : 3-AXIS GYRO LOCK         360° COMPASS       FOV  : 4.8° NFOV
                                                                  +10°
                                                                    0° (HORIZON)
                                   +------+   +------+            -15°
                                   |                 |        <--- -30° (ELEVATION)
                                   |                 |            -45°
                                           *                      -60°
                                       (0, 0) PIP                 -90° (NADIR)
                                   |                 |
                                   |                 |
                                   +------+   +------+
                                       
                                [ GROUND TARGET MARK POINT ]
                              +--- SENSOR BORESIGHT TRACK ---+

        RMB   : MARK TARGET / LOCK                          WPN  : AGM-114K HELLFIRE
        LMB   : WEAPON RELEASE                              STAS : 1-4 STANDBY / ARMED
        DLINK : LINK-16 / ROVER VDL                         TRACK: POINT LOCK READY
```

### Key Reticle Elements:
1. **Precision Center Aiming Dot (`0, 0`)**: Pixel-accurate green pip with charcoal shadow backing that designates the exact physical spot on the ground where the sensor is pointing.
2. **4 Crosshair Arms with Aiming Gap**: Horizontal and vertical mil-graduated stadia lines with an open center gap (`±0.024`) so ground targets are never obscured by crosshair lines.
3. **Target Acquisition Brackets (`[   ]`)**: Framing the center tracking area.
4. **Outer Circular Reticle**: Segmented 4-quadrant ring with 12/3/6/9 o'clock cardinal pointers.
5. **Azimuth Compass Tape (Top)**: Real-time compass scale with center index caret (`V`) and digital heading readout.
6. **Elevation Depression Scale (Right)**: Vertical ladder marking depression from `0°` (Horizon) down to `-90°` (Nadir) with active pointer (`<`).
7. **Dual-Layer High-Contrast Styling**: Phosphor green (`{0, 255, 70, 240}`) over dark charcoal backing (`{0, 0, 0, 210}`) for 100% visibility against sand, snow, water, foliage, and night thermals.

---

## 5. Target Marking & Ground Designation

### Direct Mouse Ground Locking:
* **Right Mouse Button (`MOUSE_BTN2`)** or **`[ Enter ]`**: Executes `iCommandPlaneChangeLock`. Immediately commands the targeting computer to lock onto the ground point directly beneath the center aiming dot.

### Visual Smoke & F10 Map SPI Deployment:
Open the F10 menu: **`[ \ ]`** $\rightarrow$ **`[ F10 Other ]`** $\rightarrow$ **`[ F3: GIMBAL CAMERA & LASER ]`**:
* **F5: Mark Target Ground Spot**:
  * Calculates the exact ground intersection point 4,000m forward of the aircraft.
  * Ignites a **visual Red Phosphorus smoke marker** on the ground (`trigger.action.smoke`) visible from both the air and ground units.
  * Places a persistent **F10 Tactical Map Marker** (`trigger.action.markToAll`) with laser PRF code for all coalition aircraft and JTACs.
* **F6 $\rightarrow$ F1: Broadcast Target SPI to Coalition (Link-16 / SADL)**:
  * Transmits coordinates and active laser code to all Blue coalition assets.

---

## 6. Weapons Employment: Hellfire & Paveway II

### Payload Configuration:
* **Station 1 & 4 (Outboard)**: 2× AGM-114K Hellfire SAL-2 Semi-Active Laser Missiles.
* **Station 2 & 3 (Inboard)**: 1× GBU-12 Paveway II 500 lb Laser-Guided Bomb.

### Weapon Delivery Checklist:
1. **Arm Master & Warheads**:
   * Press `\` $\rightarrow$ `F10 Other` $\rightarrow$ `F2: Weapons & Stores` $\rightarrow$ `F2: Arm Warheads & Laser Seekers`.
2. **Select Ordnance**:
   * Press `[ MOUSE_BTN3 ]` or `[ D ]` (or F10 Menu `F2-1`) to cycle between AGM-114K and GBU-12.
3. **Engage Orbit**:
   * Command automated loiter via F10 Menu `F1-3` (Maintain Orbit) to stabilize the flight path.
4. **Deploy Sensor Camera & Slew**:
   * Press `[ O ]` to ensure sensor camera optics are active.
   * Slew camera using mouse or `; . , /` to place the center aiming dot over the hostile vehicle or compound.
5. **Lock Target**:
   * Click **Right Mouse Button (RMB)** or press **`[ Enter ]`** to engage ground lock.
6. **Activate Laser Designator**:
   * Press `[ RShift + O ]` or F10 Menu `F3-3: Laser Designator - EMIT LASER ON`.
   * Verify PRF code (default `1688`).
7. **Fire**:
   * Click **Left Mouse Button (LMB)** or press **`[ Return ]`** / **`[ Space ]`**.
   * Maintain crosshair on target until weapon impact.

---

## 7. In-Game Kneeboard Briefing (`RShift + K`)

Pressing **`[ Right Shift + K ]`** opens the custom in-game Kneeboard flight chart ([01_Reaper_Squadron_Briefing.png](file:///c:/Dev/AutonomousDronePack/MQ-9%20Reaper/MQ-9%20Reaper/Kneeboard/01_Reaper_Squadron_Briefing.png)):
* High-resolution 768×1024 tactical briefing sheet.
* Features the **432d Attack Wing "MORS AB ALTO"** squadron insignia.
* Displays sensor zoom limits, NATO PRF codes, weapon hardpoint counts, and HOTAS shortcut references for in-cockpit consultation.

---

## 8. Available Aircraft Liveries

Selectable in the Mission Editor or in-flight ground crew re-arming menu (`\ -> F8`):
1. **`432d 'Reapers' Strike Squadron (Mors Ab Alto)`**: Official squadron livery featuring embroidered emblems on forward fuselage and V-tail fins.
2. **`standard`**: Standard USAF low-visibility haze gray.
3. **`'camo' scheme`**: Tactical multi-terrain disruptive camouflage.
4. **`standard UK`**: Royal Air Force (RAF) No. 39 Squadron roundels and flash.
5. **`standard France`**: French Air and Space Force (Armée de l'Air) roundels.
6. **`standard Italy`**: Italian Air Force (Aeronautica Militare) 32° Stormo roundels.
