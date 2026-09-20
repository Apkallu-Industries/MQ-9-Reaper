dofile(LockOn_Options.common_script_path .. "elements_defs.lua")

DEFAULT_LEVEL = 5

aspect = (LockOn_Options and LockOn_Options.screen and LockOn_Options.screen.aspect) or (16 / 9)
if not aspect or aspect < 1.0 then
    aspect = (16 / 9)
end

-- Military High-Contrast Color Palette
HUD_BLACK        = {  0,   0,   0, 255} -- Solid opaque black for bold outlines
HUD_WHITE        = {255, 255, 255, 255}
HUD_GREEN        = { 40, 255,  90, 255} -- Crisp phosphor green
HUD_GREEN_DIM    = { 25, 210,  70, 230}
HUD_CYAN         = { 80, 235, 255, 255} -- Tactical telemetry cyan
HUD_AMBER        = {255, 205,  45, 255} -- Target lock / weapons amber
HUD_PANEL_BG     = {  8,  14,  22, 215} -- Solid dark tactical visor backing
HUD_PANEL_BORDER = {  0,   0,   0, 255} -- Bold thick solid black outline
HUD_SHADOW       = {  0,   0,   0, 240}

if not matBlack then
    matBlack        = MakeMaterial(nil, HUD_BLACK)
    matWhite        = MakeMaterial(nil, HUD_WHITE)
    matGreen        = MakeMaterial(nil, HUD_GREEN)
    matGreenDim     = MakeMaterial(nil, HUD_GREEN_DIM)
    matCyan         = MakeMaterial(nil, HUD_CYAN)
    matAmber        = MakeMaterial(nil, HUD_AMBER)
    matPanelBg      = MakeMaterial(nil, HUD_PANEL_BG)
    matBorder       = MakeMaterial(nil, HUD_PANEL_BORDER)
    matShadow       = MakeMaterial(nil, HUD_SHADOW)

    fontWhite    = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22_white"}, HUD_WHITE, "fontWhite")
    fontGreen    = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22_white"}, HUD_GREEN, "fontGreen")
    fontGreenDim = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22_white"}, HUD_GREEN_DIM, "fontGreenDim")
    fontCyan     = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22_white"}, HUD_CYAN, "fontCyan")
    fontAmber    = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22_white"}, HUD_AMBER, "fontAmber")
    matMfd0      = MakeMaterial("mfd0", {255, 255, 255, 255})
end

-- Root indicator anchor (Always visible in drone flight & sensor view)
if not gcs_root then
    gcs_root             = CreateElement "ceSimple"
    gcs_root.name        = "gcs_hud_root"
    gcs_root.init_pos    = {0, 0, 0}
    gcs_root.screenspace = ScreenType.SCREENSPACE_TRUE
    Add(gcs_root)
end

function AddElement(object)
    object.screenspace = ScreenType.SCREENSPACE_TRUE
    object.use_mipfilter = true
    object.parent_element = gcs_root.name
    Add(object)
end

-- Tactical Backing Panel (Dark visor backing + thick solid black outline + corner accents)
function addBackgroundBox(name, x, y, width, height)
    local hw = width / 2
    local hh = height / 2

    -- 1. Dark visor tinted backing
    local box           = CreateElement "ceMeshPoly"
    box.name            = name .. "_bg"
    box.material        = matPanelBg
    box.init_pos        = {x, y, 0}
    box.screenspace     = ScreenType.SCREENSPACE_TRUE
    box.use_mipfilter   = true
    box.additive_alpha  = false
    box.blend_mode      = blend_mode.IBM_REGULAR
    box.h_clip_relation = h_clip_relations.NULL
    box.level           = DEFAULT_LEVEL
    box.vertices        = {{-hw, -hh}, {hw, -hh}, {hw, hh}, {-hw, hh}}
    box.indices         = {0, 1, 2, 0, 2, 3}
    AddElement(box)

    -- 2. Thick solid black border outline
    local border           = CreateElement "ceSMultiLine"
    border.name            = name .. "_border"
    border.material        = matBlack
    border.init_pos        = {x, y, 0}
    border.screenspace     = ScreenType.SCREENSPACE_TRUE
    border.use_mipfilter   = true
    border.additive_alpha  = false
    border.blend_mode      = blend_mode.IBM_REGULAR
    border.h_clip_relation = h_clip_relations.NULL
    border.level           = DEFAULT_LEVEL + 1
    border.vertices        = {{-hw, -hh}, {hw, -hh}, {hw, hh}, {-hw, hh}, {-hw, -hh}}
    border.indices         = {0, 1, 1, 2, 2, 3, 3, 4}
    border.thickness       = 6.0
    AddElement(border)

    -- 3. Corner tick accents (military HUD corner brackets)
    local cLen = 0.040
    local corners = {
        {{-hw, -hh + cLen}, {-hw, -hh}, {-hw + cLen, -hh}},
        {{ hw - cLen, -hh}, { hw, -hh}, { hw, -hh + cLen}},
        {{ hw,  hh - cLen}, { hw,  hh}, { hw - cLen,  hh}},
        {{-hw + cLen,  hh}, {-hw,  hh}, {-hw,  hh - cLen}},
    }
    for ci, cverts in ipairs(corners) do
        local cAcc           = CreateElement "ceSMultiLine"
        cAcc.name            = name .. "_c" .. ci
        cAcc.material        = matWhite
        cAcc.init_pos        = {x, y, 0}
        cAcc.screenspace     = ScreenType.SCREENSPACE_TRUE
        cAcc.use_mipfilter   = true
        cAcc.additive_alpha  = false
        cAcc.blend_mode      = blend_mode.IBM_REGULAR
        cAcc.h_clip_relation = h_clip_relations.NULL
        cAcc.level           = DEFAULT_LEVEL + 2
        cAcc.vertices        = cverts
        cAcc.indices         = {0, 1, 1, 2}
        cAcc.thickness       = 3.5
        AddElement(cAcc)
    end

    return box
end

function addDot(name, radius, pos, mat)
    local dot           = CreateElement "ceMeshPoly"
    dot.name            = name
    dot.material        = mat or matGreen
    pos = pos or {0, 0}
    dot.init_pos        = {pos[1], pos[2], 0}
    dot.h_clip_relation = h_clip_relations.NULL
    dot.level           = DEFAULT_LEVEL + 2
    dot.collimated      = false
    set_circle(dot, radius, 0, 360, 20)
    AddElement(dot)
    return dot
end

function addLineSegment(name, p1, p2, mat, thickness)
    local line           = CreateElement "ceSMultiLine"
    line.name            = name
    line.material        = mat or matGreen
    line.init_pos        = {0, 0, 0}
    line.h_clip_relation = h_clip_relations.NULL
    line.level           = DEFAULT_LEVEL + 2
    line.vertices        = {p1, p2}
    line.indices         = {0, 1}
    line.thickness       = thickness or 2.0
    line.fuzziness       = 0.8
    AddElement(line)
    return line
end

-- Dual-layer line: dark shadow backing behind sharp foreground
function addDualLine(name, p1, p2, thickness, mat)
    thickness = thickness or 2.2
    addLineSegment(name .. "_bg", p1, p2, matShadow, thickness + 2.0)
    addLineSegment(name .. "_fg", p1, p2, mat or matGreen, thickness)
end

function addDualCorner(name, cx, cy, dirX, dirY, size, thickness, mat)
    local h1 = {cx, cy}
    local h2 = {cx + dirX * size, cy}
    addDualLine(name .. "_h", h1, h2, thickness, mat)

    local v1 = {cx, cy}
    local v2 = {cx, cy + dirY * size}
    addDualLine(name .. "_v", v1, v2, thickness, mat)
end

function addStaticText(name, text, pos, align, font, stringdefs)
    local txt           = CreateElement "ceStringPoly"
    txt.name            = name
    txt.material        = font or fontWhite
    txt.alignment       = align or "LeftCenter"
    txt.stringdefs      = stringdefs or {0.0016, 0.0016, 0, 0}
    txt.use_mipfilter   = true
    txt.screenspace     = ScreenType.SCREENSPACE_TRUE
    pos = pos or {0, 0}
    txt.init_pos        = {pos[1], pos[2], 0}
    txt.h_clip_relation = h_clip_relations.NULL
    txt.level           = DEFAULT_LEVEL + 2
    txt.value           = text or ""
    AddElement(txt)
    return txt
end

-- Dynamic real-time updating text using DCS element parameter
function addDynamicText(name, formatStr, paramName, pos, align, font, stringdefs)
    local txt           = CreateElement "ceStringPoly"
    txt.name            = name
    txt.material        = font or fontWhite
    txt.alignment       = align or "LeftCenter"
    txt.stringdefs      = stringdefs or {0.0017, 0.0017, 0, 0}
    txt.use_mipfilter   = true
    txt.screenspace     = ScreenType.SCREENSPACE_TRUE
    txt.parent_element  = gcs_root.name
    pos = pos or {0, 0}
    txt.init_pos        = {pos[1], pos[2], 0}
    txt.h_clip_relation = h_clip_relations.NULL
    txt.level           = DEFAULT_LEVEL + 2
    txt.formats         = {formatStr, "%s"}
    txt.element_params  = {paramName}
    txt.controllers     = {
        {"text_using_parameter", 0, 0}
    }
    Add(txt)
    return txt
end

-- =====================================================================================
-- Tactical Sensor Screen (100% Solid MFD Display with Targeting Reticle)
-- =====================================================================================
function addSensorScreen(name, x, y, width, height)
    local hw = width / 2
    local hh = height / 2

    -- 1. Solid opaque black backing plate (100% SOLID, zero background bleed)
    local bg           = CreateElement "ceMeshPoly"
    bg.name            = name .. "_bg"
    bg.material        = matBlack
    bg.init_pos        = {x, y, 0}
    bg.screenspace     = ScreenType.SCREENSPACE_TRUE
    bg.use_mipfilter   = true
    bg.additive_alpha  = false
    bg.blend_mode      = blend_mode.IBM_REGULAR
    bg.h_clip_relation = h_clip_relations.NULL
    bg.level           = DEFAULT_LEVEL - 2
    bg.vertices        = {{-hw - 0.015, -hh - 0.015}, {hw + 0.015, -hh - 0.015}, {hw + 0.015, hh + 0.015}, {-hw - 0.015, hh + 0.015}}
    bg.indices         = {0, 1, 2, 0, 2, 3}
    AddElement(bg)

    -- 2. Live Targeting Sensor Video Feed ("mfd0" = Shkval / TGP camera, 100% SOLID)
    local tv           = CreateElement "ceTexPoly"
    tv.name            = name .. "_tv"
    tv.material        = matMfd0
    tv.init_pos        = {x, y, 0}
    tv.screenspace     = ScreenType.SCREENSPACE_TRUE
    tv.use_mipfilter   = true
    tv.additive_alpha  = false
    tv.blend_mode      = blend_mode.IBM_REGULAR
    tv.h_clip_relation = h_clip_relations.NULL
    tv.level           = DEFAULT_LEVEL - 1
    tv.vertices        = {{-hw, -hh}, {hw, -hh}, {hw, hh}, {-hw, hh}}
    tv.indices         = {0, 1, 2, 0, 2, 3}
    tv.tex_coords      = {{0, 1}, {1, 1}, {1, 0}, {0, 0}}
    AddElement(tv)

    -- 3. Outer tactical border
    local border           = CreateElement "ceSMultiLine"
    border.name            = name .. "_border"
    border.material        = matGreen
    border.init_pos        = {x, y, 0}
    border.screenspace     = ScreenType.SCREENSPACE_TRUE
    border.use_mipfilter   = true
    border.additive_alpha  = false
    border.blend_mode      = blend_mode.IBM_REGULAR
    border.h_clip_relation = h_clip_relations.NULL
    border.level           = DEFAULT_LEVEL
    border.vertices        = {{-hw, -hh}, {hw, -hh}, {hw, hh}, {-hw, hh}, {-hw, -hh}}
    border.indices         = {0, 1, 1, 2, 2, 3, 3, 4}
    border.thickness       = 4.0
    AddElement(border)

    -- 4. Military corner brackets
    local cLen = 0.08
    local corners = {
        {{-hw, -hh + cLen}, {-hw, -hh}, {-hw + cLen, -hh}},
        {{ hw - cLen, -hh}, { hw, -hh}, { hw, -hh + cLen}},
        {{ hw,  hh - cLen}, { hw,  hh}, { hw - cLen,  hh}},
        {{-hw + cLen,  hh}, {-hw,  hh}, {-hw,  hh - cLen}},
    }
    for ci, cverts in ipairs(corners) do
        local cAcc           = CreateElement "ceSMultiLine"
        cAcc.name            = name .. "_c" .. ci
        cAcc.material        = matCyan
        cAcc.init_pos        = {x, y, 0}
        cAcc.screenspace     = ScreenType.SCREENSPACE_TRUE
        cAcc.use_mipfilter   = true
        cAcc.additive_alpha  = false
        cAcc.blend_mode      = blend_mode.IBM_REGULAR
        cAcc.h_clip_relation = h_clip_relations.NULL
        cAcc.level           = DEFAULT_LEVEL + 1
        cAcc.vertices        = cverts
        cAcc.indices         = {0, 1, 1, 2}
        cAcc.thickness       = 4.5
        AddElement(cAcc)
    end

    -- 5. Crosshair reticle inside the sensor MFD window
    local retGap = 0.025
    local retArm = 0.110
    addDualLine(name .. "_ch_l", {x - retArm, y}, {x - retGap, y}, 2.4, matGreen)
    addDualLine(name .. "_ch_r", {x + retGap, y}, {x + retArm, y}, 2.4, matGreen)
    addDualLine(name .. "_ch_b", {x, y - retArm}, {x, y - retGap}, 2.4, matGreen)
    addDualLine(name .. "_ch_t", {x, y + retGap}, {x, y + retArm}, 2.4, matGreen)
    addDot(name .. "_pip", 0.0035, {x, y}, matGreen)

    -- 6. Tactical labels on sensor frame
    addStaticText(name .. "_lbl_tl", "MTS-B SENSOR [MFD]", {x - hw + 0.04, y + hh - 0.035}, "LeftCenter",  fontCyan,     {0.0015, 0.0015, 0, 0})
    addStaticText(name .. "_lbl_tr", "MAG: 23x",          {x + hw - 0.04, y + hh - 0.035}, "RightCenter", fontGreen,    {0.0015, 0.0015, 0, 0})
    addStaticText(name .. "_lbl_bl", "FOV: NARROW",       {x - hw + 0.04, y - hh + 0.035}, "LeftCenter",  fontGreenDim, {0.0015, 0.0015, 0, 0})
    addStaticText(name .. "_lbl_br", "SLAVED",            {x + hw - 0.04, y - hh + 0.035}, "RightCenter", fontAmber,    {0.0015, 0.0015, 0, 0})
end
