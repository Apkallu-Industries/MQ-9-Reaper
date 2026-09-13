ViewSettings = {
	Cockpit = {
		[1] = { -- player slot 1: MQ-9 Reaper MTS-B Sensor Ball / Nose Gimbal Camera POV
			CameraViewAngleLimits  = {10.000000, 110.000000}, -- Zoom limits: telephoto (10 deg) to wide (110 deg)
			CockpitLocalPoint      = {7.150000, -0.620000, 0.000000}, -- Advanced forward by 200cm ahead of antenna/nose
			CameraAngleRestriction = {false, 90.000000, 0.500000},
			CameraAngleLimits      = {160.000000, -85.000000, 30.000000}, -- Gimbal pan: +/-160 deg yaw, -85 deg pitch down, +30 deg up
			EyePoint               = {0.000000, 0.000000, 0.000000},
			ShoulderSize           = 0.000000,
			Allow360rotation       = false,
			limits_6DOF            = {x = {0.000000, 0.000000}, y = {0.000000, 0.000000}, z = {0.000000, 0.000000}, roll = 0.000000}, -- Rigid gimbal mount (no human head drift)
		},	
	}, -- Cockpit 
	Chase = {
		LocalPoint      = {-14.000000, 2.800000, 0.000000},
		AnglesDefault   = {0.000000, -5.000000},
	}, -- Chase 
	Arcade = {
		LocalPoint      = {-18.000000, 4.500000, 0.000000},
		AnglesDefault   = {0.000000, -7.000000},
	}, -- Arcade 
}

local function head_pos_default(tab)
    if not tab then tab = {} end
    tab.viewAngle = tab.viewAngle or 38.0 -- Scaled for authentic UAV GCS monitor / large HUD
    tab.hAngle    = tab.hAngle    or 0.0
    tab.vAngle    = tab.vAngle    or 0.0
    tab.x_trans   = tab.x_trans   or 0.0
    tab.y_trans   = tab.y_trans   or 0.0
    tab.z_trans   = tab.z_trans   or 0.0
    tab.rollAngle = tab.rollAngle or 0.0
    return tab
end

local function vr_pos_default(tab)
    if not tab then tab = {} end
    tab.viewAngle = tab.viewAngle or 60.0
    tab.hAngle    = tab.hAngle    or 0.0
    tab.vAngle    = tab.vAngle    or 0.0
    tab.x_trans   = tab.x_trans   or 0.0
    tab.y_trans   = tab.y_trans   or 0.0
    tab.z_trans   = tab.z_trans   or 0.0
    tab.rollAngle = tab.rollAngle or 0.0
    return tab
end

SnapViews = {
	[1] = {
		[1]  = head_pos_default({viewAngle = 38.0}),
		[2]  = head_pos_default({viewAngle = 38.0, vAngle = -15.0}), -- Slight down-angle scan
		[3]  = head_pos_default({viewAngle = 28.0, vAngle = -30.0}), -- Medium down-angle ground surveillance
		[4]  = head_pos_default({viewAngle = 18.0, vAngle = -45.0}), -- Telephoto steep target acquisition
		[5]  = head_pos_default({viewAngle = 38.0}),
		[6]  = head_pos_default({viewAngle = 38.0}),
		[7]  = head_pos_default({viewAngle = 38.0}),
		[8]  = head_pos_default({viewAngle = 38.0}),
		[9]  = head_pos_default({viewAngle = 38.0}),
		[10] = head_pos_default({viewAngle = 38.0}),
		[11] = head_pos_default({viewAngle = 38.0, hAngle = -45.0}), -- 45 deg left scan
		[12] = head_pos_default({viewAngle = 38.0, hAngle =  45.0}), -- 45 deg right scan
		[13] = head_pos_default({viewAngle = 38.0, hAngle = 0.0, vAngle = -4.0}), -- Default F1 view: Prominent HUD forward
		[14] = vr_pos_default  ({viewAngle = 60.0, hAngle = 0.0, vAngle = -4.0}), -- Default VR view
	},
}
