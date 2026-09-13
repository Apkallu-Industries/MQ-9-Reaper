dofile(LockOn_Options.script_path .. "GCS_HUD/definitions.lua")

-- =====================================================================================
-- 1. PRECISION CENTER AIMING PIP (GROUND POINT DESIGNATOR)
-- =====================================================================================
addDot("center_pip_bg", 0.0035, {0, 0}, matShadow)
addDot("center_pip_fg", 0.0018, {0, 0}, matGreen)

-- =====================================================================================
-- 2. 4-ARM CROSSHAIR WITH CENTER TARGETING GAP
-- Gap from -0.024 to +0.024 ensures target point on the ground is never hidden by lines.
-- =====================================================================================
local gap = 0.024
local armLength = 0.160

-- Horizontal arms
addDualLine("cross_h_left",  {-armLength, 0}, {-gap, 0}, 2.0)
addDualLine("cross_h_right", {gap, 0}, {armLength, 0}, 2.0)

-- Vertical arms
addDualLine("cross_v_bottom", {0, -armLength}, {0, -gap}, 2.0)
addDualLine("cross_v_top",    {0, gap}, {0, armLength}, 2.0)

-- Stadia graduation tick marks along crosshairs
local tickDistances = {0.060, 0.100, 0.140}
local tickHalf = 0.006

for i, d in ipairs(tickDistances) do
    -- Horizontal arm ticks (vertical lines)
    addDualLine("tick_hl_" .. i, {-d, -tickHalf}, {-d, tickHalf}, 1.6)
    addDualLine("tick_hr_" .. i, { d, -tickHalf}, { d, tickHalf}, 1.6)

    -- Vertical arm ticks (horizontal lines)
    addDualLine("tick_vb_" .. i, {-tickHalf, -d}, {tickHalf, -d}, 1.6)
    addDualLine("tick_vt_" .. i, {-tickHalf,  d}, {tickHalf,  d}, 1.6)
end

-- =====================================================================================
-- 3. TARGET ACQUISITION CORNER BRACKETS (TRACKING GATE: [   ])
-- =====================================================================================
local bX = 0.040
local bY = 0.040
local bLen = 0.012

addDualCorner("bracket_top_left",     -bX,  bY,  1, -1, bLen, 2.0)
addDualCorner("bracket_top_right",     bX,  bY, -1, -1, bLen, 2.0)
addDualCorner("bracket_bottom_left",  -bX, -bY,  1,  1, bLen, 2.0)
addDualCorner("bracket_bottom_right",  bX, -bY, -1,  1, bLen, 2.0)

-- =====================================================================================
-- 4. OUTER SENSOR FOV CIRCULAR RETICLE (4 QUADRANT ARCS)
-- =====================================================================================
local ringRadius = 0.28
addDualArc("ring_q1", ringRadius,  15, 60, 1.8, 16)
addDualArc("ring_q2", ringRadius, 105, 60, 1.8, 16)
addDualArc("ring_q3", ringRadius, 195, 60, 1.8, 16)
addDualArc("ring_q4", ringRadius, 285, 60, 1.8, 16)

-- Inward cardinal alignment pointers at 12, 3, 6, 9 o'clock
addDualLine("cardinal_top",    {0, ringRadius + 0.016}, {0, ringRadius - 0.008}, 2.2)
addDualLine("cardinal_bottom", {0, -ringRadius - 0.016}, {0, -ringRadius + 0.008}, 2.2)
addDualLine("cardinal_left",   {-ringRadius - 0.016, 0}, {-ringRadius + 0.008, 0}, 2.2)
addDualLine("cardinal_right",  {ringRadius + 0.016, 0}, {ringRadius - 0.008, 0}, 2.2)

-- =====================================================================================
-- 5. GIMBAL AZIMUTH COMPASS TAPE (TOP OF HUD)
-- =====================================================================================
local azY = 0.88
local azHalfW = 0.35

addDualLine("az_bar", {-azHalfW, azY}, {azHalfW, azY}, 1.8)

-- Center indicator caret (V)
addDualLine("az_caret_l", {-0.010, azY + 0.014}, {0, azY}, 2.0)
addDualLine("az_caret_r", { 0.010, azY + 0.014}, {0, azY}, 2.0)

-- Azimuth graduation ticks
local azTicks = {-0.30, -0.20, -0.10, 0.10, 0.20, 0.30}
for i, tx in ipairs(azTicks) do
    addDualLine("az_tick_" .. i, {tx, azY}, {tx, azY - 0.010}, 1.6)
end

addText("txt_az_val", "AZ  000°", {0, azY + 0.030}, "CenterCenter", fontHUD, {0.0016, 0.0016, 0, 0})
addText("txt_compass", "360° SENSOR COMPASS", {0, azY - 0.025}, "CenterCenter", fontHUDDim, {0.0011, 0.0011, 0, 0})

-- =====================================================================================
-- 6. GIMBAL DEPRESSION / ELEVATION LADDER (RIGHT SIDE)
-- =====================================================================================
local elX = 0.36
local elTopY = 0.15
local elBotY = -0.65

addDualLine("el_bar", {elX, elTopY}, {elX, elBotY}, 1.8)

local elRungs = {
    {y =  0.08, label = "+10"},
    {y =  0.00, label = "  0 (HORIZON)"},
    {y = -0.12, label = "-15"},
    {y = -0.24, label = "-30"},
    {y = -0.36, label = "-45"},
    {y = -0.48, label = "-60"},
    {y = -0.60, label = "-90 (NADIR)"},
}

for i, rung in ipairs(elRungs) do
    addDualLine("el_rung_" .. i, {elX, rung.y}, {elX + 0.016, rung.y}, 1.6)
    addText("el_lbl_" .. i, rung.label, {elX + 0.022, rung.y}, "LeftCenter", fontHUDDim, {0.0011, 0.0011, 0, 0})
end

-- Dynamic depression pointer (<) responding to GIMBAL_ELEVATION
local function addMovingPointer(name, baseX, baseY)
    local ptrTop = CreateElement "ceSMultiLine"
    ptrTop.name = name .. "_top"
    ptrTop.material = matGreen
    ptrTop.vertices = {{-0.014, 0.009}, {0, 0}}
    ptrTop.indices = {0, 1}
    ptrTop.thickness = 2.0
    ptrTop.init_pos = {baseX, baseY, 0}
    ptrTop.element_params = {"GIMBAL_ACTIVE", "GIMBAL_ELEVATION"}
    ptrTop.controllers = {
        {"parameter_in_range", 0, 0.9, 1.1},
        {"move_up_down_using_parameter", 1, 0.0068}
    }
    AddElement(ptrTop)

    local ptrBot = CreateElement "ceSMultiLine"
    ptrBot.name = name .. "_bot"
    ptrBot.material = matGreen
    ptrBot.vertices = {{-0.014, -0.009}, {0, 0}}
    ptrBot.indices = {0, 1}
    ptrBot.thickness = 2.0
    ptrBot.init_pos = {baseX, baseY, 0}
    ptrBot.element_params = {"GIMBAL_ACTIVE", "GIMBAL_ELEVATION"}
    ptrBot.controllers = {
        {"parameter_in_range", 0, 0.9, 1.1},
        {"move_up_down_using_parameter", 1, 0.0068}
    }
    AddElement(ptrBot)
end

addMovingPointer("el_dyn_ptr", elX, 0.0)

-- =====================================================================================
-- 7. TACTICAL TELEMETRY & TARGET MARKING HUD READOUTS (CLEAN CORNERS)
-- Note: Bulky center banners were removed to ensure 100% unobstructed target view.
-- =====================================================================
local cornerX = 0.75
local topY = 0.88
local dY = 0.032

-- Top-Left Sensor Telemetry
addText("txt_title",  "MQ-9 REAPER MTS-B SENSOR", {-cornerX, topY},          "LeftCenter", fontHUD,    {0.0014, 0.0014, 0, 0})
addText("txt_optics", "OPTIC : 23x OPTICAL ZOOM",  {-cornerX, topY - dY},     "LeftCenter", fontHUDDim, {0.0012, 0.0012, 0, 0})
addText("txt_stab",   "STAB  : 3-AXIS GYRO LOCK",  {-cornerX, topY - (dY*2)}, "LeftCenter", fontHUDDim, {0.0012, 0.0012, 0, 0})

-- Top-Right Laser & Mode Telemetry
addText("txt_laser",  "LASER: 1688 PRF [ARMED]",   { cornerX, topY},          "RightCenter", fontHUD,    {0.0014, 0.0014, 0, 0})
addText("txt_mode",   "MODE : GROUND DESIGNATE",   { cornerX, topY - dY},     "RightCenter", fontHUDDim, {0.0012, 0.0012, 0, 0})
addText("txt_fov",    "FOV  : 4.8° NFOV",          { cornerX, topY - (dY*2)}, "RightCenter", fontHUDDim, {0.0012, 0.0012, 0, 0})

-- Bottom-Left Controls & Datalink
local botY = -0.80
addText("txt_rmb",    "RMB   : MARK TARGET / LOCK", {-cornerX, botY + (dY*2)}, "LeftCenter", fontHUD,    {0.0013, 0.0013, 0, 0})
addText("txt_lmb",    "LMB   : WEAPON RELEASE",     {-cornerX, botY + dY},     "LeftCenter", fontHUDDim, {0.0012, 0.0012, 0, 0})
addText("txt_dlink",  "DLINK : LINK-16 / ROVER VDL",{-cornerX, botY},          "LeftCenter", fontHUDDim, {0.0012, 0.0012, 0, 0})

-- Bottom-Right Weapons & Operator Guide
addText("txt_wpn",    "WPN   : AGM-114K HELLFIRE",  { cornerX, botY + (dY*2)}, "RightCenter", fontHUD,    {0.0013, 0.0013, 0, 0})
addText("txt_ord",    "STATUS: READY TO FIRE",      { cornerX, botY + dY},     "RightCenter", fontHUDDim, {0.0012, 0.0012, 0, 0})
addText("txt_guide",  "D-PAD : SLEW | F1: FLIGHT",  { cornerX, botY},          "RightCenter", fontHUDDim, {0.0012, 0.0012, 0, 0})
