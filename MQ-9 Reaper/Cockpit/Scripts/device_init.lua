attributes = {
	"support_for_cws",
}
---------------------------------------------
dofile(LockOn_Options.common_script_path.."KNEEBOARD/declare_kneeboard_device_left.lua")
---------------------------------------------
-- Own main panel and cockpit shape (BNS-AV-GCS-0001, sensor view, no geometry): without this line DCS falls back
-- to the cockpit of the CWS shell aircraft, an ED asset (clean-room fix 2026-10-29).
MainPanel = {"ccMainPanel", LockOn_Options.script_path .. "mainpanel_init.lua"}
---------------------------------------------
---------------------------------------------
devices = devices or {}
devices["GCS_CONTROLLER"] = 1

creators = creators or {}
creators[devices.GCS_CONTROLLER] = {"avLuaDevice", LockOn_Options.script_path .. "GCS_Controller.lua"}

indicators = indicators or {}
indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."GCS_HUD/init.lua", devices.GCS_CONTROLLER}
