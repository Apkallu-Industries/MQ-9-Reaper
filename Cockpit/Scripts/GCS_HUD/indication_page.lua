dofile(LockOn_Options.script_path .. "GCS_HUD/definitions.lua")

-- =====================================================================================
-- 1. PRECISION CENTER TARGETING RETICLE (100% UNOBSTRUCTED TARGET VIEW)
-- =====================================================================================
addDot("center_pip_bg", 0.0038, {0, 0}, matShadow)
addDot("center_pip_fg", 0.0020, {0, 0}, matGreen)

local gap       = 0.025
local armLength = 0.160

-- Crosshair 4-arms with central gap
addDualLine("cross_h_left",  {-armLength, 0}, {-gap, 0}, 2.2, matGreen)
addDualLine("cross_h_right", {gap, 0}, {armLength, 0}, 2.2, matGreen)
addDualLine("cross_v_bottom", {0, -armLength}, {0, -gap}, 2.2, matGreen)
addDualLine("cross_v_top",    {0, gap}, {0, armLength}, 2.2, matGreen)

-- Stadia graduation tick marks
local tickDistances = {0.060, 0.100, 0.140}
local tickHalf = 0.007

for i, d in ipairs(tickDistances) do
    addDualLine("tick_hl_" .. i, {-d, -tickHalf}, {-d, tickHalf}, 1.8, matGreen)
    addDualLine("tick_hr_" .. i, { d, -tickHalf}, { d, tickHalf}, 1.8, matGreen)
    addDualLine("tick_vb_" .. i, {-tickHalf, -d}, {tickHalf, -d}, 1.8, matGreen)
    addDualLine("tick_vt_" .. i, {-tickHalf,  d}, {tickHalf,  d}, 1.8, matGreen)
end

-- Target Acquisition Tracking Gate ([   ])
local bX   = 0.045
local bY   = 0.045
local bLen = 0.014

addDualCorner("bracket_top_left",     -bX,  bY,  1, -1, bLen, 2.2, matGreen)
addDualCorner("bracket_top_right",     bX,  bY, -1, -1, bLen, 2.2, matGreen)
addDualCorner("bracket_bottom_left",  -bX, -bY,  1,  1, bLen, 2.2, matGreen)
addDualCorner("bracket_bottom_right",  bX, -bY, -1,  1, bLen, 2.2, matGreen)

-- =====================================================================================
-- 2. TOP-CENTER DYNAMIC COMPASS HEADING BAR (UPDATING REAL-TIME FROM DCS)
-- =====================================================================================
local compBoxW = 0.58
local compBoxH = 0.12
local compY    = 0.90

addBackgroundBox("panel_compass", 0.0, compY, compBoxW, compBoxH)

-- Center pointing caret (^)
addDualLine("hdg_caret_l", {-0.016, compY - 0.034}, {0, compY - 0.016}, 2.4, matCyan)
addDualLine("hdg_caret_r", { 0.016, compY - 0.034}, {0, compY - 0.016}, 2.4, matCyan)

-- Dynamic heading value readout
addDynamicText("dyn_hdg_top", "COMPASS: %03.0f°", "CURRENT_HDG", {0.0, compY + 0.012}, "CenterCenter", fontCyan, {0.0020, 0.0020, 0, 0})

-- =====================================================================================
-- 3. TOP-LEFT PANEL: REAL-TIME FLIGHT TELEMETRY & ALTITUDE (100% HIGH CONTRAST)
-- =====================================================================================
local pW = 1.12
local pH = 0.32
local tlX = -1.08
local tlY =  0.77

addBackgroundBox("panel_tl", tlX, tlY, pW, pH)

local txtL = tlX - (pW / 2) + 0.060
addStaticText("txt_title",  "MQ-9 REAPER MTS-B SENSOR", {txtL, tlY + 0.090}, "LeftCenter", fontCyan,  {0.0016, 0.0016, 0, 0})
addDynamicText("dyn_alt",   "ALT : %5.0f FT MSL", "CURRENT_ALT",  {txtL, tlY + 0.030}, "LeftCenter", fontWhite, {0.0018, 0.0018, 0, 0})
addDynamicText("dyn_ralt",  "RALT: %5.0f FT AGL", "CURRENT_RALT", {txtL, tlY - 0.030}, "LeftCenter", fontWhite, {0.0018, 0.0018, 0, 0})
addDynamicText("dyn_ias",   "SPD : %3.0f KT IAS", "CURRENT_IAS",  {txtL, tlY - 0.090}, "LeftCenter", fontGreen, {0.0018, 0.0018, 0, 0})

-- =====================================================================================
-- 4. TOP-RIGHT PANEL: SENSOR STATUS & TARGETING TELEMETRY
-- =====================================================================================
local trX =  1.08
local trY =  0.77

addBackgroundBox("panel_tr", trX, trY, pW, pH)

local txtR = trX - (pW / 2) + 0.060
addStaticText("txt_laser",  "LASER: 1688 PRF [ARMED]",   {txtR, trY + 0.090}, "LeftCenter", fontAmber, {0.0016, 0.0016, 0, 0})
addDynamicText("dyn_hdg_r", "HDG  : %03.0f° MAGNETIC", "CURRENT_HDG", {txtR, trY + 0.030}, "LeftCenter", fontWhite, {0.0018, 0.0018, 0, 0})
addStaticText("txt_mode",   "MODE : GROUND DESIGNATE",   {txtR, trY - 0.030}, "LeftCenter", fontGreen, {0.0015, 0.0015, 0, 0})
addStaticText("txt_optic",  "OPTIC: 23x EO / FLIR MWIR", {txtR, trY - 0.090}, "LeftCenter", fontGreen, {0.0015, 0.0015, 0, 0})

-- =====================================================================================
-- 5. BOTTOM-LEFT PANEL: OPERATOR CONTROLS (RIGHT THUMBSTICK & HOTAS GUIDE)
-- =====================================================================================
local blX = -1.08
local blY = -0.77

addBackgroundBox("panel_bl", blX, blY, pW, pH)

local txtBL = blX - (pW / 2) + 0.060
addStaticText("txt_ctrl1", "R-STICK : GIMBAL CAMERA SLEW",      {txtBL, blY + 0.090}, "LeftCenter", fontCyan,  {0.0015, 0.0015, 0, 0})
addStaticText("txt_ctrl2", "RS CLICK: RECENTER / FLIGHT SEAT", {txtBL, blY + 0.030}, "LeftCenter", fontWhite, {0.0014, 0.0014, 0, 0})
addStaticText("txt_ctrl3", "RMB / X : MARK TARGET / LOCK",     {txtBL, blY - 0.030}, "LeftCenter", fontWhite, {0.0014, 0.0014, 0, 0})
addStaticText("txt_ctrl4", "LMB / A : WEAPON RELEASE (FIRE)",  {txtBL, blY - 0.090}, "LeftCenter", fontAmber, {0.0014, 0.0014, 0, 0})

-- =====================================================================================
-- 6. BOTTOM-RIGHT PANEL: WEAPON STATUS & DATALINK
-- =====================================================================================
local brX =  1.08
local brY = -0.77

addBackgroundBox("panel_br", brX, brY, pW, pH)

local txtBR = brX - (pW / 2) + 0.060
addStaticText("txt_wpn1",  "WPN   : AGM-114K HELLFIRE",   {txtBR, brY + 0.090}, "LeftCenter", fontAmber, {0.0015, 0.0015, 0, 0})
addStaticText("txt_wpn2",  "STATUS: READY TO FIRE",       {txtBR, brY + 0.030}, "LeftCenter", fontGreen, {0.0015, 0.0015, 0, 0})
addStaticText("txt_wpn3",  "DLINK : LINK-16 / ROVER VDL", {txtBR, brY - 0.030}, "LeftCenter", fontCyan,  {0.0014, 0.0014, 0, 0})
addStaticText("txt_wpn4",  "NAV   : GPS / INS NORMAL",    {txtBR, brY - 0.090}, "LeftCenter", fontGreen, {0.0014, 0.0014, 0, 0})
