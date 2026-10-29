local self_ID = "MQ-9 Reaper Flyable"
-- BNS external flight model (bin\BNS_MQ9_EFM.dll, source efm\ at the repository root, data FM\MQ9_FM.lua).
-- ON from 2026-10-08 for the owner's first flight (Root: every aircraft gets its EFM); false goes back to the
-- standard flight model of the CWS shell (old = 54).
local BNS_MQ9_USE_EFM = true
declare_plugin(self_ID,
{
displayName     = _("BNS MQ-9 Reaper"),
shortName       = "MQ-9_Reaper_Flyable",
developerName   = "Blacknet Systems",

image     	    = "FC3.bmp",
installed 	    = true,
dirName	  	    = current_mod_path,
fileMenuName    = _("MQ-9 Reaper Flyable"),
update_id       = "MQ-9_Reaper_Flyable",

version		    = "0.0.1v",
state		    = "installed",
binaries	    = BNS_MQ9_USE_EFM and { "BNS_MQ9_EFM.dll" } or nil,
info		    = _("General Atomics MQ-9 Reaper Unmanned Aerial Vehicle (Flyable Mod)."),

InputProfiles =
{
    ["MQ-9_Reaper_Flyable"] = current_mod_path .. '/Input/MQ-9_Reaper_Flyable',
},

-- No Options page: the old one was ED's cockpit-livery chooser for the borrowed cockpit (removed 2026-10-29).

Skins =
	{
		{
			name	= _("MQ-9 Reaper Flyable"),
			dir		= "Theme"
		},
	},
	
Missions =
	{
		{
			name		    = _("MQ-9 Reaper Flyable"),
			dir			    = "Missions",
		},
	},		

LogBook =
	{
		{
			name		= _("MQ-9 Reaper Flyable"),
			type		= "MQ-9_Reaper_Flyable",
		},
	},		
})

-- Clean-room (2026-10-29): the mod ships no ED files. The exterior shape "mq-9_reaper" (+ LODs, collision, damage
-- parts) and its textures are ED's own MQ-9, resolved from the DCS install (Bazar/World/Shapes, Bazar/World/textures,
-- the same files ED's AI MQ-9 uses), never copied in. The cockpit shape is BNS-AV-GCS-0001 (Cockpit/Shape).
mount_vfs_texture_path(current_mod_path ..  "/Theme/ME")
mount_vfs_texture_path("Bazar/Textures/AvionicsCommon")
mount_vfs_model_path(current_mod_path ..  "/Cockpit/Shape")
mount_vfs_liveries_path(current_mod_path ..  "/Liveries")

local support_cockpit = current_mod_path .. '/Cockpit/Scripts/'

-- Flyable registration: CWS avionics (support_for_cws), BNS EFM, BNS main panel and cockpit shape (Cockpit/Scripts)
if BNS_MQ9_USE_EFM then
    dofile(current_mod_path .. "/FM/MQ9_FM.lua")    -- FM table: empty mass properties + undercarriage
    FM[1] = self_ID
    FM[2] = "BNS_MQ9_EFM.dll"
    make_flyable('MQ-9_Reaper_Flyable', support_cockpit, FM, current_mod_path .. '/comm.lua')
else
    make_flyable('MQ-9_Reaper_Flyable', support_cockpit, {nil, old = 54}, current_mod_path .. '/comm.lua')
end

-- Load aircraft descriptor into DCS database
dofile(current_mod_path .. "/MQ-9.lua")

-- Load and attach view settings
dofile(current_mod_path .. "/Views.lua")
make_view_settings('MQ-9_Reaper_Flyable', ViewSettings, SnapViews)

plugin_done()
