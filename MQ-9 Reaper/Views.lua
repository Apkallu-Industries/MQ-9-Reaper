ViewSettings = {
	Cockpit = {
		[1] = { -- player slot 1: MQ-9 Reaper MTS-B Sensor Ball / Nose Gimbal Camera POV
			CameraViewAngleLimits  = {10.000000, 110.000000}, -- Zoom limits: telephoto (10 deg) to wide (110 deg)
			CockpitLocalPoint      = {7.500000, -1.050000, 0.000000}, -- Under the nose chin at MTS-B sensor turret
			CameraAngleRestriction = {false, 90.000000, 0.500000},
			CameraAngleLimits      = {180.000000, -90.000000, 45.000000}, -- Gimbal pan: +/-180 deg yaw, -90 deg nadir down, +45 deg up
			EyePoint               = {0.000000, 0.000000, 0.000000},
			ShoulderSize           = 0.000000,
			Allow360rotation       = false,
			limits_6DOF            = {x = {-0.200000, 0.600000}, y = {-0.200000, 0.200000}, z = {-0.200000, 0.200000}, roll = 0.000000}, -- Full forward/back 6DOF head adjustment
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
    tab.viewAngle = tab.viewAngle or 42.0 -- Clean FOV: focused strictly on forward flight view & HUD
    tab.hAngle    = tab.hAngle    or 0.0
    tab.vAngle    = tab.vAngle    or 0.0  -- Level with horizon: completely clears instrument panel below
    tab.x_trans   = tab.x_trans   or 0.54 -- Forward past IT-23M TV screen: completely removes 2nd sensor window
    tab.y_trans   = tab.y_trans   or 0.02
    tab.z_trans   = tab.z_trans   or 0.0
    tab.rollAngle = tab.rollAngle or 0.0
    return tab
end

local function vr_pos_default(tab)
    if not tab then tab = {} end
    tab.viewAngle = tab.viewAngle or 60.0
    tab.hAngle    = tab.hAngle    or 0.0
    tab.vAngle    = tab.vAngle    or 0.0
    tab.x_trans   = tab.x_trans   or 0.54
    tab.y_trans   = tab.y_trans   or 0.02
    tab.z_trans   = tab.z_trans   or 0.0
    tab.rollAngle = tab.rollAngle or 0.0
    return tab
end

SnapViews = {
	[1] = {
		[1]  = head_pos_default({viewAngle = 42.0}),
		[2]  = head_pos_default({viewAngle = 42.0, vAngle = -15.0}),
		[3]  = head_pos_default({viewAngle = 32.0, vAngle = -30.0}),
		[4]  = head_pos_default({viewAngle = 20.0, vAngle = -45.0}),
		[5]  = head_pos_default({viewAngle = 42.0}),
		[6]  = head_pos_default({viewAngle = 42.0}),
		[7]  = head_pos_default({viewAngle = 42.0}),
		[8]  = head_pos_default({viewAngle = 42.0}),
		[9]  = head_pos_default({viewAngle = 42.0}),
		[10] = head_pos_default({viewAngle = 42.0}),
		[11] = head_pos_default({viewAngle = 42.0, hAngle = -45.0}),
		[12] = head_pos_default({viewAngle = 42.0, hAngle =  45.0}),
		[13] = head_pos_default({viewAngle = 42.0, hAngle = 0.0, vAngle = 0.0, x_trans = 0.54, y_trans = 0.02}), -- Default F1 view: Level horizon, zero cockpit clutter, prominent HUD
		[14] = vr_pos_default  ({viewAngle = 60.0, hAngle = 0.0, vAngle = 0.0, x_trans = 0.54, y_trans = 0.02}),
	},
}
