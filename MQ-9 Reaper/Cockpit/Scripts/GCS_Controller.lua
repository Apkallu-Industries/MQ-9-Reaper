-- MQ-9 Reaper GCS Gimbal Camera & Sensor Controller
-- Handles dynamic flight telemetry (altitude, airspeed, heading) via get_base_data()
-- and automated gimbal activation on Right Thumbstick / Slew input away from flight view,
-- with deactivation when recentered (RS Click / F1) or returned to forward flight view.

local dev = GetSelf()
local update_time_step = 0.02 -- 50 Hz update
make_default_activity(update_time_step)

local sensor_data = get_base_data()

-- Shared parameters
local GIMBAL_ACTIVE    = get_param_handle("GIMBAL_ACTIVE")
local GIMBAL_ELEVATION = get_param_handle("GIMBAL_ELEVATION")
local GIMBAL_AZIMUTH   = get_param_handle("GIMBAL_AZIMUTH")

local CURRENT_ALT      = get_param_handle("CURRENT_ALT")   -- Baro Altitude (feet MSL)
local CURRENT_RALT     = get_param_handle("CURRENT_RALT")  -- Radar Altitude (feet AGL)
local CURRENT_IAS      = get_param_handle("CURRENT_IAS")   -- Indicated Airspeed (knots)
local CURRENT_HDG      = get_param_handle("CURRENT_HDG")   -- Magnetic Heading (degrees 0-359)
local CURRENT_VV       = get_param_handle("CURRENT_VV")    -- Vertical Velocity (ft/min)
local CURRENT_PITCH    = get_param_handle("CURRENT_PITCH") -- Aircraft Pitch (degrees)
local CURRENT_ROLL     = get_param_handle("CURRENT_ROLL")  -- Aircraft Roll (degrees)

-- Initial state at mission spawn:
local is_active   = 1
local elevation   = 0.0 -- 0.0 = forward flight boresight / horizon
local azimuth     = 0.0 -- 0.0 = straight ahead
local slew_pitch  = 0.0 -- Analog or discrete pitch rate (-1.0 to 1.0)
local slew_yaw    = 0.0 -- Analog or discrete yaw rate (-1.0 to 1.0)

local SLEW_SPEED  = 30.0 -- Max degrees per second

GIMBAL_ACTIVE:set(1)
GIMBAL_ELEVATION:set(0)
GIMBAL_AZIMUTH:set(0)

CURRENT_ALT:set(0)
CURRENT_RALT:set(0)
CURRENT_IAS:set(0)
CURRENT_HDG:set(0)
CURRENT_VV:set(0)
CURRENT_PITCH:set(0)
CURRENT_ROLL:set(0)

-- Discrete Slew & View Command IDs
local CMD_RADAR_UP        = 90
local CMD_RADAR_DOWN      = 91
local CMD_RADAR_LEFT      = 88
local CMD_RADAR_RIGHT     = 89
local CMD_RADAR_CENTER    = 92
local CMD_RADAR_STOP      = 93
local CMD_EOS_ON_OFF      = 87

local CMD_VIEW_UP         = 8
local CMD_VIEW_DOWN       = 9
local CMD_VIEW_LEFT       = 10
local CMD_VIEW_RIGHT      = 11
local CMD_VIEW_CENTER     = 12
local CMD_VIEW_STOP       = 13
local CMD_VIEW_F1         = 1
local CMD_VIEW_HUD_ONLY   = 344

-- Analog Axis Command IDs (Right Thumbstick / HOTAS Slew Axes)
local CMD_AXIS_SELECT_H   = 2033 -- iCommandPlaneSelecterHorizontalAbs (Right Stick X)
local CMD_AXIS_SELECT_V   = 2034 -- iCommandPlaneSelecterVerticalAbs   (Right Stick Y)
local CMD_AXIS_RADAR_H    = 2027 -- Joystick rotate radar left/right
local CMD_AXIS_RADAR_V    = 2028 -- Joystick rotate radar up/down
local CMD_AXIS_VIEW_H     = 2010 -- Absolute Camera Horizontal View
local CMD_AXIS_VIEW_V     = 2011 -- Absolute Camera Vertical View

-- Register discrete listeners (axis commands 2000+ are handled by input system, not dev:listen_command)
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
dev:listen_command(CMD_VIEW_HUD_ONLY)

function SetCommand(command, value)
    -- Right Thumbstick / Slew Vertical Axis (JOY_RY)
    if command == CMD_AXIS_SELECT_V or command == CMD_AXIS_RADAR_V or command == CMD_AXIS_VIEW_V then
        if math.abs(value) > 0.06 then
            slew_pitch = -value -- Pushing stick forward tilts down, pulling back tilts up
        else
            slew_pitch = 0.0
        end
    -- Right Thumbstick / Slew Horizontal Axis (JOY_RX)
    elseif command == CMD_AXIS_SELECT_H or command == CMD_AXIS_RADAR_H or command == CMD_AXIS_VIEW_H then
        if math.abs(value) > 0.06 then
            slew_yaw = value -- Pushing stick right pans right, left pans left
        else
            slew_yaw = 0.0
        end
    -- Discrete Slew Controls (D-Pad / Keyboard)
    elseif command == CMD_RADAR_DOWN or command == CMD_VIEW_DOWN then
        slew_pitch = -1.0
    elseif command == CMD_RADAR_UP or command == CMD_VIEW_UP then
        slew_pitch = 1.0
    elseif command == CMD_RADAR_STOP or command == CMD_VIEW_STOP then
        slew_pitch = 0.0
        slew_yaw   = 0.0
    elseif command == CMD_RADAR_LEFT or command == CMD_VIEW_LEFT then
        slew_yaw = -1.0
    elseif command == CMD_RADAR_RIGHT or command == CMD_VIEW_RIGHT then
        slew_yaw = 1.0
    -- Recenter Gimbal / Flight View (RS Click / RCtrl+I / Num 5)
    elseif command == CMD_RADAR_CENTER or command == CMD_VIEW_CENTER then
        elevation  = 0.0
        azimuth    = 0.0
        slew_pitch = 0.0
        slew_yaw   = 0.0
        is_active  = 0
        GIMBAL_ACTIVE:set(0)
    -- F1 / Return to Flight Seat
    elseif command == CMD_VIEW_F1 or command == CMD_VIEW_HUD_ONLY then
        elevation  = 0.0
        azimuth    = 0.0
        slew_pitch = 0.0
        slew_yaw   = 0.0
        is_active  = 0
        GIMBAL_ACTIVE:set(0)
    -- Optical Sensor Toggle (Controller [B] / O key)
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
    -- 1. Read real-time flight telemetry from DCS sensor bus
    if sensor_data then
        local alt_ft  = 0.0
        local ralt_ft = 0.0
        local spd_kts = 0.0
        local hdg_deg = 0.0
        local vv_fpm  = 0.0
        local pit_deg = 0.0
        local rol_deg = 0.0

        pcall(function()
            if sensor_data.getBarometricAltitude then
                alt_ft = sensor_data.getBarometricAltitude() * 3.28084 -- m to ft
            end
            if sensor_data.getRadarAltitude then
                ralt_ft = sensor_data.getRadarAltitude() * 3.28084 -- m to ft
            end
            if sensor_data.getIndicatedAirSpeed then
                spd_kts = sensor_data.getIndicatedAirSpeed() * 1.94384 -- m/s to kts
            end
            if sensor_data.getHeading then
                hdg_deg = (360.0 - math.deg(sensor_data.getHeading())) % 360.0
            end
            if sensor_data.getVerticalVelocity then
                vv_fpm = sensor_data.getVerticalVelocity() * 196.85 -- m/s to ft/min
            end
            if sensor_data.getPitch then
                pit_deg = math.deg(sensor_data.getPitch())
            end
            if sensor_data.getRoll then
                rol_deg = math.deg(sensor_data.getRoll())
            end
        end)

        CURRENT_ALT:set(alt_ft)
        CURRENT_RALT:set(ralt_ft)
        CURRENT_IAS:set(spd_kts)
        CURRENT_HDG:set(hdg_deg)
        CURRENT_VV:set(vv_fpm)
        CURRENT_PITCH:set(pit_deg)
        CURRENT_ROLL:set(rol_deg)
    end

    -- 2. Gimbal pan/tilt integration
    if slew_pitch ~= 0.0 then
        elevation = elevation + (slew_pitch * SLEW_SPEED * update_time_step)
        if elevation < -85.0 then elevation = -85.0 end
        if elevation >  10.0 then elevation =  10.0 end

        -- Slew down away from flight view (below -2.0 deg): activate gimbal HUD
        if elevation < -2.0 then
            is_active = 1
        -- Slew back up into forward boresight: deactivate gimbal HUD
        elseif elevation >= -2.0 and math.abs(azimuth) < 4.0 then
            is_active = 0
        end
    end

    if slew_yaw ~= 0.0 then
        azimuth = azimuth + (slew_yaw * SLEW_SPEED * update_time_step)
        if azimuth < -160.0 then azimuth = -160.0 end
        if azimuth >  160.0 then azimuth =  160.0 end

        if math.abs(azimuth) > 4.0 then
            is_active = 1
        end
    end

    GIMBAL_ACTIVE:set(is_active)
    GIMBAL_ELEVATION:set(elevation)
    GIMBAL_AZIMUTH:set(azimuth)
end
