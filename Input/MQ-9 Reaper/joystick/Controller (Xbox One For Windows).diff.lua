-- MQ-9 Reaper - Xbox 360 Controller tuning + conflict cleanup.
-- default.lua supplies the button/axis MAP; this file TUNES the sticks and
-- REMOVES the Su-25T base binds that would double-fire on the same inputs.
local diff = {
	["axisDiffs"] = {
		-- Left Stick Pitch (small deadzone, gentle curve for steady camera work)
		["a2001cdnil"] = {
			["name"] = "Pitch",
			["changed"] = {
				[1] = {
					["key"] = "JOY_Y",
					["filter"] = {
						["deadzone"] = 0.05,
						["curvature"] = { [1] = 0.15 },
						["invert"] = false,
						["saturationX"] = 1,
						["saturationY"] = 1,
						["slider"] = false,
					},
				},
			},
		},
		-- Left Stick Roll
		["a2002cdnil"] = {
			["name"] = "Roll",
			["changed"] = {
				[1] = {
					["key"] = "JOY_X",
					["filter"] = {
						["deadzone"] = 0.05,
						["curvature"] = { [1] = 0.15 },
						["invert"] = false,
						["saturationX"] = 1,
						["saturationY"] = 1,
						["slider"] = false,
					},
				},
			},
		},
		-- Thrust: REMOVE the shared trigger axis (JOY_Z). Releasing the triggers
		-- would otherwise snap power to ~50% and drop the aircraft out of orbit.
		-- Throttle is on RB/LB instead (see default.lua) so it HOLDS.
		["a2004cdnil"] = {
			["name"] = "Thrust",
			["removed"] = {
				[1] = { ["key"] = "JOY_Z" },
			},
		},
		-- Make sure the Right Stick is OFF the plain view-camera slew...
		["a2010cdnil"] = {
			["name"] = "Absolute Camera Horizontal View",
			["removed"] = {
				[1] = { ["key"] = "JOY_RX" },
			},
		},
		["a2011cdnil"] = {
			["name"] = "Absolute Camera Vertical View",
			["removed"] = {
				[1] = { ["key"] = "JOY_RY" },
			},
		},
		-- ...and tune it on the MTS-B sensor / target gate slew instead.
		["a2033cdnil"] = {
			["name"] = "Sensor / TDC Slew Horizontal (Right Stick X)",
			["changed"] = {
				[1] = {
					["key"] = "JOY_RX",
					["filter"] = {
						["deadzone"] = 0.08,
						["curvature"] = { [1] = 0.45 },
						["invert"] = false,
						["saturationX"] = 1,
						["saturationY"] = 0.40,
						["slider"] = false,
					},
				},
			},
		},
		["a2034cdnil"] = {
			["name"] = "Sensor / TDC Slew Vertical (Right Stick Y)",
			["changed"] = {
				[1] = {
					["key"] = "JOY_RY",
					["filter"] = {
						["deadzone"] = 0.08,
						["curvature"] = { [1] = 0.45 },
						["invert"] = true,
						["saturationX"] = 1,
						["saturationY"] = 0.40,
						["slider"] = false,
					},
				},
			},
		},
	},
	["keyDiffs"] = {
		-- Remove base "Weapon Fire" (gun) off [A]; [A] launches the Hellfire (pickle).
		["d84pnilu85cdnilvdnilvpnilvunil"] = {
			["name"] = "Weapon Fire",
			["removed"] = {
				[1] = { ["key"] = "JOY_BTN1" },
			},
		},
		-- Remove base "Cannon" off [LB]; [LB] is Throttle Down.
		["d113pnilunilcdnilvdnilvpnilvunil"] = {
			["name"] = "Cannon",
			["removed"] = {
				[1] = { ["key"] = "JOY_BTN5" },
			},
		},
		-- Strip the default Su-25T slow view-slew off the D-Pad so it only does
		-- Zoom / Thermal / Laser and never drags the view around.
		["dnilp32u214cdnilvdnilvpnilvunil"] = {
			["name"] = "View Left slow",
			["removed"] = {
				[1] = { ["key"] = "JOY_POV1_L" },
				[2] = { ["key"] = "JOY_BTN_POV1_L" },
			},
		},
		["dnilp33u214cdnilvdnilvpnilvunil"] = {
			["name"] = "View Right slow",
			["removed"] = {
				[1] = { ["key"] = "JOY_POV1_R" },
				[2] = { ["key"] = "JOY_BTN_POV1_R" },
			},
		},
		["dnilp34u214cdnilvdnilvpnilvunil"] = {
			["name"] = "View Up slow",
			["removed"] = {
				[1] = { ["key"] = "JOY_POV1_U" },
				[2] = { ["key"] = "JOY_BTN_POV1_U" },
			},
		},
		["dnilp35u214cdnilvdnilvpnilvunil"] = {
			["name"] = "View Down slow",
			["removed"] = {
				[1] = { ["key"] = "JOY_POV1_D" },
				[2] = { ["key"] = "JOY_BTN_POV1_D" },
			},
		},
	},
}
return diff
