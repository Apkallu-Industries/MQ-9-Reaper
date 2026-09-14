local self_ID = "MQ-9 Reaper Flyable"
declare_plugin(self_ID,
{
displayName     = _("MQ-9 Reaper (Flyable)"),
developerName   = "Eagle Dynamics / Yutani Industries",

image     	    = "FC3.bmp",
installed 	    = true,
dirName	  	    = current_mod_path,
fileMenuName    = _("MQ-9 Reaper"),

version		    = "0.0.1v",
state		    = "installed",
info		    = _("General Atomics MQ-9 Reaper Unmanned Aerial Vehicle (Flyable Mod)."),

InputProfiles =
{
    ["MQ-9_Reaper"] = current_mod_path .. '/Input/MQ-9 Reaper',
    ["MQ-9 Reaper"] = current_mod_path .. '/Input/MQ-9 Reaper',
},

Options =
{
    {
        name   = _("MQ-9 Reaper"),
        nameId = "MQ-9_Reaper",
        dir    = "Options",
        CLSID  = "{MQ-9_Reaper options}"
    },
},

Skins =
	{
		{
			name	= _("MQ-9 Reaper"),
			dir		= "Theme"
		},
	},
	
Missions =
	{
		{
			name		    = _("MQ-9 Reaper"),
			dir			    = "Missions",
            training_ids    = {EN = 'SU-25T_video_EN', RU = 'SU-25T_video_RU'},
		},
	},		

LogBook =
	{
		{
			name		= _("MQ-9_Reaper"),
			type		= "MQ-9_Reaper",
		},
		{
			name		= _("MQ-9 Reaper"),
			type		= "MQ-9 Reaper",
		},
	},		
})

mount_vfs_texture_path(current_mod_path ..  "/Theme/ME")
mount_vfs_texture_path(current_mod_path ..  "/Textures")
mount_vfs_texture_path(current_mod_path ..  "/Textures/mq-9_reaper_textures.zip")
mount_vfs_texture_path(current_mod_path ..  "/Cockpit/Textures/SU-25T-CPT-TEXTURES.zip")
mount_vfs_texture_path("Bazar/Textures/AvionicsCommon")
mount_vfs_model_path(current_mod_path ..  "/Shapes")
mount_vfs_model_path(current_mod_path ..  "/Cockpit/Shape")
mount_vfs_liveries_path(current_mod_path ..  "/Liveries")

local support_cockpit = current_mod_path .. '/Cockpit/Scripts/'

dofile(current_mod_path .. "/Views.lua")
dofile(current_mod_path .. "/MQ-9.lua")
make_view_settings('MQ-9_Reaper', ViewSettings, SnapViews)

----------------------------------------------------------------------------------------
if MAC_flyable then
    MAC_flyable('MQ-9_Reaper', support_cockpit, nil, current_mod_path .. '/comm.lua')
else
    make_flyable('MQ-9_Reaper', support_cockpit, nil, current_mod_path .. '/comm.lua')
end
----------------------------------------------------------------------------------------
plugin_done()
