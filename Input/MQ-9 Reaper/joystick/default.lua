local res = external_profile("Config/Input/Aircrafts/base_joystick_binding.lua")

-- =============================================================================
--  MQ-9 REAPER — XBOX CONTROLLER / GAMEPAD LAYOUT (US GCS "Sensor Operator" style)
-- -----------------------------------------------------------------------------
--  Left Stick  : Fly the aircraft (Roll / Pitch)          [provided by base]
--  RB / LB     : Throttle Up / Down (hold to ramp, holds power when released)
--  Right Stick : Slew the MTS-B sensor ball / target gate
--  A B X Y     : Fire Hellfire / EO On-Off / Target Lock / Weapon Change
--  D-Pad       : Zoom In-Out (U/D), Night-Thermal (L), Laser Designator (R)
--  Bumpers/Clk : View toggle, Alt-Hold, A-G mode, Recenter view
--
--  NOTE: The matching Controller (XBOX ...).diff.lua strips the Su-25T base
--  binds that would otherwise DOUBLE-fire on these buttons (Gun on the trigger,
--  Cannon on LB, Thrust on the shared trigger axis, view-slew on the D-Pad).
--  Together they give a clean, single-function-per-button gamepad map.
-- =============================================================================

join(res.keyCommands,{

-- Face buttons
{combos = {{key = 'JOY_BTN1'}}, down = iCommandPlanePickleOn, up = iCommandPlanePickleOff, name = _('Weapon Release / Launch Hellfire (Controller [A])'), category = _('Weapons')},
{combos = {{key = 'JOY_BTN2'}}, down = iCommandPlaneEOSOnOff, name = _('Optical Sensor / Camera On-Off (Controller [B])'), category = _('Sensors')},
{combos = {{key = 'JOY_BTN3'}}, down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock / Tracking Gate (Controller [X])'), category = _('Sensors')},
{combos = {{key = 'JOY_BTN4'}}, down = iCommandPlaneChangeWeapon, name = _('Cycle Weapon: Hellfire / GBU-12 (Controller [Y])'), category = _('Weapons')},

-- Bumpers = Throttle (press & hold to ramp; power HOLDS when released, so orbit is kept)
{combos = {{key = 'JOY_BTN6'}}, pressed = iCommandThrottleIncrease, up = iCommandThrottleStop, name = _('Throttle Up / More Power (Controller [RB])'), category = _('Flight Control')},
{combos = {{key = 'JOY_BTN5'}}, pressed = iCommandThrottleDecrease, up = iCommandThrottleStop, name = _('Throttle Down / Less Power (Controller [LB])'), category = _('Flight Control')},

-- Menu / stick-click buttons
{combos = {{key = 'JOY_BTN7'}}, down = iCommandViewHUDOnlyOnOff, name = _('Toggle Drone View: Clean Sensor / Chase (Controller [View/Back])'), category = _('View')},
{combos = {{key = 'JOY_BTN8'}}, down = iCommandPlaneSAUHBarometric, name = _('Barometric Altitude Hold Autopilot (Controller [Menu/Start])'), category = _('Autopilot')},
{combos = {{key = 'JOY_BTN9'}}, down = iCommandPlaneModeGround, name = _('Air-To-Ground Mode 7 (Controller [LS Click])'), category = _('Modes')},
{combos = {{key = 'JOY_BTN10'}}, down = iCommandViewCameraCenter, name = _('Recenter Camera / Flight Seat View (Controller [RS Click])'), category = _('View')},

-- D-Pad tactical controls (Zoom & Thermal / Laser)
{combos = {{key = 'JOY_POV1_U'}}, down = iCommandPlaneZoomIn, name = _('Sensor Zoom In (Controller [D-Pad Up])'), category = _('Sensors')},
{combos = {{key = 'JOY_POV1_D'}}, down = iCommandPlaneZoomOut, name = _('Sensor Zoom Out (Controller [D-Pad Down])'), category = _('Sensors')},
{combos = {{key = 'JOY_POV1_L'}}, down = iCommandPlaneNightTVOnOff, name = _('Night Vision / FLIR Thermal WHOT/BHOT (Controller [D-Pad Left])'), category = _('Sensors')},
{combos = {{key = 'JOY_POV1_R'}}, down = iCommandPlaneLaserRangerOnOff, name = _('Laser Ranger / Designator PRF 1688 (Controller [D-Pad Right])'), category = _('Sensors')},

-- Autopilot
{down = iCommandPlaneAutopilot, name = _('Autopilot'), category = _('Autopilot')},
{down = iCommandPlaneSAUHBarometric, name = _('Autopilot - Barometric Altitude Hold \'H\''), category = _('Autopilot')},
{down = iCommandPlaneAutopilotOverrideOn, up = iCommandPlaneAutopilotOverrideOff, name = _('Autopilot override'), category = _('Autopilot')},
{down = iCommandPlaneStabTangBank, name = _('Autopilot - Attitude Hold'), category = _('Autopilot')},
{down = iCommandPlaneStabHbarBank, name = _('Autopilot - Altitude And Roll Hold'), category = _('Autopilot')},
{down = iCommandPlaneStabHorizon, name = _('Autopilot - Transition To Level Flight Control'), category = _('Autopilot')},
{down = iCommandPlaneStabHbar, name = _('Autopilot - Barometric Altitude Hold'), category = _('Autopilot')},
{down = iCommandPlaneStabHrad, name = _('Autopilot - Radar Altitude Hold'), category = _('Autopilot')},
{down = iCommandPlaneRouteAutopilot, name = _('Autopilot - \'Route following\''), category = _('Autopilot')},
{down = iCommandPlaneStabCancel, name = _('Autopilot Disengage'), category = _('Autopilot')},

-- Modes & Systems
{down = iCommandPlaneModeFI0, name = _('(6) Longitudinal Missile Aiming Mode'), category = _('Modes')},
{down = iCommandPlaneModeGround, name = _('(7) Air-To-Ground Mode'), category = _('Modes')},
{down = iCommandPlaneModeGrid, name = _('(8) Gunsight Reticle Switch'), category = _('Modes')},
{down = iCommandSensorReset, name = _('Target Unlock'), category = _('Sensors')},
{down = iCommandPlaneRadarCenter, name = _('Target Designator To Center'), category = _('Sensors')},

-- Weapons
{down = iCommandPlaneSalvoOnOff, name = _('Salvo Mode'), category = _('Weapons')},
{down = iCommandChangeGunRateOfFire, name = _('Cut Of Burst select'), category = _('Weapons')},
{down = iCommandChangeRippleQuantity, name = _('Ripple Quantity Select/SPPU select'), category = _('Weapons')},
{down = iCommandChangeRippleInterval, name = _('Ripple Interval Increase'), category = _('Weapons')},
{down = iCommandChangeRippleIntervalDown, name = _('Ripple Interval Decrease'), category = _('Weapons')},

-- Countermeasures
{down = iCommandActiveIRJamming, name = _('IR Jamming'), category = _('Countermeasures')},
})

-- =============================================================================
--  AXES
--  Roll / Pitch / Thrust / Rudder come from the base profile (Left Stick = flight).
--  The shared trigger axis (JOY_Z) that base maps to Thrust is REMOVED in the
--  controller .diff.lua, so letting go of the triggers no longer drops power.
--  Right Stick drives the MTS-B sensor gate (a real GCS sensor-operator slew).
-- =============================================================================
join(res.axisCommands,{
-- Right Thumbstick -> MTS-B sensor ball / target gate slew
{combos = {{key = 'JOY_RX'}}, action = iCommandPlaneSelecterHorizontalAbs, name = _('Sensor / TDC Slew Horizontal (Right Stick X)')},
{combos = {{key = 'JOY_RY'}}, action = iCommandPlaneSelecterVerticalAbs,   name = _('Sensor / TDC Slew Vertical (Right Stick Y)')},

-- Optional camera/view slew (leave unbound unless you prefer panning the view camera)
{action = iCommandViewHorizontalAbs, name = _('Camera / View Slew Horizontal')},
{action = iCommandViewVerticalAbs,   name = _('Camera / View Slew Vertical')},

-- Optional analog zoom axes
{action = iCommandViewZoomAbs, name = _('Camera Zoom View')},
{action = iCommandPlaneMFDZoomAbs, name = _('Sensor Zoom')},
})

return res
