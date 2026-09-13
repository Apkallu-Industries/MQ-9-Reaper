attributes = {
	"support_for_cws",
}
---------------------------------------------
dofile(LockOn_Options.common_script_path.."KNEEBOARD/declare_kneeboard_device_left.lua")
---------------------------------------------
---------------------------------------------
devices = devices or {}
devices["GCS_CONTROLLER"] = 1

creators = creators or {}
creators[devices.GCS_CONTROLLER] = {"avLuaDevice", LockOn_Options.script_path .. "GCS_Controller.lua"}

indicators = indicators or {}
indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."GCS_HUD/init.lua", devices.GCS_CONTROLLER}
