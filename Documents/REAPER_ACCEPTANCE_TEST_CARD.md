# MQ-9 Reaper — Acceptance Test Card
### Yutani Industries · Phase 1 Close-Out (Precision Target Destruction)

**Purpose:** validate the Reaper end-to-end and close the last open Phase-1 item — *precision target destruction under live combat conditions.* Fly each card in order. Mark **PASS / FAIL** and note what you saw; failures map to fixes in §D.

**Mission:** `MQ-9_Reaper_Combat_Patrol` (Single). Spawns airborne at 2,500 m, now 90 m/s, loaded 4× AGM‑114K + 2× GBU‑12, full fuel.

> **Reality note — what is real vs. informational.** The F10 **GCS menu is an information/overlay layer only** (`missionCommands` + on-screen text). It does **not** fire weapons and does **not** set the laser code. All actual employment is the **Su‑25T cockpit**: slave the Shkval to the target, fire the laser, release the SAL weapon. Treat the F10 menu as your kneeboard, not your trigger.

---

## §A — Airworthiness & Energy  *(validates tonight's spawn fix)*

| # | Test | Expected | P/F |
|:--|:--|:--|:--|
| A1 | **Spawn hold.** Load the mission, hands off. | Holds ~2,500 m, ~90 m/s; **no sink, no stall** on spawn. | |
| A2 | **Loaded acceleration.** Full power (RB), hold. | Accelerates cleanly; climbs available. | |
| A3 | **Throttle behaviour.** Ramp with RB/LB, then release. | Power **holds** where set; orbit is not dropped. | |
| A4 | **Orbit hold.** Engage autopilot/orbit (`H` / controller Menu). | Hands-off tangent circle, no altitude bleed to stall. | |

*If A1 sinks:* spawn energy still short — raise mission waypoint speed further (see §D‑1).

---

## §B — Sensor & Laser Designation

| # | Test | Expected | P/F |
|:--|:--|:--|:--|
| B1 | **Camera up.** Toggle sensor/CPG view (`O` / controller `B`). | MTS-B turret view; TV/FLIR. | |
| B2 | **Slew & ground-stabilise.** Slew Shkval to a target, lock. | Gate locks and tracks the ground point. | |
| B3 | **Laser fire.** Arm + fire the designator (`RShift+O` / `Y`). | Laser **active** indication; slant range read-out. | |

*Confirm B3 before any weapon release — SAL weapons need laser energy on the spot in the terminal phase.*

---

## §C — Weapons Employment  *(the open Phase-1 item)*

| # | Test | Setup | Expected | P/F |
|:--|:--|:--|:--|:--|
| C1 | **AGM‑114K Hellfire kill.** | Lock target (Shkval), laser **on**, in range, LOS clear. Fire. | Missile guides to the laser spot; **target destroyed.** | |
| C2 | **GBU‑12 Paveway II kill.** | From altitude/standoff, lock, laser **on** through impact, release. | Bomb guides to spot; **target destroyed.** | |
| C3 | **Repeat / salvo.** | Second target, second weapon. | Consistent guidance & kill. | |

**Acceptance = C1 and C2 both PASS.** That closes Phase 1.

---

## §D — Failure Modes → Fixes

1. **Still sinks on spawn (A1 FAIL).** Waypoint speed too low for the loaded weight/altitude. Raise the mission spawn speed (currently 90 m/s) toward 95–100 m/s, and/or trim fuel. *(Wayland patches the `.miz`.)*
2. **Weapon flies ballistic / no guidance (C1–C2 FAIL).** Most likely a **laser code mismatch** — the Su‑25T laser and the SAL seeker aren't on the same PRF. DCS SAL weapons default to **1688**; the F10 code display is cosmetic and changes nothing. If they won't track, the fix is in the weapon/laser code path, not the menu. *(Report this one first — it's the highest-risk item, and the one that most affects the "dynamic PRF" feature claim.)*
3. **Laser not reaching terminal (weapon falls short/wide).** Laser must stay **on and on-spot through impact**; keep the Shkval locked, don't break track. GBU‑12 also needs enough release altitude/energy to glide to the spot.
4. **Shkval won't lock the ground target.** Ensure ground-stabilised sensor mode, target within FOV, and slant range valid.
5. **Weapon won't release.** Check in-range cue and clear LOS; SAL weapons need line of sight to the designated point.

---

## §E — Sign-off

| Item | Result | Notes |
|:--|:--|:--|
| §A Airworthiness / spawn | | |
| §B Sensor & laser | | |
| §C Weapons (kill) | | |
| **Phase 1 complete?** | | |

> *Building Better Worlds · Fighting in the Name of Peace.* — Yutani Industries
