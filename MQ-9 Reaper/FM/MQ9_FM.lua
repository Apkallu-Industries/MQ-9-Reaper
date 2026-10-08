-- BNS MQ-9A Reaper: flight-model table handed to make_flyable (entry.lua) when the EFM is switched on
-- (BNS_MQ9_USE_EFM). The physics live in bin\BNS_MQ9_EFM.dll (source efm\ at the repository root).
-- Body axes: x forward of the model origin, y up, z right.
-- Gear from MQ-9.lua (nose_gear_pos {2.504, -1.94, 0}, main_gear_pos {-0.628, -2.046, +/-1.888}, wheels 0.319 / 0.683 m,
-- nose stroke 0.196 with 0.075 under weight), taken as loaded axle positions [EST: check 'agl' / 'wow' in
-- BNS_MQ9_EFM.log on the ramp]. Strut "pos" = top of the stroke: wheel bottom = pos.y - amortizer_max_length - radius.
-- Springs carry 4,760 kg with the CG at the origin: nose 9.3 kN at 0.075 m, mains 18.7 kN each at 0.05 m [EST].
-- Inertias [EST] at the empty mass (2,223 kg): roll radius of gyration 4.0 m, pitch 2.2 m.

local NOSE_R, MAIN_R = 0.319 / 2, 0.683 / 2
local NOSE_STROKE, MAIN_STROKE = 0.196, 0.10
local NOSE_STATIC, MAIN_STATIC = 0.075, 0.05

local function main_strut(z, arg_post, arg_amort, arg_spin)
    return {
        mass = 40,
        pos = {-0.628, -2.046 - MAIN_STATIC + MAIN_STROKE, z},
        self_attitude = false, yaw_limit = 0.0, wheel_axle_offset = 0.0,
        amortizer_min_length = 0.0, amortizer_max_length = MAIN_STROKE, amortizer_basic_length = MAIN_STROKE,
        amortizer_spring_force_factor = 1.14e6, amortizer_spring_force_factor_rate = 1.5,
        amortizer_static_force = 6000.0,
        amortizer_reduce_length = MAIN_STROKE,
        amortizer_direct_damper_force_factor = 12000.0, amortizer_back_damper_force_factor = 9000.0,
        allowable_hard_contact_length = 0.08,
        anti_skid_installed = false,
        wheel_radius = MAIN_R, wheel_moment_of_inertia = 0.8,
        wheel_static_friction_factor = 0.75, wheel_side_friction_factor = 0.85,
        wheel_roll_friction_factor = 0.025, wheel_glide_friction_factor = 0.60,
        wheel_damage_force_factor = 150.0,
        wheel_brake_moment_max = 3000.0,     -- N*m per wheel [EST]: 0.3 g at 4,760 kg
        arg_post = arg_post, arg_amortizer = arg_amort, arg_wheel_rotation = arg_spin, arg_wheel_yaw = -1,
    }
end

FM = {
    center_of_mass    = {0.0, 0.0, 0.0},
    moment_of_inertia = {3.6e4, 4.6e4, 1.1e4, 0.0},   -- Ix roll, Iy yaw, Iz pitch, Ixy (empty) [EST]
    suspension = {
        {   -- [0] nose gear, steered by the EFM below 25 m/s
            mass = 15,
            pos = {2.504, -1.94 - NOSE_STATIC + NOSE_STROKE, 0.0},
            self_attitude = false, yaw_limit = math.rad(30.0), wheel_axle_offset = 0.0,
            amortizer_min_length = 0.0, amortizer_max_length = NOSE_STROKE, amortizer_basic_length = NOSE_STROKE,
            amortizer_spring_force_factor = 3.07e5, amortizer_spring_force_factor_rate = 1.5,
            amortizer_static_force = 3000.0,
            amortizer_reduce_length = NOSE_STROKE,
            amortizer_direct_damper_force_factor = 6000.0, amortizer_back_damper_force_factor = 4500.0,
            allowable_hard_contact_length = 0.08,
            anti_skid_installed = false,
            wheel_radius = NOSE_R, wheel_moment_of_inertia = 0.1,
            wheel_static_friction_factor = 0.75, wheel_side_friction_factor = 0.85,
            wheel_roll_friction_factor = 0.025, wheel_glide_friction_factor = 0.60,
            wheel_damage_force_factor = 80.0,
            wheel_brake_moment_max = 0.0,
            arg_post = 0, arg_amortizer = 1, arg_wheel_rotation = 101, arg_wheel_yaw = 2,
        },
        main_strut(-1.888, 5, 6, 102),   -- [1] left main (DCS standard args)
        main_strut( 1.888, 3, 4, 103),   -- [2] right main
    },
    disable_built_in_oxygen_system = true,
    minor_shake_ampl = 0.05,
    major_shake_ampl = 0.15,
}
