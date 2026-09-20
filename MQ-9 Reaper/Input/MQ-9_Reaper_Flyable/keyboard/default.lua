local res = external_profile("Config/Input/Aircrafts/base_keyboard_binding.lua")

ignore_features(res.keyCommands, {
    "a2aBVR"
})

-- Helper to assign a key combo to an existing base command in res.keyCommands
local function assignKey(downAction, keyCombo, pressedAction)
    for _, cmd in ipairs(res.keyCommands) do
        if (downAction and cmd.down == downAction) or (pressedAction and cmd.pressed == pressedAction) then
            cmd.combos = cmd.combos or {}
            table.insert(cmd.combos, keyCombo)
            return true
        end
    end
    return false
end

-- Ensure primary base flight & combat keys:
-- Space: Weapon Fire
assignKey(iCommandPlaneFire, {key = 'Space'})

-- W / S: Throttle Up / Throttle Down
assignKey(nil, {key = 'W'}, iCommandThrottleIncrease)
assignKey(nil, {key = 'S'}, iCommandThrottleDecrease)

-- 7: Air-to-Ground Mode
assignKey(iCommandPlaneModeGround, {key = '7'})

-- 1: Navigation Mode
assignKey(iCommandPlaneModeNAV, {key = '1'})

-- A: Autopilot
assignKey(iCommandPlaneAutopilot, {key = 'A'})

-- Add dedicated sensor, targeting, and drone systems commands
join(res.keyCommands, {
    -- Target Lock / Unlock
    {combos = {{key = 'Return'}, {key = 'Enter'}}, down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock'), category = _('Sensors')},
    {combos = {{key = 'Back'}, {key = 'Backspace'}}, down = iCommandSensorReset, name = _('Target Unlock'), category = _('Sensors')},

    -- Sensor Camera (Electro-Optical System) & Laser
    {combos = {{key = 'O'}}, down = iCommandPlaneEOSOnOff, name = _('Electro-Optical System On/Off'), category = _('Sensors')},
    {combos = {{key = 'O', reformers = {'RShift'}}, {key = 'L', reformers = {'RAlt'}}}, down = iCommandPlaneLaserRangerOnOff, name = _('Laser Ranger On/Off'), category = _('Sensors')},
    {combos = {{key = 'O', reformers = {'RCtrl'}}}, down = iCommandPlaneNightTVOnOff, name = _('Night Vision (FLIR or LLTV) On/Off'), category = _('Sensors')},

    -- Target Designator Slew (Keyboard fallback)
    {combos = {{key = ';'}}, pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
    {combos = {{key = '.'}}, pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
    {combos = {{key = ','}}, pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Sensors')},
    {combos = {{key = '/'}}, pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Sensors')},
    {combos = {{key = 'I', reformers = {'RCtrl'}}}, down = iCommandPlaneRadarCenter, name = _('Target Designator To Center'), category = _('Sensors')},

    -- Display Zoom In / Out
    {combos = {{key = '='}}, down = iCommandPlaneZoomIn, name = _('Display Zoom In'), category = _('Sensors')},
    {combos = {{key = '-'}}, down = iCommandPlaneZoomOut, name = _('Display Zoom Out'), category = _('Sensors')},

    -- Autopilot Altitude Hold 'H'
    {combos = {{key = 'H'}}, down = iCommandPlaneSAUHBarometric, name = _('Autopilot - Barometric Altitude Hold \'H\''), category = _('Autopilot')},

    -- Drone Views
    {combos = {{key = 'F1'}}, down = iCommandPlaneViewCockpit, name = _('Flight Seat / Cockpit View'), category = _('View')},
    {combos = {{key = 'F4'}}, down = iCommandViewChase, name = _('External Chase Flight View'), category = _('View')},
    {combos = {{key = 'Tab'}}, down = iCommandViewHUDOnlyOnOff, name = _('Toggle Drone Sensor / HUD View'), category = _('View')},

    -- Weapons Salvo Mode
    {combos = {{key = 'V', reformers = {'LCtrl'}}}, down = iCommandPlaneSalvoOnOff, name = _('Salvo Mode'), category = _('Weapons')},
})

return res
