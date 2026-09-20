local diff = {
	["axisDiffs"] = {
		-- Left Stick Pitch
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
		-- Remove shared trigger axis on Thrust to prevent 50% throttle snap on release
		["a2004cdnil"] = {
			["name"] = "Thrust",
			["removed"] = {
				[1] = {
					["key"] = "JOY_Z",
				},
			},
		},
		-- Right Stick Horizontal: Target Designator / Sensor Slew
		["a2033cdnil"] = {
			["name"] = "TDC / Sensor Target Slew Horizontal",
			["changed"] = {
				[1] = {
					["key"] = "JOY_RX",
					["filter"] = {
						["deadzone"] = 0.08,
						["curvature"] = { [1] = 0.35 },
						["invert"] = false,
						["saturationX"] = 1,
						["saturationY"] = 0.50,
						["slider"] = false,
					},
				},
			},
		},
		-- Right Stick Vertical: Target Designator / Sensor Slew
		["a2034cdnil"] = {
			["name"] = "TDC / Sensor Target Slew Vertical",
			["changed"] = {
				[1] = {
					["key"] = "JOY_RY",
					["filter"] = {
						["deadzone"] = 0.08,
						["curvature"] = { [1] = 0.35 },
						["invert"] = true,
						["saturationX"] = 1,
						["saturationY"] = 0.50,
						["slider"] = false,
					},
				},
			},
		},
	},
	["keyDiffs"] = {
		-- [A] Button: Weapon Fire / Release (Hold 1-2s for Hellfire missile launch)
		["d84pnilu85cdnilvdnilvpnilvunil"] = {
			["name"] = "Weapon Fire",
			["added"] = {
				[1] = {
					["key"] = "JOY_BTN1",
				},
			},
		},
		-- [B] Button: Electro-Optical System / Sensor Camera On/Off
		["d87pnilunilcdnilvdnilvpnilvunil"] = {
			["name"] = "Electro-Optical System On/Off",
			["added"] = {
				[1] = {
					["key"] = "JOY_BTN2",
				},
			},
		},
		-- [X] Button: Target Lock / Point Track
		["d83pnilu84cdnilvdnilvpnilvunil"] = {
			["name"] = "Target Lock",
			["added"] = {
				[1] = {
					["key"] = "JOY_BTN3",
				},
			},
		},
		-- [Y] Button: Laser Ranger / Designator On/Off
		["d136pnilunilcdnilvdnilvpnilvunil"] = {
			["name"] = "Laser Ranger On/Off",
			["added"] = {
				[1] = {
					["key"] = "JOY_BTN4",
				},
			},
		},
		-- [LB] Button: Throttle Down / Speed Decrease
		["dnilp1033u1034cdnilvdnilvpnilvunil"] = {
			["name"] = "Throttle Down",
			["added"] = {
				[1] = {
					["key"] = "JOY_BTN5",
				},
			},
		},
		-- [RB] Button: Throttle Up / Speed Increase
		["dnilp1032u1034cdnilvdnilvpnilvunil"] = {
			["name"] = "Throttle Up",
			["added"] = {
				[1] = {
					["key"] = "JOY_BTN6",
				},
			},
		},
		-- [Back / View] Button: Target Designator To Center
		["d92pnilunilcdnilvdnilvpnilvunil"] = {
			["name"] = "Target Designator To Center",
			["added"] = {
				[1] = {
					["key"] = "JOY_BTN7",
				},
			},
		},
		-- [Start / Menu] Button: Barometric Altitude Hold Autopilot
		["d427pnilunilcdnilvdnilvpnilvunil"] = {
			["name"] = "Autopilot - Barometric Altitude Hold 'H'",
			["added"] = {
				[1] = {
					["key"] = "JOY_BTN8",
				},
			},
		},
		-- [LS Click] (Left Stick Click): Air-To-Ground Combat Mode 7
		["d111pnilunilcdnilvdnilvpnilvunil"] = {
			["name"] = "(7) Air-To-Ground Mode",
			["added"] = {
				[1] = {
					["key"] = "JOY_BTN9",
				},
			},
		},
		-- [RS Click] (Right Stick Click): Target Unlock / Sensor Reset
		["d1415pnilunilcdnilvdnilvpnilvunil"] = {
			["name"] = "Target Unlock",
			["added"] = {
				[1] = {
					["key"] = "JOY_BTN10",
				},
			},
		},
		-- D-Pad Up: Sensor Zoom In
		["d407pnilunilcdnilvdnilvpnilvunil"] = {
			["name"] = "Sensor Zoom In",
			["added"] = {
				[1] = {
					["key"] = "JOY_POV1_U",
				},
				[2] = {
					["key"] = "JOY_BTN_POV1_U",
				},
			},
		},
		-- D-Pad Down: Sensor Zoom Out
		["d408pnilunilcdnilvdnilvpnilvunil"] = {
			["name"] = "Sensor Zoom Out",
			["added"] = {
				[1] = {
					["key"] = "JOY_POV1_D",
				},
				[2] = {
					["key"] = "JOY_BTN_POV1_D",
				},
			},
		},
		-- D-Pad Left: Night Vision / FLIR Thermal WHOT/BHOT
		["d1410pnilunilcdnilvdnilvpnilvunil"] = {
			["name"] = "Night Vision / FLIR",
			["added"] = {
				[1] = {
					["key"] = "JOY_POV1_L",
				},
				[2] = {
					["key"] = "JOY_BTN_POV1_L",
				},
			},
		},
		-- D-Pad Right: Change Weapon / Cycle Stores
		["d109pnilunilcdnilvdnilvpnilvunil"] = {
			["name"] = "Change Weapon",
			["added"] = {
				[1] = {
					["key"] = "JOY_POV1_R",
				},
				[2] = {
					["key"] = "JOY_BTN_POV1_R",
				},
			},
		},
		-- Strip old slow view-slew off D-Pad so it exclusively controls zoom/thermal/weapon
		["dnilp32u214cdnilvdnilvpnilvunil"] = {
			["name"] = "View Left slow",
			["removed"] = {
				[1] = {
					["key"] = "JOY_BTN_POV1_L",
				},
				[2] = {
					["key"] = "JOY_POV1_L",
				},
			},
		},
		["dnilp33u214cdnilvdnilvpnilvunil"] = {
			["name"] = "View Right slow",
			["removed"] = {
				[1] = {
					["key"] = "JOY_BTN_POV1_R",
				},
				[2] = {
					["key"] = "JOY_POV1_R",
				},
			},
		},
		["dnilp34u214cdnilvdnilvpnilvunil"] = {
			["name"] = "View Up slow",
			["removed"] = {
				[1] = {
					["key"] = "JOY_BTN_POV1_U",
				},
				[2] = {
					["key"] = "JOY_POV1_U",
				},
			},
		},
		["dnilp35u214cdnilvdnilvpnilvunil"] = {
			["name"] = "View Down slow",
			["removed"] = {
				[1] = {
					["key"] = "JOY_BTN_POV1_D",
				},
				[2] = {
					["key"] = "JOY_POV1_D",
				},
			},
		},
	},
}
return diff
