mission = 
{
	["trig"] = 
	{
		["funcNum"] = {},
		["flag"] = {},
		["func"] = {},
		["funcStartup"] = 
		{
			[1] = "a_do_script_file(getValueResourceByKey(\"ResKey_ADAP_Menu\")); a_out_text_delay(\"=== ADAP PROVING GROUND READY ===\\nPress F10 Map -> Click any Drone -> Click [Drive] (or RAlt+J)\\nPress \\\\ -> F10 Other -> ADAP DRONE OPERATIONS to spawn new drones!\", 20, false);",
		}, -- end of ["funcStartup"]
		["custom"] = {},
		["customStartup"] = {},
		["conditions"] = 
		{
			[1] = "return true;",
		}, -- end of ["conditions"]
		["actions"] = 
		{
			[1] = "a_do_script_file(getValueResourceByKey(\"ResKey_ADAP_Menu\")); a_out_text_delay(\"=== ADAP PROVING GROUND READY ===\\nPress F10 Map -> Click any Drone -> Click [Drive] (or RAlt+J)\\nPress \\\\ -> F10 Other -> ADAP DRONE OPERATIONS to spawn new drones!\", 20, false);",
		}, -- end of ["actions"]
		["events"] = {},
	}, -- end of ["trig"]
	["maxUnitId"] = 5000,
	["maxGroupId"] = 500,
	["maxDictId"] = 2060,
	["failures"] = {},
	["theatre"] = "Caucasus",
	["usedModules"] = 
	{
		["F-86F Sabre AI by Eagle Dynamics"] = true,
		["Mi-8MTV2 Hip by Belsimtek"] = true,
		["Su-27 Flanker by Eagle Dynamics"] = true,
		["M-2000C by RAZBAM Sims"] = true,
		["Hawk T.1A by VEAO Simulations"] = true,
		["Su-25T by Eagle Dynamics"] = true,
		["World War II AI Units by Eagle Dynamics"] = true,
		["MiG-21Bis AI by Leatherneck Simulations"] = true,
		["Bf 109 K-4 by Eagle Dynamics"] = true,
		["A-10C Warthog by Eagle Dynamics"] = true,
		["./CoreMods/aircraft/MQ-9 Reaper"] = true,
		["C-101 Aviojet by AvioDev"] = true,
		["FW-190D9 Dora by Eagle Dynamics"] = true,
		["F-5E/E-3 by Belsimtek"] = true,
		["MiG-15bis AI by Eagle Dynamics"] = true,
		["M-2000C AI by RAZBAM Sims"] = true,
		["Combined Arms by Eagle Dynamics"] = true,
		["UH-1H Huey by Belsimtek"] = true,
		["C-101 Aviojet"] = true,
		["MiG-15bis by Belsimtek"] = true,
		["F-86F Sabre by Belsimtek"] = true,
		["Su-25A by Eagle Dynamics"] = true,
		["F-15C"] = true,
		["L-39C/ZA by Eagle Dynamics"] = true,
		["Hawk T.1A AI by VEAO Simulations"] = true,
		["Caucasus"] = true,
		["Ka-50 Black Shark by Eagle Dynamics"] = true,
		["TF-51D Mustang by Eagle Dynamics"] = true,
		["P-51D Mustang by Eagle Dynamics"] = true,
		["A-10A by Eagle Dynamics"] = true,
		["MiG-21Bis by Leatherneck Simulations"] = true,
		["Flaming Cliffs by Eagle Dynamics"] = true,
	}, -- end of ["usedModules"]
	["resourceCounter"] = {},
	["start_time"] = 1873920,
	["weather"] = 
	{
		["name_ru"] = "Лето. Oблачность и ветер",
		["wind"] = 
		{
			["at8000"] = 
			{
				["speed"] = 0,
				["dir"] = 71,
			}, -- end of ["at8000"]
			["atGround"] = 
			{
				["speed"] = 0,
				["dir"] = 160,
			}, -- end of ["atGround"]
			["at2000"] = 
			{
				["speed"] = 0,
				["dir"] = 243,
			}, -- end of ["at2000"]
		}, -- end of ["wind"]
		["enable_fog"] = false,
		["season"] = 
		{
			["iseason"] = 1,
			["temperature"] = 26,
		}, -- end of ["season"]
		["qnh"] = 755,
		["cyclones"] = 
		{
			[3] = 
			{
				["ellipticity"] = 0.89635219132085,
				["centerZ"] = 1137265.5916558,
				["pressure_spread"] = 871903.00765166,
				["rotation"] = -0.0061352048077511,
				["pressure_excess"] = -938.57166284129,
				["centerX"] = -640824.56012978,
			}, -- end of [3]
			[2] = 
			{
				["ellipticity"] = 1.0590196055576,
				["centerZ"] = -864112.01092605,
				["pressure_spread"] = 646745.33599321,
				["rotation"] = 1.2954634296446,
				["pressure_excess"] = -1374.2001835403,
				["centerX"] = -60875.049514612,
			}, -- end of [2]
			[1] = 
			{
				["ellipticity"] = 0.54761928365809,
				["centerZ"] = 226317.02672821,
				["pressure_spread"] = 865875.66185017,
				["rotation"] = -0.065585436041976,
				["pressure_excess"] = -1327.8489900407,
				["centerX"] = -52078.955386944,
			}, -- end of [1]
		}, -- end of ["cyclones"]
		["name_de"] = "Sommer, Wind und Wolken",
		["clouds"] = 
		{
			["thickness"] = 770,
			["density"] = 3,
			["base"] = 4500,
			["iprecptns"] = 0,
		}, -- end of ["clouds"]
		["atmosphere_type"] = 0,
		["name_fr"] = "Eté, nuages et vent",
		["turbulence"] = 
		{
			["at8000"] = 3,
			["atGround"] = 0,
			["at2000"] = 2,
		}, -- end of ["turbulence"]
		["type_weather"] = 0,
		["name"] = "Summer. Clouds & wind",
		["fog"] = 
		{
			["thickness"] = 0,
			["visibility"] = 1000,
			["density"] = 0,
		}, -- end of ["fog"]
		["name_es"] = "Verano. Nubes y viento",
		["visibility"] = 
		{
			["distance"] = 80000,
		}, -- end of ["visibility"]
		["name_cn"] = "夏季 多云+有风",
	}, -- end of ["weather"]
	["result"] = 
	{
		["total"] = 0,
		["offline"] = 
		{
			["conditions"] = {},
			["actions"] = {},
			["func"] = {},
		}, -- end of ["offline"]
		["blue"] = 
		{
			["conditions"] = {},
			["actions"] = {},
			["func"] = {},
		}, -- end of ["blue"]
		["red"] = 
		{
			["conditions"] = {},
			["actions"] = {},
			["func"] = {},
		}, -- end of ["red"]
	}, -- end of ["result"]
	["groundControl"] = 
	{
		["passwords"] = 
		{
			["artillery_commander"] = {},
			["instructor"] = {},
			["forward_observer"] = {},
			["observer"] = {},
		}, -- end of ["passwords"]
		["isPilotControlVehicles"] = true,
		["roles"] = 
		{
			["artillery_commander"] = 
			{
				["blue"] = 1,
				["neutrals"] = 0,
				["red"] = 0,
			}, -- end of ["artillery_commander"]
			["instructor"] = 
			{
				["blue"] = 1,
				["neutrals"] = 0,
				["red"] = 0,
			}, -- end of ["instructor"]
			["observer"] = 
			{
				["blue"] = 1,
				["neutrals"] = 0,
				["red"] = 0,
			}, -- end of ["observer"]
			["forward_observer"] = 
			{
				["blue"] = 1,
				["neutrals"] = 0,
				["red"] = 0,
			}, -- end of ["forward_observer"]
		}, -- end of ["roles"]
	}, -- end of ["groundControl"]
	["map"] = 
	{
		["centerY"] = 632094.28571429,
		["zoom"] = 50000,
		["centerX"] = -319539.99999999,
	}, -- end of ["map"]
	["coalitions"] = 
	{
		["blue"] = 
		{
			[1] = 21,
			[2] = 11,
			[4] = 28,
			[8] = 16,
			[16] = 10,
			[17] = 3,
			[9] = 6,
			[18] = 4,
			[5] = 26,
			[10] = 15,
			[11] = 20,
			[3] = 8,
			[6] = 13,
			[12] = 12,
			[13] = 40,
			[7] = 5,
			[14] = 45,
			[19] = 2,
			[15] = 9,
		}, -- end of ["blue"]
		["neutrals"] = 
		{
			[13] = 44,
			[7] = 33,
			[1] = 23,
			[2] = 25,
			[4] = 30,
			[8] = 35,
			[15] = 22,
			[9] = 36,
			[5] = 31,
			[10] = 39,
			[14] = 46,
			[3] = 29,
			[6] = 32,
			[12] = 42,
			[11] = 41,
		}, -- end of ["neutrals"]
		["red"] = 
		{
			[13] = 1,
			[7] = 38,
			[1] = 18,
			[2] = 24,
			[4] = 17,
			[8] = 0,
			[9] = 43,
			[5] = 34,
			[10] = 19,
			[3] = 27,
			[6] = 37,
			[12] = 7,
			[11] = 47,
		}, -- end of ["red"]
	}, -- end of ["coalitions"]
	["descriptionText"] = "DictKey_descriptionText_1",
	["pictureFileNameR"] = {},
	["currentKey"] = 1633285,
	["goals"] = {},
	["version"] = 11,
	["coalition"] = 
	{
		["blue"] = 
		{
			["bullseye"] = 
			{
				["y"] = 792485.71428572,
				["x"] = -97067.999999998,
			}, -- end of ["bullseye"]
			["nav_points"] = {},
			["name"] = "blue",
			["country"] = 
			{
				[1] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Australia",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 21,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [1]
				[2] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Belgium",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 11,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [2]
				[4] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Croatia",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 28,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [4]
				[8] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Georgia",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 16,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [8]
				[16] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "The Netherlands",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 10,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [16]
				[17] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Turkey",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 3,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [17]
				[9] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Germany",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 6,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [9]
				[18] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "UK",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 4,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [18]
				[5] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Czech Republic",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 26,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [5]
				[10] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Israel",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 15,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [10]
				[20] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Ukraine",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 1,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [20]
				[11] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Italy",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 20,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [11]
				[3] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Canada",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 8,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [3]
				[6] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Denmark",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 13,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [6]
				[12] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Norway",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 12,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [12]
				[13] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Poland",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 40,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [13]
				[7] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "France",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 5,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [7]
				[14] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "South Korea",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 45,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [14]
				[19] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "USA",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 2,
					["vehicle"] = 
					{
						["group"] = 
						{
							[1] = 
							{
								["visible"] = true,
								["taskSelected"] = true,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 46.54,
											["type"] = "Turning Point",
											["action"] = "Off Road",
											["alt_type"] = "BARO",
											["y"] = 681994.48726,
											["formation_template"] = "",
											["name"] = "DictKey_WptName_101",
											["ETA_locked"] = true,
											["speed"] = 0,
											["x"] = -285380.77476,
											["task"] = 
											{
												["id"] = "ComboTask",
												["params"] = 
												{
													["tasks"] = {},
												}, -- end of ["params"]
											}, -- end of ["task"]
											["ETA"] = 0,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 101,
								["tasks"] = {},
								["hidden"] = false,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "Cougar_H_MRAP",
										["transportable"] = 
										{
											["randomTransportable"] = false,
										}, -- end of ["transportable"]
										["unitId"] = 1001,
										["skill"] = "High",
										["y"] = 681994.48726,
										["x"] = -285380.77476,
										["name"] = "DictKey_UnitName_1001",
										["playerCanDrive"] = true,
										["heading"] = 1.2915,
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = 681994.48726,
								["x"] = -285380.77476,
								["name"] = "DictKey_GroupName_101",
								["start_time"] = 0,
							}, -- end of [1]
							[2] = 
							{
								["visible"] = true,
								["taskSelected"] = true,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 46.54,
											["type"] = "Turning Point",
											["action"] = "Off Road",
											["alt_type"] = "BARO",
											["y"] = 681996.692356,
											["formation_template"] = "",
											["name"] = "DictKey_WptName_102",
											["ETA_locked"] = true,
											["speed"] = 0,
											["x"] = -285388.464856,
											["task"] = 
											{
												["id"] = "ComboTask",
												["params"] = 
												{
													["tasks"] = {},
												}, -- end of ["params"]
											}, -- end of ["task"]
											["ETA"] = 0,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 102,
								["tasks"] = {},
								["hidden"] = false,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "ASD1_Sniper_UGV",
										["transportable"] = 
										{
											["randomTransportable"] = false,
										}, -- end of ["transportable"]
										["unitId"] = 1002,
										["skill"] = "High",
										["y"] = 681996.692356,
										["x"] = -285388.464856,
										["name"] = "DictKey_UnitName_1002",
										["playerCanDrive"] = true,
										["heading"] = 1.2915,
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = 681996.692356,
								["x"] = -285388.464856,
								["name"] = "DictKey_GroupName_102",
								["start_time"] = 0,
							}, -- end of [2]
							[3] = 
							{
								["visible"] = true,
								["taskSelected"] = true,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 46.54,
											["type"] = "Turning Point",
											["action"] = "Off Road",
											["alt_type"] = "BARO",
											["y"] = 681998.897452,
											["formation_template"] = "",
											["name"] = "DictKey_WptName_103",
											["ETA_locked"] = true,
											["speed"] = 0,
											["x"] = -285396.154952,
											["task"] = 
											{
												["id"] = "ComboTask",
												["params"] = 
												{
													["tasks"] = {},
												}, -- end of ["params"]
											}, -- end of ["task"]
											["ETA"] = 0,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 103,
								["tasks"] = {},
								["hidden"] = false,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "MDA1_Support_UGV",
										["transportable"] = 
										{
											["randomTransportable"] = false,
										}, -- end of ["transportable"]
										["unitId"] = 1003,
										["skill"] = "High",
										["y"] = 681998.897452,
										["x"] = -285396.154952,
										["name"] = "DictKey_UnitName_1003",
										["playerCanDrive"] = true,
										["heading"] = 1.2915,
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = 681998.897452,
								["x"] = -285396.154952,
								["name"] = "DictKey_GroupName_103",
								["start_time"] = 0,
							}, -- end of [3]
							[4] = 
							{
								["visible"] = true,
								["taskSelected"] = true,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 46.54,
											["type"] = "Turning Point",
											["action"] = "Off Road",
											["alt_type"] = "BARO",
											["y"] = 682001.102548,
											["formation_template"] = "",
											["name"] = "DictKey_WptName_104",
											["ETA_locked"] = true,
											["speed"] = 0,
											["x"] = -285403.845048,
											["task"] = 
											{
												["id"] = "ComboTask",
												["params"] = 
												{
													["tasks"] = {},
												}, -- end of ["params"]
											}, -- end of ["task"]
											["ETA"] = 0,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 104,
								["tasks"] = {},
								["hidden"] = false,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "DroneTank_UGV",
										["transportable"] = 
										{
											["randomTransportable"] = false,
										}, -- end of ["transportable"]
										["unitId"] = 1004,
										["skill"] = "High",
										["y"] = 682001.102548,
										["x"] = -285403.845048,
										["name"] = "DictKey_UnitName_1004",
										["playerCanDrive"] = true,
										["heading"] = 1.2915,
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = 682001.102548,
								["x"] = -285403.845048,
								["name"] = "DictKey_GroupName_104",
								["start_time"] = 0,
							}, -- end of [4]
							[5] = 
							{
								["visible"] = true,
								["taskSelected"] = true,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 46.54,
											["type"] = "Turning Point",
											["action"] = "Off Road",
											["alt_type"] = "BARO",
											["y"] = 682003.307644,
											["formation_template"] = "",
											["name"] = "DictKey_WptName_105",
											["ETA_locked"] = true,
											["speed"] = 0,
											["x"] = -285411.535144,
											["task"] = 
											{
												["id"] = "ComboTask",
												["params"] = 
												{
													["tasks"] = {},
												}, -- end of ["params"]
											}, -- end of ["task"]
											["ETA"] = 0,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 105,
								["tasks"] = {},
								["hidden"] = false,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "RECON_Drone",
										["transportable"] = 
										{
											["randomTransportable"] = false,
										}, -- end of ["transportable"]
										["unitId"] = 1005,
										["skill"] = "High",
										["y"] = 682003.307644,
										["x"] = -285411.535144,
										["name"] = "DictKey_UnitName_1005",
										["playerCanDrive"] = true,
										["heading"] = 1.2915,
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = 682003.307644,
								["x"] = -285411.535144,
								["name"] = "DictKey_GroupName_105",
								["start_time"] = 0,
							}, -- end of [5]
							[6] = 
							{
								["visible"] = true,
								["taskSelected"] = true,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 46.54,
											["type"] = "Turning Point",
											["action"] = "Off Road",
											["alt_type"] = "BARO",
											["y"] = 682005.51274,
											["formation_template"] = "",
											["name"] = "DictKey_WptName_106",
											["ETA_locked"] = true,
											["speed"] = 0,
											["x"] = -285419.22524,
											["task"] = 
											{
												["id"] = "ComboTask",
												["params"] = 
												{
													["tasks"] = {},
												}, -- end of ["params"]
											}, -- end of ["task"]
											["ETA"] = 0,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 106,
								["tasks"] = {},
								["hidden"] = false,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "Pirhanna_NanoDrone",
										["transportable"] = 
										{
											["randomTransportable"] = false,
										}, -- end of ["transportable"]
										["unitId"] = 1006,
										["skill"] = "High",
										["y"] = 682005.51274,
										["x"] = -285419.22524,
										["name"] = "DictKey_UnitName_1006",
										["playerCanDrive"] = true,
										["heading"] = 1.2915,
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = 682005.51274,
								["x"] = -285419.22524,
								["name"] = "DictKey_GroupName_106",
								["start_time"] = 0,
							}, -- end of [6]
						}, -- end of ["group"]
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
					["static"] = 
					{
						["group"] = 
						{
							[13] = 
							{
								["y"] = 806138.2857143,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -86604.857142853,
											["y"] = 806138.2857143,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 98,
								["dead"] = false,
								["name"] = "DictKey_GroupName_745",
								["x"] = -86604.857142853,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "GSM Rus",
										["type"] = "FARP Fuel Depot",
										["unitId"] = 335,
										["livery_id"] = "GRC_autumn",
										["rate"] = 20,
										["y"] = 806138.2857143,
										["x"] = -86604.857142853,
										["name"] = "DictKey_GroupName_745",
										["category"] = "Fortifications",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [13]
							[7] = 
							{
								["y"] = 834167.14285715,
								["heading"] = 5.4977871437821,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -82986.571428551,
											["y"] = 834167.14285715,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 37,
								["dead"] = false,
								["name"] = "DictKey_GroupName_276",
								["x"] = -82986.571428551,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "sklad",
										["type"] = "Warehouse",
										["unitId"] = 160,
										["y"] = 834167.14285715,
										["x"] = -82986.571428551,
										["name"] = "DictKey_GroupName_276",
										["category"] = "Warehouses",
										["canCargo"] = false,
										["heading"] = 5.4977871437821,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [7]
							[1] = 
							{
								["y"] = 780878.57142859,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -82699.428571411,
											["y"] = 780878.57142859,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 5,
								["dead"] = false,
								["name"] = "DictKey_GroupName_31",
								["x"] = -82699.428571411,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "tele_bash",
										["type"] = "TV tower",
										["unitId"] = 19,
										["y"] = 780878.57142859,
										["x"] = -82699.428571411,
										["name"] = "DictKey_GroupName_31",
										["category"] = "Fortifications",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [1]
							[2] = 
							{
								["y"] = 806405.42857145,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -86711.714285709,
											["y"] = 806405.42857145,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 21,
								["dead"] = false,
								["name"] = "DictKey_GroupName_181",
								["x"] = -86711.714285709,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "FARP",
										["unitId"] = 129,
										["heading"] = 0,
										["y"] = 806405.42857145,
										["x"] = -86711.714285709,
										["name"] = "DictKey_GroupName_181",
										["category"] = "Heliports",
										["canCargo"] = false,
										["heliport_callsign_id"] = 2,
										["heliport_frequency"] = 127.5,
										["heliport_modulation"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [2]
							[4] = 
							{
								["y"] = 806158,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -86713.999999997,
											["y"] = 806158,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 31,
								["dead"] = false,
								["name"] = "DictKey_GroupName_223",
								["x"] = -86713.999999997,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "FARP",
										["unitId"] = 149,
										["livery_id"] = "GRC_autumn",
										["heading"] = 0,
										["y"] = 806158,
										["x"] = -86713.999999997,
										["name"] = "DictKey_GroupName_223",
										["category"] = "Heliports",
										["canCargo"] = false,
										["heliport_callsign_id"] = 1,
										["heliport_frequency"] = "127.5",
										["heliport_modulation"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [4]
							[8] = 
							{
								["y"] = 806441.71428572,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -86455.142857138,
											["y"] = 806441.71428572,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 53,
								["dead"] = false,
								["name"] = "DictKey_GroupName_430",
								["x"] = -86455.142857138,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "sklad",
										["type"] = "Warehouse",
										["unitId"] = 198,
										["y"] = 806441.71428572,
										["x"] = -86455.142857138,
										["name"] = "DictKey_GroupName_430",
										["category"] = "Warehouses",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [8]
							[9] = 
							{
								["y"] = 806345.71428572,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -86454.571428566,
											["y"] = 806345.71428572,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 58,
								["dead"] = false,
								["name"] = "DictKey_GroupName_477",
								["x"] = -86454.571428566,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "tele_bash_m",
										["type"] = "Comms tower M",
										["unitId"] = 221,
										["y"] = 806345.71428572,
										["x"] = -86454.571428566,
										["name"] = "DictKey_GroupName_477",
										["category"] = "Fortifications",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [9]
							[5] = 
							{
								["y"] = 760754.2857143,
								["heading"] = 5.4977871437821,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -124275.14285712,
											["y"] = 760754.2857143,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 35,
								["dead"] = false,
								["name"] = "DictKey_GroupName_270",
								["x"] = -124275.14285712,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "sklad",
										["type"] = "Warehouse",
										["unitId"] = 158,
										["y"] = 760754.2857143,
										["x"] = -124275.14285712,
										["name"] = "DictKey_GroupName_270",
										["category"] = "Warehouses",
										["canCargo"] = false,
										["heading"] = 5.4977871437821,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [5]
							[10] = 
							{
								["y"] = 806249.42857144,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -86603.428571424,
											["y"] = 806249.42857144,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 92,
								["dead"] = false,
								["name"] = "DictKey_GroupName_727",
								["x"] = -86603.428571424,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "PalatkaB",
										["type"] = "FARP Tent",
										["unitId"] = 329,
										["y"] = 806249.42857144,
										["x"] = -86603.428571424,
										["name"] = "DictKey_GroupName_727",
										["category"] = "Fortifications",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [10]
							[14] = 
							{
								["y"] = 806351.14285716,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -86602.285714281,
											["y"] = 806351.14285716,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 102,
								["dead"] = false,
								["name"] = "DictKey_GroupName_764",
								["x"] = -86602.285714281,
								["units"] = 
								{
									[1] = 
									{
										["y"] = 806351.14285716,
										["type"] = "house2arm",
										["name"] = "DictKey_GroupName_764",
										["unitId"] = 345,
										["canCargo"] = false,
										["heading"] = 0,
										["category"] = "Fortifications",
										["x"] = -86602.285714281,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [14]
							[3] = 
							{
								["y"] = 806156.85714286,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -86471.428571425,
											["y"] = 806156.85714286,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 27,
								["dead"] = false,
								["name"] = "DictKey_GroupName_206",
								["x"] = -86471.428571425,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "FARP",
										["unitId"] = 140,
										["heading"] = 0,
										["y"] = 806156.85714286,
										["x"] = -86471.428571425,
										["name"] = "DictKey_GroupName_206",
										["category"] = "Heliports",
										["canCargo"] = false,
										["heliport_callsign_id"] = 3,
										["heliport_frequency"] = "127.5",
										["heliport_modulation"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [3]
							[6] = 
							{
								["y"] = 704731.42857144,
								["heading"] = 0.78539816339745,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -51650.857142838,
											["y"] = 704731.42857144,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 36,
								["dead"] = false,
								["name"] = "DictKey_GroupName_273",
								["x"] = -51650.857142838,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "sklad",
										["type"] = "Warehouse",
										["unitId"] = 159,
										["y"] = 704731.42857144,
										["x"] = -51650.857142838,
										["name"] = "DictKey_GroupName_273",
										["category"] = "Warehouses",
										["canCargo"] = false,
										["heading"] = 0.78539816339745,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [6]
							[12] = 
							{
								["y"] = 806309.71428573,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -86603.71428571,
											["y"] = 806309.71428573,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 97,
								["dead"] = false,
								["name"] = "DictKey_GroupName_742",
								["x"] = -86603.71428571,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "SetkaKP",
										["type"] = "FARP Ammo Dump Coating",
										["unitId"] = 334,
										["livery_id"] = "GRC_autumn",
										["rate"] = 50,
										["y"] = 806309.71428573,
										["x"] = -86603.71428571,
										["name"] = "DictKey_GroupName_742",
										["category"] = "Fortifications",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [12]
							[11] = 
							{
								["y"] = 806198.57142858,
								["heading"] = 0.017453292519943,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -86604.285714281,
											["y"] = 806198.57142858,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 96,
								["dead"] = false,
								["name"] = "DictKey_GroupName_739",
								["x"] = -86604.285714281,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "kp_ug",
										["type"] = "FARP CP Blindage",
										["unitId"] = 333,
										["rate"] = 100,
										["y"] = 806198.57142858,
										["x"] = -86604.285714281,
										["name"] = "DictKey_GroupName_739",
										["category"] = "Fortifications",
										["canCargo"] = false,
										["heading"] = 0.017453292519943,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [11]
						}, -- end of ["group"]
					}, -- end of ["static"]
				}, -- end of [19]
				[15] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Spain",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 9,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [15]
			}, -- end of ["country"]
		}, -- end of ["blue"]
		["red"] = 
		{
			["bullseye"] = 
			{
				["y"] = 647318.57142858,
				["x"] = -281660,
			}, -- end of ["bullseye"]
			["nav_points"] = {},
			["name"] = "red",
			["country"] = 
			{
				[7] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "North Korea",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 38,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [7]
				[1] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Abkhazia",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 18,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [1]
				[2] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Belarus",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 24,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [2]
				[4] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Insurgents",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 17,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [4]
				[8] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Russia",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 0,
					["vehicle"] = 
					{
						["group"] = 
						{
							[1] = 
							{
								["visible"] = true,
								["taskSelected"] = true,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 46.54,
											["type"] = "Turning Point",
											["action"] = "Off Road",
											["alt_type"] = "BARO",
											["y"] = 682096.1262,
											["formation_template"] = "",
											["name"] = "DictKey_WptName_301",
											["ETA_locked"] = true,
											["speed"] = 0,
											["x"] = -285372.4363,
											["task"] = 
											{
												["id"] = "ComboTask",
												["params"] = 
												{
													["tasks"] = 
													{
														[1] = 
														{
															["number"] = 1,
															["auto"] = false,
															["id"] = "WrappedAction",
															["enabled"] = true,
															["params"] = 
															{
																["action"] = 
																{
																	["id"] = "SetOption",
																	["params"] = 
																	{
																		["value"] = 4,
																		["name"] = 0,
																	}, -- end of ["params"]
																}, -- end of ["action"]
															}, -- end of ["params"]
														}, -- end of [1]
													}, -- end of ["tasks"]
												}, -- end of ["params"]
											}, -- end of ["task"]
											["ETA"] = 0,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 301,
								["tasks"] = {},
								["hidden"] = false,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "Tigr_233036",
										["transportable"] = 
										{
											["randomTransportable"] = false,
										}, -- end of ["transportable"]
										["unitId"] = 3001,
										["skill"] = "Average",
										["y"] = 682096.1262,
										["x"] = -285372.4363,
										["name"] = "DictKey_UnitName_3001",
										["playerCanDrive"] = false,
										["heading"] = 4.43309,
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = 682096.1262,
								["x"] = -285372.4363,
								["name"] = "DictKey_GroupName_301",
								["start_time"] = 0,
							}, -- end of [1]
							[2] = 
							{
								["visible"] = true,
								["taskSelected"] = true,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 46.54,
											["type"] = "Turning Point",
											["action"] = "Off Road",
											["alt_type"] = "BARO",
											["y"] = 682288.3786,
											["formation_template"] = "",
											["name"] = "DictKey_WptName_302",
											["ETA_locked"] = true,
											["speed"] = 0,
											["x"] = -285317.3089,
											["task"] = 
											{
												["id"] = "ComboTask",
												["params"] = 
												{
													["tasks"] = 
													{
														[1] = 
														{
															["number"] = 1,
															["auto"] = false,
															["id"] = "WrappedAction",
															["enabled"] = true,
															["params"] = 
															{
																["action"] = 
																{
																	["id"] = "SetOption",
																	["params"] = 
																	{
																		["value"] = 4,
																		["name"] = 0,
																	}, -- end of ["params"]
																}, -- end of ["action"]
															}, -- end of ["params"]
														}, -- end of [1]
													}, -- end of ["tasks"]
												}, -- end of ["params"]
											}, -- end of ["task"]
											["ETA"] = 0,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 302,
								["tasks"] = {},
								["hidden"] = false,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "BTR-80",
										["transportable"] = 
										{
											["randomTransportable"] = false,
										}, -- end of ["transportable"]
										["unitId"] = 3002,
										["skill"] = "Average",
										["y"] = 682288.3786,
										["x"] = -285317.3089,
										["name"] = "DictKey_UnitName_3002",
										["playerCanDrive"] = false,
										["heading"] = 4.43309,
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = 682288.3786,
								["x"] = -285317.3089,
								["name"] = "DictKey_GroupName_302",
								["start_time"] = 0,
							}, -- end of [2]
							[3] = 
							{
								["visible"] = true,
								["taskSelected"] = true,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 46.54,
											["type"] = "Turning Point",
											["action"] = "Off Road",
											["alt_type"] = "BARO",
											["y"] = 682576.7572,
											["formation_template"] = "",
											["name"] = "DictKey_WptName_303",
											["ETA_locked"] = true,
											["speed"] = 0,
											["x"] = -285234.6178,
											["task"] = 
											{
												["id"] = "ComboTask",
												["params"] = 
												{
													["tasks"] = 
													{
														[1] = 
														{
															["number"] = 1,
															["auto"] = false,
															["id"] = "WrappedAction",
															["enabled"] = true,
															["params"] = 
															{
																["action"] = 
																{
																	["id"] = "SetOption",
																	["params"] = 
																	{
																		["value"] = 4,
																		["name"] = 0,
																	}, -- end of ["params"]
																}, -- end of ["action"]
															}, -- end of ["params"]
														}, -- end of [1]
													}, -- end of ["tasks"]
												}, -- end of ["params"]
											}, -- end of ["task"]
											["ETA"] = 0,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 303,
								["tasks"] = {},
								["hidden"] = false,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "BMP-2",
										["transportable"] = 
										{
											["randomTransportable"] = false,
										}, -- end of ["transportable"]
										["unitId"] = 3003,
										["skill"] = "Average",
										["y"] = 682576.7572,
										["x"] = -285234.6178,
										["name"] = "DictKey_UnitName_3003",
										["playerCanDrive"] = false,
										["heading"] = 4.43309,
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = 682576.7572,
								["x"] = -285234.6178,
								["name"] = "DictKey_GroupName_303",
								["start_time"] = 0,
							}, -- end of [3]
							[4] = 
							{
								["visible"] = true,
								["taskSelected"] = true,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 46.54,
											["type"] = "Turning Point",
											["action"] = "Off Road",
											["alt_type"] = "BARO",
											["y"] = 682961.262,
											["formation_template"] = "",
											["name"] = "DictKey_WptName_304",
											["ETA_locked"] = true,
											["speed"] = 0,
											["x"] = -285124.363,
											["task"] = 
											{
												["id"] = "ComboTask",
												["params"] = 
												{
													["tasks"] = 
													{
														[1] = 
														{
															["number"] = 1,
															["auto"] = false,
															["id"] = "WrappedAction",
															["enabled"] = true,
															["params"] = 
															{
																["action"] = 
																{
																	["id"] = "SetOption",
																	["params"] = 
																	{
																		["value"] = 4,
																		["name"] = 0,
																	}, -- end of ["params"]
																}, -- end of ["action"]
															}, -- end of ["params"]
														}, -- end of [1]
													}, -- end of ["tasks"]
												}, -- end of ["params"]
											}, -- end of ["task"]
											["ETA"] = 0,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 304,
								["tasks"] = {},
								["hidden"] = false,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "T-72B",
										["transportable"] = 
										{
											["randomTransportable"] = false,
										}, -- end of ["transportable"]
										["unitId"] = 3004,
										["skill"] = "Average",
										["y"] = 682961.262,
										["x"] = -285124.363,
										["name"] = "DictKey_UnitName_3004",
										["playerCanDrive"] = false,
										["heading"] = 4.43309,
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = 682961.262,
								["x"] = -285124.363,
								["name"] = "DictKey_GroupName_304",
								["start_time"] = 0,
							}, -- end of [4]
							[5] = 
							{
								["visible"] = true,
								["taskSelected"] = true,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 46.54,
											["type"] = "Turning Point",
											["action"] = "Off Road",
											["alt_type"] = "BARO",
											["y"] = 683441.893,
											["formation_template"] = "",
											["name"] = "DictKey_WptName_305",
											["ETA_locked"] = true,
											["speed"] = 0,
											["x"] = -284986.5445,
											["task"] = 
											{
												["id"] = "ComboTask",
												["params"] = 
												{
													["tasks"] = 
													{
														[1] = 
														{
															["number"] = 1,
															["auto"] = false,
															["id"] = "WrappedAction",
															["enabled"] = true,
															["params"] = 
															{
																["action"] = 
																{
																	["id"] = "SetOption",
																	["params"] = 
																	{
																		["value"] = 4,
																		["name"] = 0,
																	}, -- end of ["params"]
																}, -- end of ["action"]
															}, -- end of ["params"]
														}, -- end of [1]
													}, -- end of ["tasks"]
												}, -- end of ["params"]
											}, -- end of ["task"]
											["ETA"] = 0,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 305,
								["tasks"] = {},
								["hidden"] = false,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "Bunker",
										["transportable"] = 
										{
											["randomTransportable"] = false,
										}, -- end of ["transportable"]
										["unitId"] = 3005,
										["skill"] = "Average",
										["y"] = 683441.893,
										["x"] = -284986.5445,
										["name"] = "DictKey_UnitName_3005",
										["playerCanDrive"] = false,
										["heading"] = 4.43309,
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = 683441.893,
								["x"] = -284986.5445,
								["name"] = "DictKey_GroupName_305",
								["start_time"] = 0,
							}, -- end of [5]
						}, -- end of ["group"]
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
					["static"] = 
					{
						["group"] = 
						{
							[13] = 
							{
								["y"] = 854007.14285714,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -212996.28571429,
											["y"] = 854007.14285714,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 188,
								["dead"] = false,
								["name"] = "DictKey_GroupName_1480",
								["x"] = -212996.28571429,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "PalatkaB",
										["type"] = "FARP Tent",
										["unitId"] = 741,
										["rate"] = 50,
										["y"] = 854007.14285714,
										["x"] = -212996.28571429,
										["name"] = "DictKey_GroupName_1480",
										["category"] = "Fortifications",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [13]
							[7] = 
							{
								["y"] = 853990.28571429,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -213157.71428572,
											["y"] = 853990.28571429,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 180,
								["dead"] = false,
								["name"] = "DictKey_GroupName_1451",
								["x"] = -213157.71428572,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "FARP",
										["unitId"] = 728,
										["heading"] = 0,
										["y"] = 853990.28571429,
										["x"] = -213157.71428572,
										["name"] = "DictKey_GroupName_1451",
										["category"] = "Heliports",
										["canCargo"] = false,
										["heliport_callsign_id"] = 6,
										["heliport_frequency"] = "130.5",
										["heliport_modulation"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [7]
							[1] = 
							{
								["y"] = 815601.71428572,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -112653.71428572,
											["y"] = 815601.71428572,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 124,
								["dead"] = false,
								["name"] = "DictKey_GroupName_927",
								["x"] = -112653.71428572,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "FARP",
										["unitId"] = 393,
										["heading"] = 0,
										["y"] = 815601.71428572,
										["x"] = -112653.71428572,
										["name"] = "DictKey_GroupName_927",
										["category"] = "Heliports",
										["canCargo"] = false,
										["heliport_callsign_id"] = 2,
										["heliport_frequency"] = "128.5",
										["heliport_modulation"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [1]
							[2] = 
							{
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -112771.14285715,
											["y"] = 815528.85714286,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 126,
								["hidden"] = false,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "ZiL-131 APA-80",
										["unitId"] = 398,
										["rate"] = 6,
										["y"] = 815528.85714286,
										["x"] = -112771.14285715,
										["name"] = "DictKey_GroupName_936",
										["category"] = "Unarmed",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = 815528.85714286,
								["x"] = -112771.14285715,
								["name"] = "DictKey_GroupName_936",
								["dead"] = false,
							}, -- end of [2]
							[4] = 
							{
								["y"] = 853984.28571429,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -212848.57142857,
											["y"] = 853984.28571429,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 156,
								["dead"] = false,
								["name"] = "DictKey_GroupName_1315",
								["x"] = -212848.57142857,
								["units"] = 
								{
									[1] = 
									{
										["type"] = "FARP",
										["unitId"] = 658,
										["heading"] = 0,
										["y"] = 853984.28571429,
										["x"] = -212848.57142857,
										["name"] = "DictKey_GroupName_1315",
										["category"] = "Heliports",
										["canCargo"] = false,
										["heliport_callsign_id"] = 5,
										["heliport_frequency"] = "130.5",
										["heliport_modulation"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [4]
							[8] = 
							{
								["y"] = 853922.85714286,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -213270.28571429,
											["y"] = 853922.85714286,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 182,
								["dead"] = false,
								["name"] = "DictKey_GroupName_1459",
								["x"] = -213270.28571429,
								["units"] = 
								{
									[1] = 
									{
										["y"] = 853922.85714286,
										["type"] = "ZiL-131 APA-80",
										["name"] = "DictKey_GroupName_1459",
										["unitId"] = 732,
										["canCargo"] = false,
										["heading"] = 0,
										["category"] = "Unarmed",
										["x"] = -213270.28571429,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [8]
							[15] = 
							{
								["y"] = 840082.85714285,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -150861.71428571,
											["y"] = 840082.85714285,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 224,
								["dead"] = false,
								["name"] = "DictKey_GroupName_1969",
								["x"] = -150861.71428571,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "sklad",
										["type"] = "Warehouse",
										["unitId"] = 900,
										["y"] = 840082.85714285,
										["x"] = -150861.71428571,
										["name"] = "DictKey_GroupName_1969",
										["category"] = "Warehouses",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [15]
							[9] = 
							{
								["y"] = 853907.71428572,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -212996.57142857,
											["y"] = 853907.71428572,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 184,
								["dead"] = false,
								["name"] = "DictKey_GroupName_1468",
								["x"] = -212996.57142857,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "tr_budka",
										["type"] = "Electric power box",
										["unitId"] = 737,
										["y"] = 853907.71428572,
										["x"] = -212996.57142857,
										["name"] = "DictKey_GroupName_1468",
										["category"] = "Fortifications",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [9]
							[5] = 
							{
								["y"] = 853908,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -212973.71428571,
											["y"] = 853908,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 173,
								["dead"] = false,
								["name"] = "DictKey_GroupName_1426",
								["x"] = -212973.71428571,
								["units"] = 
								{
									[1] = 
									{
										["y"] = 853908,
										["type"] = "ZiL-131 APA-80",
										["name"] = "DictKey_GroupName_1426",
										["unitId"] = 717,
										["canCargo"] = false,
										["heading"] = 0,
										["category"] = "Unarmed",
										["x"] = -212973.71428571,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [5]
							[10] = 
							{
								["y"] = 853931.71428572,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -212996.85714286,
											["y"] = 853931.71428572,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 185,
								["dead"] = false,
								["name"] = "DictKey_GroupName_1471",
								["x"] = -212996.85714286,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "SetkaKP",
										["type"] = "FARP Ammo Dump Coating",
										["unitId"] = 738,
										["livery_id"] = "GRC_autumn",
										["rate"] = 50,
										["y"] = 853931.71428572,
										["x"] = -212996.85714286,
										["name"] = "DictKey_GroupName_1471",
										["category"] = "Fortifications",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [10]
							[14] = 
							{
								["y"] = 635920.00000003,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -317719.99999999,
											["y"] = 635920.00000003,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 222,
								["dead"] = false,
								["name"] = "DictKey_GroupName_1958",
								["x"] = -317719.99999999,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "sklad",
										["type"] = "Warehouse",
										["unitId"] = 893,
										["rate"] = 100,
										["y"] = 635920.00000003,
										["x"] = -317719.99999999,
										["name"] = "DictKey_GroupName_1958",
										["category"] = "Warehouses",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [14]
							[3] = 
							{
								["y"] = 449254.85714286,
								["heading"] = 0.017453292519943,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -238872.85714286,
											["y"] = 449254.85714286,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 131,
								["dead"] = false,
								["name"] = "DictKey_GroupName_977",
								["x"] = -238872.85714286,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "plavbaza",
										["type"] = "Oil platform",
										["unitId"] = 417,
										["y"] = 449254.85714286,
										["x"] = -238872.85714286,
										["name"] = "DictKey_GroupName_977",
										["category"] = "Fortifications",
										["canCargo"] = false,
										["heading"] = 0.017453292519943,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [3]
							[6] = 
							{
								["y"] = 853601.14285714,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -213016.28571429,
											["y"] = 853601.14285714,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 178,
								["dead"] = false,
								["name"] = "DictKey_GroupName_1445",
								["x"] = -213016.28571429,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "sklad",
										["type"] = "Warehouse",
										["unitId"] = 726,
										["y"] = 853601.14285714,
										["x"] = -213016.28571429,
										["name"] = "DictKey_GroupName_1445",
										["category"] = "Warehouses",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [6]
							[12] = 
							{
								["y"] = 853982.85714286,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -212996.85714286,
											["y"] = 853982.85714286,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 187,
								["dead"] = false,
								["name"] = "DictKey_GroupName_1477",
								["x"] = -212996.85714286,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "GSM Rus",
										["type"] = "FARP Fuel Depot",
										["unitId"] = 740,
										["livery_id"] = "GRC_autumn",
										["rate"] = 20,
										["y"] = 853982.85714286,
										["x"] = -212996.85714286,
										["name"] = "DictKey_GroupName_1477",
										["category"] = "Fortifications",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [12]
							[11] = 
							{
								["y"] = 853957.71428572,
								["heading"] = 0,
								["route"] = 
								{
									["points"] = 
									{
										[1] = 
										{
											["alt"] = 0,
											["type"] = "",
											["name"] = "",
											["action"] = "",
											["speed"] = 0,
											["formation_template"] = "",
											["x"] = -212996.85714286,
											["y"] = 853957.71428572,
										}, -- end of [1]
									}, -- end of ["points"]
								}, -- end of ["route"]
								["groupId"] = 186,
								["dead"] = false,
								["name"] = "DictKey_GroupName_1474",
								["x"] = -212996.85714286,
								["units"] = 
								{
									[1] = 
									{
										["shape_name"] = "kp_ug",
										["type"] = "FARP CP Blindage",
										["unitId"] = 739,
										["rate"] = 100,
										["y"] = 853957.71428572,
										["x"] = -212996.85714286,
										["name"] = "DictKey_GroupName_1474",
										["category"] = "Fortifications",
										["canCargo"] = false,
										["heading"] = 0,
									}, -- end of [1]
								}, -- end of ["units"]
							}, -- end of [11]
						}, -- end of ["group"]
					}, -- end of ["static"]
				}, -- end of [8]
				[9] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Serbia",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 43,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [9]
				[5] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Iran",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 34,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [5]
				[10] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "South Ossetia",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 19,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [10]
				[3] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "China",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 27,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [3]
				[6] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Kazakhstan",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 37,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [6]
				[12] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "USAF Aggressors",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 7,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [12]
				[11] = 
				{
					["helicopter"] = 
					{
						["group"] = {},
					}, -- end of ["helicopter"]
					["name"] = "Syria",
					["ship"] = 
					{
						["group"] = {},
					}, -- end of ["ship"]
					["id"] = 47,
					["vehicle"] = 
					{
						["group"] = {},
					}, -- end of ["vehicle"]
					["plane"] = 
					{
						["group"] = {},
					}, -- end of ["plane"]
				}, -- end of [11]
			}, -- end of ["country"]
		}, -- end of ["red"]
	}, -- end of ["coalition"]
	["pictureFileNameB"] = {},
	["sortie"] = "DictKey_sortie_4",
	["descriptionBlueTask"] = "DictKey_descriptionBlueTask_3",
	["needModules"] = 
	{
		["F-5E/E-3 by Belsimtek"] = "F-5E/E-3 by Belsimtek",
		["MiG-21Bis AI by Leatherneck Simulations"] = "MiG-21Bis AI by Leatherneck Simulations",
		["TF-51D Mustang by Eagle Dynamics"] = "TF-51D Mustang by Eagle Dynamics",
		["C-101 Aviojet by AvioDev"] = "C-101 Aviojet by AvioDev",
		["./CoreMods/aircraft/MQ-9 Reaper"] = "./CoreMods/aircraft/MQ-9 Reaper",
		["M-2000C AI by RAZBAM Sims"] = "M-2000C AI by RAZBAM Sims",
		["MiG-15bis AI by Eagle Dynamics"] = "MiG-15bis AI by Eagle Dynamics",
		["L-39C/ZA by Eagle Dynamics"] = "L-39C/ZA by Eagle Dynamics",
	}, -- end of ["needModules"]
	["descriptionRedTask"] = "DictKey_descriptionRedTask_2",
	["trigrules"] = 
	{
		[1] = 
		{
			["rules"] = {},
			["eventlist"] = "",
			["comment"] = "LOAD_ADAP_RADIO_MENU",
			["predicate"] = "triggerStart",
			["actions"] = 
			{
				[1] = 
				{
					["predicate"] = "a_do_script_file",
					["file"] = "ResKey_ADAP_Menu",
				}, -- end of [1]
			}, -- end of ["actions"]
			["colorItem"] = "0x00ffffff",
		}, -- end of [1]
	}, -- end of ["trigrules"]
	["forcedOptions"] = 
	{
		["easyFlight"] = false,
		["padlock"] = false,
		["radio"] = false,
		["geffect"] = "realistic",
		["fuel"] = false,
		["easyRadar"] = false,
		["easyCommunication"] = false,
		["civTraffic"] = "",
		["accidental_failures"] = false,
		["birds"] = 0,
		["optionsView"] = "optview_allies",
		["permitCrash"] = false,
		["immortal"] = false,
		["weapons"] = false,
		["cockpitVisualRM"] = false,
		["labels"] = false,
	}, -- end of ["forcedOptions"]
	["triggers"] = 
	{
		["zones"] = 
		{
			[27] = 
			{
				["y"] = 854030,
				["radius"] = 100,
				["zoneId"] = 2919,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "RadioBeacon6",
				["hidden"] = false,
				["x"] = -212997.14285714,
			}, -- end of [27]
			[2] = 
			{
				["y"] = 841271.42857146,
				["radius"] = 6400,
				["zoneId"] = 459,
				["color"] = 
				{
					[1] = 0,
					[2] = 0.25098039215686,
					[4] = 0.14901960784314,
					[3] = 0.25098039215686,
				}, -- end of ["color"]
				["name"] = "Medium Range",
				["hidden"] = false,
				["x"] = -153259.99999999,
			}, -- end of [2]
			[3] = 
			{
				["y"] = 854675.71428576,
				["radius"] = 3000,
				["zoneId"] = 460,
				["color"] = 
				{
					[1] = 1,
					[2] = 0,
					[4] = 0.14901960784314,
					[3] = 0,
				}, -- end of ["color"]
				["name"] = "Hard Range",
				["hidden"] = false,
				["x"] = -210151.42857142,
			}, -- end of [3]
			[4] = 
			{
				["y"] = 705628.57142857,
				["radius"] = 2000,
				["zoneId"] = 614,
				["color"] = 
				{
					[1] = 0,
					[2] = 1,
					[4] = 0.14901960784314,
					[3] = 0,
				}, -- end of ["color"]
				["name"] = "pickzone2",
				["hidden"] = false,
				["x"] = -51355.142857126,
			}, -- end of [4]
			[5] = 
			{
				["y"] = 834434.28571429,
				["radius"] = 3600,
				["zoneId"] = 615,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "pickzone3",
				["hidden"] = false,
				["x"] = -83309.42857141,
			}, -- end of [5]
			[6] = 
			{
				["y"] = 834899.42857144,
				["radius"] = 101,
				["zoneId"] = 770,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "radioBeacon2",
				["hidden"] = false,
				["x"] = -82713.999999978,
			}, -- end of [6]
			[7] = 
			{
				["y"] = 706528.00000002,
				["radius"] = 100,
				["zoneId"] = 771,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "radioBeacon3",
				["hidden"] = false,
				["x"] = -50923.999999978,
			}, -- end of [7]
			[8] = 
			{
				["y"] = 786807.14285715,
				["radius"] = 8000,
				["zoneId"] = 924,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "dropzone1",
				["hidden"] = false,
				["x"] = -86643.428571408,
			}, -- end of [8]
			[10] = 
			{
				["y"] = 815574.57142858,
				["radius"] = 50000,
				["zoneId"] = 1078,
				["color"] = 
				{
					[1] = 0.50196078431373,
					[2] = 0,
					[4] = 0.14901960784314,
					[3] = 0,
				}, -- end of ["color"]
				["name"] = "Practice Drone Range",
				["hidden"] = false,
				["x"] = -112648.57142855,
			}, -- end of [10]
			[12] = 
			{
				["y"] = 760206.57142858,
				["radius"] = 100,
				["zoneId"] = 1232,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "radioBeacon1",
				["hidden"] = false,
				["x"] = -124194.28571428,
			}, -- end of [12]
			[14] = 
			{
				["y"] = 807926.28571429,
				["radius"] = 3000,
				["zoneId"] = 1538,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "Convoy Range 02",
				["hidden"] = false,
				["x"] = -158516,
			}, -- end of [14]
			[16] = 
			{
				["y"] = 852583.42857143,
				["radius"] = 3000,
				["zoneId"] = 1540,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "Convoy Range 04",
				["hidden"] = false,
				["x"] = -166401.71428571,
			}, -- end of [16]
			[20] = 
			{
				["y"] = 806302.00000007,
				["radius"] = 100,
				["zoneId"] = 1848,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "radioBeacon5",
				["hidden"] = false,
				["x"] = -86685.714285713,
			}, -- end of [20]
			[24] = 
			{
				["y"] = 454008.57142857,
				["radius"] = 80000,
				["zoneId"] = 2460,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "Extreme Range",
				["hidden"] = false,
				["x"] = -234059.14285714,
			}, -- end of [24]
			[28] = 
			{
				["y"] = 631224.28571429,
				["radius"] = 800,
				["zoneId"] = 3072,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "REDFOR Easy Range",
				["hidden"] = false,
				["x"] = -328284.28571429,
			}, -- end of [28]
			[32] = 
			{
				["y"] = 647221.42857143,
				["radius"] = 3000,
				["zoneId"] = 3228,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "pickzone7",
				["hidden"] = false,
				["x"] = -281558.57142857,
			}, -- end of [32]
			[33] = 
			{
				["y"] = 683875.71428572,
				["radius"] = 3000,
				["zoneId"] = 3229,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "pickzone8",
				["hidden"] = false,
				["x"] = -285038.57142857,
			}, -- end of [33]
			[17] = 
			{
				["y"] = 793485.71428571,
				["radius"] = 3000,
				["zoneId"] = 1541,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "Convoy Range 06",
				["hidden"] = false,
				["x"] = -107601.71428571,
			}, -- end of [17]
			[21] = 
			{
				["y"] = 806292.28571429,
				["radius"] = 3000,
				["zoneId"] = 2001,
				["color"] = 
				{
					[1] = 0,
					[2] = 0,
					[4] = 0.14901960784314,
					[3] = 0,
				}, -- end of ["color"]
				["name"] = "pickzone4",
				["hidden"] = false,
				["x"] = -86685.999999979,
			}, -- end of [21]
			[25] = 
			{
				["y"] = 452003.42857143,
				["radius"] = 150000,
				["zoneId"] = 2613,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "Extreme Engaged",
				["hidden"] = false,
				["x"] = -234015.71428571,
			}, -- end of [25]
			[29] = 
			{
				["y"] = 719121.42857142,
				["radius"] = 1700,
				["zoneId"] = 3073,
				["color"] = 
				{
					[1] = 0,
					[2] = 0,
					[4] = 0.14901960784314,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "REDFOR Medium Range",
				["hidden"] = false,
				["x"] = -284934.28571429,
			}, -- end of [29]
			[34] = 
			{
				["y"] = 631227.14285716,
				["radius"] = 1500,
				["zoneId"] = 3230,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "dropzone4",
				["hidden"] = false,
				["x"] = -328298.57142857,
			}, -- end of [34]
			[9] = 
			{
				["y"] = 780878.57142858,
				["radius"] = 1000,
				["zoneId"] = 925,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "radioBeacon4",
				["hidden"] = false,
				["x"] = -82721.142857123,
			}, -- end of [9]
			[11] = 
			{
				["y"] = 760510.00000001,
				["radius"] = 1300,
				["zoneId"] = 1231,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "pickzone1",
				["hidden"] = false,
				["x"] = -124995.14285712,
			}, -- end of [11]
			[13] = 
			{
				["y"] = 836695.71428574,
				["radius"] = 4200,
				["zoneId"] = 1385,
				["color"] = 
				{
					[1] = 0.50196078431373,
					[2] = 0,
					[4] = 0.14901960784314,
					[3] = 0,
				}, -- end of ["color"]
				["name"] = "Convoy Range 01",
				["hidden"] = false,
				["x"] = -117495.14285712,
			}, -- end of [13]
			[15] = 
			{
				["y"] = 788126.28571429,
				["radius"] = 3000,
				["zoneId"] = 1539,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "Convoy Range 03",
				["hidden"] = false,
				["x"] = -157116,
			}, -- end of [15]
			[18] = 
			{
				["y"] = 839064.28571428,
				["radius"] = 9000,
				["zoneId"] = 1694,
				["color"] = 
				{
					[1] = 0.50196078431373,
					[2] = 1,
					[4] = 0.14901960784314,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "dropzone2",
				["hidden"] = false,
				["x"] = -144341.42857144,
			}, -- end of [18]
			[22] = 
			{
				["y"] = 635514.57142857,
				["radius"] = 90000,
				["zoneId"] = 2154,
				["color"] = 
				{
					[1] = 1,
					[2] = 0,
					[4] = 0.14901960784314,
					[3] = 0,
				}, -- end of ["color"]
				["name"] = "Red Range",
				["hidden"] = false,
				["x"] = -317879.99999999,
			}, -- end of [22]
			[26] = 
			{
				["y"] = 853581.42857143,
				["radius"] = 1000,
				["zoneId"] = 2766,
				["color"] = 
				{
					[1] = 1,
					[2] = 0,
					[4] = 0.14901960784314,
					[3] = 0,
				}, -- end of ["color"]
				["name"] = "pickzone5",
				["hidden"] = false,
				["x"] = -213115.14285714,
			}, -- end of [26]
			[30] = 
			{
				["y"] = 734542.85714285,
				["radius"] = 3000,
				["zoneId"] = 3074,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "REDFOR Hard Range",
				["hidden"] = false,
				["x"] = -239711.42857144,
			}, -- end of [30]
			[36] = 
			{
				["y"] = 734432.85714287,
				["radius"] = 3000,
				["zoneId"] = 3232,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "dropzone6",
				["hidden"] = false,
				["x"] = -239705.71428572,
			}, -- end of [36]
			[35] = 
			{
				["y"] = 718925.71428572,
				["radius"] = 3000,
				["zoneId"] = 3231,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "dropzone5",
				["hidden"] = false,
				["x"] = -284850.00000001,
			}, -- end of [35]
			[1] = 
			{
				["y"] = 786771.42857142,
				["radius"] = 6000,
				["zoneId"] = 306,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.14901960784314,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "Easy Range",
				["hidden"] = false,
				["x"] = -86991.428571432,
			}, -- end of [1]
			[19] = 
			{
				["y"] = 854684.57142857,
				["radius"] = 25000,
				["zoneId"] = 1695,
				["color"] = 
				{
					[1] = 0.50196078431373,
					[2] = 0,
					[4] = 0.14901960784314,
					[3] = 0.50196078431373,
				}, -- end of ["color"]
				["name"] = "dropzone3",
				["hidden"] = false,
				["x"] = -210151.14285714,
			}, -- end of [19]
			[23] = 
			{
				["y"] = 825868.57142857,
				["radius"] = 3000,
				["zoneId"] = 2307,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "Convoy Range 05",
				["hidden"] = false,
				["x"] = -93971.428571428,
			}, -- end of [23]
			[31] = 
			{
				["y"] = 635759.99999999,
				["radius"] = 1400,
				["zoneId"] = 3227,
				["color"] = 
				{
					[1] = 1,
					[2] = 1,
					[4] = 0.15,
					[3] = 1,
				}, -- end of ["color"]
				["name"] = "pickzone6",
				["hidden"] = false,
				["x"] = -317800,
			}, -- end of [31]
		}, -- end of ["zones"]
	}, -- end of ["triggers"]
} -- end of mission
