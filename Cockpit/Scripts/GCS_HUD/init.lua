dofile(LockOn_Options.common_script_path .. "devices_defs.lua")

indicator_type    = indicator_types.COMMON
purposes          = {
    render_purpose.GENERAL,
    render_purpose.HUD_ONLY_VIEW,
    render_purpose.SCREENSPACE_INSIDE_COCKPIT,
    render_purpose.SCREENSPACE_OUTSIDE_COCKPIT
}
screenspace_scale = 4

BASE       = 1
INDICATION = 2

page_subsets = {
    [BASE]       = LockOn_Options.script_path .. "GCS_HUD/base_page.lua",
    [INDICATION] = LockOn_Options.script_path .. "GCS_HUD/indication_page.lua",
}

pages = {
    { BASE, INDICATION },
}

init_pageID = 1
