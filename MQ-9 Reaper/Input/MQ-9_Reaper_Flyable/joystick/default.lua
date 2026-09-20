local res = external_profile("Config/Input/Aircrafts/base_joystick_binding.lua")

ignore_features(res.keyCommands, {
    "a2aBVR"
})

-- 1. Clean conflicting base button combos from base_joystick_binding
-- (e.g. BTN4=Weapon Change, BTN5=Cannon, etc.) so our Xbox mappings take precedence without conflict
for _, cmd in ipairs(res.keyCommands) do
    if cmd.combos then
        local filtered = {}
        for _, c in ipairs(cmd.combos) do
            local k = c.key
            -- Clear buttons 1 through 10 and POV1 from base commands so we assign them cleanly below
            if k ~= 'JOY_BTN1' and k ~= 'JOY_BTN2' and k ~= 'JOY_BTN3' and k ~= 'JOY_BTN4' and
               k ~= 'JOY_BTN5' and k ~= 'JOY_BTN6' and k ~= 'JOY_BTN7' and k ~= 'JOY_BTN8' and
               k ~= 'JOY_BTN9' and k ~= 'JOY_BTN10' and
               not string.find(k, "POV1") then
                table.insert(filtered, c)
            end
        end
        cmd.combos = filtered
    end
end

-- Helper to assign a button combo to an existing base command in res.keyCommands
local function assignKey(downAction, keyStr, pressedAction)
    for _, cmd in ipairs(res.keyCommands) do
        if (downAction and cmd.down == downAction) or (pressedAction and cmd.pressed == pressedAction) then
            cmd.combos = cmd.combos or {}
            table.insert(cmd.combos, {key = keyStr})
            return true
        end
    end
    return false
end

-- Assign existing base commands in-place:
-- [A] Weapon Fire
assignKey(iCommandPlaneFire, 'JOY_BTN1')

-- [LB] Throttle Down
assignKey(nil, 'JOY_BTN5', iCommandThrottleDecrease)

-- [RB] Throttle Up
assignKey(nil, 'JOY_BTN6', iCommandThrottleIncrease)

-- [Start] Autopilot Altitude / Level Hold
if not assignKey(iCommandPlaneSAUHBarometric, 'JOY_BTN8') then
    assignKey(iCommandPlaneAutopilot, 'JOY_BTN8')
end

-- [LS Click] Air-to-Ground Mode 7
assignKey(iCommandPlaneModeGround, 'JOY_BTN9')

-- 2. Add aircraft-specific sensor and weapons commands
join(res.keyCommands, {
    -- [B] Camera / Electro-Optical System On/Off
    {combos = {{key = 'JOY_BTN2'}}, down = iCommandPlaneEOSOnOff, name = _('Electro-Optical System On/Off'), category = _('Sensors')},

    -- [X] Target Lock
    {combos = {{key = 'JOY_BTN3'}}, down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock'), category = _('Sensors')},

    -- [Y] Laser Ranger / Designator On/Off
    {combos = {{key = 'JOY_BTN4'}}, down = iCommandPlaneLaserRangerOnOff, name = _('Laser Ranger On/Off'), category = _('Sensors')},

    -- [Back / View] Target Designator To Center
    {combos = {{key = 'JOY_BTN7'}}, down = iCommandPlaneRadarCenter, name = _('Target Designator To Center'), category = _('Sensors')},

    -- [RS Click] Target Unlock
    {combos = {{key = 'JOY_BTN10'}}, down = iCommandSensorReset, name = _('Target Unlock'), category = _('Sensors')},

    -- Additional sensor & weapon controls for joystick / HOTAS
    -- D-Pad (POV Hat): Dedicated Optical Zoom, FLIR Mode & Centering (Right Stick handles smooth analog slew)
    {combos = {{key = 'JOY_BTN_POV1_U'}}, down = iCommandPlaneZoomIn, name = _('Display Zoom In'), category = _('Sensors')},
    {combos = {{key = 'JOY_BTN_POV1_D'}}, down = iCommandPlaneZoomOut, name = _('Display Zoom Out'), category = _('Sensors')},
    {combos = {{key = 'JOY_BTN_POV1_L'}}, down = iCommandPlaneRadarCenter, name = _('Target Designator To Center'), category = _('Sensors')},
    {combos = {{key = 'JOY_BTN_POV1_R'}}, down = iCommandPlaneNightTVOnOff, name = _('Night Vision (FLIR or LLTV) On/Off'), category = _('Sensors')},

    -- Additional sensor & weapon controls for keyboard / HOTAS
    {down = iCommandPlaneChangeWeapon, name = _('Weapon Change'), category = _('Weapons')},
    {down = iCommandPlaneSalvoOnOff, name = _('Salvo Mode'), category = _('Weapons')},
    {down = iCommandActiveIRJamming, name = _('IR Jamming'), category = _('Countermeasures')},
    {pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
    {pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
    {pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Sensors')},
    {pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Sensors')},
})

-- Joystick & Gamepad Axes: Left Stick = Flight, Right Stick = Gimbal Camera Slew
join(res.axisCommands, {
    {combos = defaultDeviceAssignmentFor("roll"), action = iCommandPlaneRoll, name = _('Roll')},
    {combos = defaultDeviceAssignmentFor("pitch"), action = iCommandPlanePitch, name = _('Pitch')},
    {combos = defaultDeviceAssignmentFor("thrust"), action = iCommandPlaneThrustCommon, name = _('Thrust')},
    {action = iCommandPlaneRudder, name = _('Rudder')},

    -- Dedicated Right Thumbstick Gimbal Camera & Sensor Slew Axes
    {combos = {{key = 'JOY_RX'}}, action = iCommandPlaneSelecterHorizontalAbs, name = _('I-251 Slew Horizontal')},
    {combos = {{key = 'JOY_RY'}}, action = iCommandPlaneSelecterVerticalAbs,   name = _('I-251 Slew Vertical')},
    {action = iCommandViewHorizontalAbs, name = _('Absolute Camera Horizontal View')},
    {action = iCommandViewVerticalAbs,   name = _('Absolute Camera Vertical View')},
    {action = iCommandViewZoomAbs, name = _('Zoom View')},
    {action = iCommandPlaneMFDZoomAbs, name = _('I-251 Zoom')},
})

return res
