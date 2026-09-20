local self_ID = "MQ-9 Reaper Flyable"
declare_plugin(self_ID,
{
displayName     = _("MQ-9 Reaper (Flyable)"),
shortName       = "MQ-9_Reaper_Flyable",
developerName   = "Blacknet Systems",

image     	    = "FC3.bmp",
installed 	    = true,
dirName	  	    = current_mod_path,
fileMenuName    = _("MQ-9 Reaper Flyable"),
update_id       = "MQ-9_Reaper_Flyable",

version		    = "0.0.1v",
state		    = "installed",
info		    = _("General Atomics MQ-9 Reaper Unmanned Aerial Vehicle (Flyable Mod)."),

InputProfiles =
{
    ["MQ-9_Reaper_Flyable"] = current_mod_path .. '/Input/MQ-9_Reaper_Flyable',
},

Options =
{
    {
        name   = _("MQ-9 Reaper Flyable"),
        nameId = "MQ-9_Reaper_Flyable",
        dir    = "Options",
        CLSID  = "{MQ-9_Reaper_Flyable options}"
    },
},

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

mount_vfs_texture_path(current_mod_path ..  "/Theme/ME")
mount_vfs_texture_path(current_mod_path ..  "/Textures")
mount_vfs_texture_path(current_mod_path ..  "/Textures/mq-9_reaper_textures.zip")
mount_vfs_texture_path(current_mod_path ..  "/Cockpit/Textures/SU-25T-CPT-TEXTURES.zip")
mount_vfs_texture_path("Bazar/Textures/AvionicsCommon")
mount_vfs_model_path(current_mod_path ..  "/Shapes")
mount_vfs_model_path(current_mod_path ..  "/Cockpit/Shape")
mount_vfs_liveries_path(current_mod_path ..  "/Liveries")

local support_cockpit = current_mod_path .. '/Cockpit/Scripts/'

-- Flyable registration on Su-25T CWS shell
make_flyable('MQ-9_Reaper_Flyable', support_cockpit, {nil, old = 54}, current_mod_path .. '/comm.lua')

-- Load aircraft descriptor into DCS database
dofile(current_mod_path .. "/MQ-9.lua")

-- Load and attach view settings
dofile(current_mod_path .. "/Views.lua")
make_view_settings('MQ-9_Reaper_Flyable', ViewSettings, SnapViews)

plugin_done()
