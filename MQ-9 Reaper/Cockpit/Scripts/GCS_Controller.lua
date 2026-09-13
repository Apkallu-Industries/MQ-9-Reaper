-- MQ-9 Reaper GCS Gimbal Camera & Sensor Controller
-- Handles automated gimbal activation on D-Pad slew away from flight view,
-- and deactivation when returned to forward flight view or when F1 is pressed.

local dev = GetSelf()
local update_time_step = 0.02 -- 50 Hz update
make_default_activity(update_time_step)

local GIMBAL_ACTIVE    = get_param_handle("GIMBAL_ACTIVE")
local GIMBAL_ELEVATION = get_param_handle("GIMBAL_ELEVATION")
local GIMBAL_AZIMUTH   = get_param_handle("GIMBAL_AZIMUTH")

-- Initial state at mission spawn:
-- Gimbal is inactive (clean flight camera view)
local is_active   = 0
local elevation   = 0.0 -- 0.0 = forward flight boresight / horizon
local azimuth     = 0.0 -- 0.0 = straight ahead
local slew_pitch  = 0   -- -1 = down, 1 = up, 0 = stopped
local slew_yaw    = 0   -- -1 = left, 1 = right, 0 = stopped

local SLEW_SPEED  = 25.0 -- degrees per second

GIMBAL_ACTIVE:set(0)
GIMBAL_ELEVATION:set(0)
GIMBAL_AZIMUTH:set(0)

-- Command IDs
local CMD_RADAR_UP      = 90
local CMD_RADAR_DOWN    = 91
local CMD_RADAR_LEFT    = 88
local CMD_RADAR_RIGHT   = 89
local CMD_RADAR_CENTER  = 92
local CMD_RADAR_STOP    = 93
local CMD_EOS_ON_OFF    = 87

local CMD_VIEW_UP       = 8
local CMD_VIEW_DOWN     = 9
local CMD_VIEW_LEFT     = 10
local CMD_VIEW_RIGHT    = 11
local CMD_VIEW_CENTER   = 12
local CMD_VIEW_STOP     = 13
local CMD_VIEW_F1       = 1
local CMD_VIEW_HUD_ONLY = 344

-- Register listeners
dev:listen_command(CMD_RADAR_UP)
dev:listen_command(CMD_RADAR_DOWN)
dev:listen_command(CMD_RADAR_LEFT)
dev:listen_command(CMD_RADAR_RIGHT)
dev:listen_command(CMD_RADAR_CENTER)
dev:listen_command(CMD_RADAR_STOP)
dev:listen_command(CMD_EOS_ON_OFF)

dev:listen_command(CMD_VIEW_UP)
dev:listen_command(CMD_VIEW_DOWN)
dev:listen_command(CMD_VIEW_LEFT)
dev:listen_command(CMD_VIEW_RIGHT)
dev:listen_command(CMD_VIEW_CENTER)
dev:listen_command(CMD_VIEW_STOP)
dev:listen_command(CMD_VIEW_F1)
dev:listen_command(CMD_VIEW_HUD_ONLY)

function SetCommand(command, value)
    -- D-Pad Down / Slew Down
    if command == CMD_RADAR_DOWN or command == CMD_VIEW_DOWN then
        slew_pitch = -1
    -- D-Pad Up / Slew Up
    elseif command == CMD_RADAR_UP or command == CMD_VIEW_UP then
        slew_pitch = 1
    -- Stop Vertical / Horizontal Slew
    elseif command == CMD_RADAR_STOP or command == CMD_VIEW_STOP then
        slew_pitch = 0
        slew_yaw   = 0
    -- D-Pad Left / Slew Left
    elseif command == CMD_RADAR_LEFT or command == CMD_VIEW_LEFT then
        slew_yaw = -1
    -- D-Pad Right / Slew Right
    elseif command == CMD_RADAR_RIGHT or command == CMD_VIEW_RIGHT then
        slew_yaw = 1
    -- Center / Reset (RCtrl + I or Num 5)
    elseif command == CMD_RADAR_CENTER or command == CMD_VIEW_CENTER then
        elevation  = 0.0
        azimuth    = 0.0
        slew_pitch = 0
        slew_yaw   = 0
        is_active  = 0
        GIMBAL_ACTIVE:set(0)
    -- F1 / Return to Flight Seat
    elseif command == CMD_VIEW_F1 or command == CMD_VIEW_HUD_ONLY then
        elevation  = 0.0
        azimuth    = 0.0
        slew_pitch = 0
        slew_yaw   = 0
        is_active  = 0
        GIMBAL_ACTIVE:set(0)
    -- EOS Optical Toggle
    elseif command == CMD_EOS_ON_OFF then
        if is_active == 1 then
            is_active = 0
            GIMBAL_ACTIVE:set(0)
        else
            is_active = 1
            if elevation > -5.0 then
                elevation = -15.0
            end
            GIMBAL_ACTIVE:set(1)
        end
    end
end

function update()
    -- Attempt to query camera position from DCS if available
    local has_cam, cam = pcall(function() return LoGetCameraPosition and LoGetCameraPosition() end)
    if has_cam and type(cam) == "table" and cam.x and cam.x.y then
        local cam_pitch = math.deg(math.asin(math.max(-1.0, math.min(1.0, cam.x.y))))
        if cam_pitch < -4.0 then
            is_active = 1
            elevation = cam_pitch
        elseif cam_pitch >= -2.0 and is_active == 1 and slew_pitch == 0 then
            is_active = 0
            elevation = 0.0
        end
    else
        -- Update elevation and azimuth via slew rate integration
        if slew_pitch ~= 0 then
            elevation = elevation + (slew_pitch * SLEW_SPEED * update_time_step)
            if elevation < -85.0 then elevation = -85.0 end
            if elevation >  10.0 then elevation =  10.0 end

            -- Slew down away from flight view (below -2.0 deg): turn on gimbal camera
            if elevation < -2.0 then
                is_active = 1
            -- Slew back up into flight view (at or above -2.0 deg): turn off gimbal camera
            elseif elevation >= -2.0 then
                is_active = 0
            end
        end

        if slew_yaw ~= 0 then
            azimuth = azimuth + (slew_yaw * SLEW_SPEED * update_time_step)
            if azimuth < -160.0 then azimuth = -160.0 end
            if azimuth >  160.0 then azimuth =  160.0 end

            if math.abs(azimuth) > 5.0 then
                is_active = 1
            end
        end
    end

    GIMBAL_ACTIVE:set(is_active)
    GIMBAL_ELEVATION:set(elevation)
    GIMBAL_AZIMUTH:set(azimuth)
end
