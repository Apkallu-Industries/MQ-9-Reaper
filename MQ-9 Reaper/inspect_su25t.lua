package.preload['log'] = function() return { write = function() end, alert = function() end } end
package.preload['i_18n'] = function() return { _ = function(s) return s end, gettext = { translate = function(s) return s end, dgettext = function(d,s) return s end } } end
package.preload['i18n'] = function() return { _ = function(s) return s end } end
package.preload['textutil'] = function() return { Utf8Compare = function(a,b) return a < b end } end
package.path = './Scripts/Input/?.lua;' .. package.path
local Utils = require('Utils')

_ = function(s) return s end
folder = 'Mods/aircraft/Su-25T/Input/su-25T/joystick/'
local def = dofile('Mods/aircraft/Su-25T/Input/su-25T/joystick/default.lua')

local targetNames = {
    'Weapon Fire', 'Electro-Optical System On/Off', 'Target Lock',
    'Laser Ranger On/Off', 'Throttle Down', 'Throttle Up',
    'Target Designator To Center', "Autopilot - Barometric Altitude Hold 'H'",
    '(7) Air-to-Ground Modes', 'Target Unlock', 'Display Zoom In',
    'Display Zoom Out', 'Night Vision (FLIR or LLTV) On/Off', 'Weapon Change',
    'Throttle Step Up', 'Throttle Step Down', 'Target Designator Up', 'Target Designator Down'
}

print('=== MATCHED COMMANDS IN SU-25T JOYSTICK PROFILE ===')
for _, cmd in ipairs(def.keyCommands) do
    for _, t in ipairs(targetNames) do
        if cmd.name == t or cmd.name:find(t, 1, true) then
            local hash = Utils.getKeyCommandHash(cmd)
            print(string.format('%-35s | hash: %s | down: %s | pressed: %s | up: %s', cmd.name, hash, tostring(cmd.down), tostring(cmd.pressed), tostring(cmd.up)))
        end
    end
end
print('=== AXES IN SU-25T JOYSTICK PROFILE ===')
for _, ax in ipairs(def.axisCommands) do
    local hash = Utils.getAxisCommandHash(ax)
    print(string.format('%-35s | hash: %s | action: %s', ax.name, hash, tostring(ax.action)))
end
