dofile(LockOn_Options.common_script_path .. "elements_defs.lua")

DEFAULT_LEVEL = 5

aspect = LockOn_Options.screen.aspect or (16 / 9)

HUD_GREEN     = {0, 255, 70, 240}
HUD_GREEN_DIM = {0, 200, 55, 180}
HUD_SHADOW    = {0, 0, 0, 210}
HUD_WHITE     = {245, 250, 255, 240}

matGreen    = MakeMaterial(nil, HUD_GREEN)
matGreenDim = MakeMaterial(nil, HUD_GREEN_DIM)
matShadow   = MakeMaterial(nil, HUD_SHADOW)
matWhite    = MakeMaterial(nil, HUD_WHITE)

fontHUD     = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22_white"}, HUD_GREEN, "fontHUD")
fontHUDDim  = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22_white"}, HUD_GREEN_DIM, "fontHUDDim")
fontWhite   = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22_white"}, HUD_WHITE, "fontWhite")

function AddElement(object)
    object.screenspace = ScreenType.SCREENSPACE_TRUE
    object.use_mipfilter = true
    if not object.element_params then
        object.element_params = {"GIMBAL_ACTIVE"}
        object.controllers    = {{"parameter_in_range", 0, 0.9, 1.1}}
    end
    Add(object)
end

function addDot(name, radius, pos, mat)
    local dot           = CreateElement "ceMeshPoly"
    dot.name            = name
    dot.material        = mat or matGreen
    pos = pos or {0, 0}
    dot.init_pos        = {pos[1], pos[2], 0}
    dot.h_clip_relation = h_clip_relations.COMPARE
    dot.level           = DEFAULT_LEVEL
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
    line.h_clip_relation = h_clip_relations.COMPARE
    line.level           = DEFAULT_LEVEL
    line.vertices        = {p1, p2}
    line.indices         = {0, 1}
    line.thickness       = thickness or 2.0
    line.fuzziness       = 0.8
    AddElement(line)
    return line
end

-- Dual-layer line: dark shadow backing behind sharp HUD green foreground
function addDualLine(name, p1, p2, thickness)
    thickness = thickness or 2.2
    addLineSegment(name .. "_bg", p1, p2, matShadow, thickness + 2.2)
    addLineSegment(name .. "_fg", p1, p2, matGreen, thickness)
end

function addDualCorner(name, cx, cy, dirX, dirY, size, thickness)
    -- Horizontal leg
    local h1 = {cx, cy}
    local h2 = {cx + dirX * size, cy}
    addDualLine(name .. "_h", h1, h2, thickness)
    -- Vertical leg
    local v1 = {cx, cy}
    local v2 = {cx, cy + dirY * size}
    addDualLine(name .. "_v", v1, v2, thickness)
end

function addDualArc(name, radius, startDeg, sweepDeg, thickness, sides)
    sides = sides or 16
    local delta = math.rad(sweepDeg / sides)
    local startRad = math.rad(startDeg)
    local verts = {}
    local inds = {}
    for i = 0, sides do
        local a = startRad + delta * i
        verts[#verts + 1] = {radius * math.cos(a), radius * math.sin(a)}
        if i < sides then
            inds[#inds + 1] = i
            inds[#inds + 1] = i + 1
        end
    end

    local function makeArcPoly(suf, mat, thick)
        local arc           = CreateElement "ceSMultiLine"
        arc.name            = name .. suf
        arc.material        = mat
        arc.init_pos        = {0, 0, 0}
        arc.h_clip_relation = h_clip_relations.COMPARE
        arc.level           = DEFAULT_LEVEL
        arc.vertices        = verts
        arc.indices         = inds
        arc.thickness       = thick
        arc.fuzziness       = 0.8
        AddElement(arc)
    end

    thickness = thickness or 2.0
    makeArcPoly("_bg", matShadow, thickness + 2.0)
    makeArcPoly("_fg", matGreen, thickness)
end

function addText(name, text, pos, align, font, stringdefs)
    local txt           = CreateElement "ceStringPoly"
    txt.name            = name
    txt.material        = font or fontHUD
    txt.alignment       = align or "CenterCenter"
    txt.stringdefs      = stringdefs or {0.0014, 0.0014, 0, 0}
    txt.use_mipfilter   = true
    pos = pos or {0, 0}
    txt.init_pos        = {pos[1], pos[2], 0}
    txt.h_clip_relation = h_clip_relations.COMPARE
    txt.level           = DEFAULT_LEVEL
    txt.value           = text or ""
    AddElement(txt)
    return txt
end
