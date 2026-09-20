-- =====================================================================================
-- MQ-9 REAPER TACTICAL GIMBAL & SENSOR SLAVE CONTROLLER
-- Slaves the optical targeting pod (Shkval / IT-23 sensor) directly to the Gimbal Camera
-- line of sight, with ground-stabilized tracking lock bypass.
-- =====================================================================================

local slave_enabled = true

function LuaExportStart()
    slave_enabled = true
end

function LuaExportBeforeNextFrame()
    if not LoGetSelfData then return end
    local self = LoGetSelfData()
    if not self or not self.Name then return end

    -- Only active when flying the MQ-9 Reaper
    if not string.find(self.Name, "MQ%-9") then return end

    -- If target is currently locked (ground-stabilized point track), let lock hold!
    if LoGetLockedTargetInformation then
        local locked = LoGetLockedTargetInformation()
        if locked and #locked > 0 then return end
    end

    local cam = LoGetCameraPosition()
    local sight = LoGetSightingSystemInfo()
    if not cam or not cam.x then return end
    -- Optical sensor initialization
    if not sight or not sight.ScanZone or not sight.ScanZone.position then
        if not eos_requested then
            LoSetCommand(276) -- Automatically engage EOS optical sensor at start
            eos_requested = true
        end
        return
    else
        eos_requested = false
    end
end

function LuaExportAfterNextFrame()
end

function LuaExportStop()
end

