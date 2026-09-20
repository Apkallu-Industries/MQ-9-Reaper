dofile(LockOn_Options.script_path .. "GCS_HUD/definitions.lua")

-- =====================================================================================
-- DYNAMIC CORNER ANCHORS (MAXIMIZES SCREEN REAL ESTATE FOR 16:9, 21:9, & 32:9 MONITORS)
-- =====================================================================================
local marginX = 0.06
local marginY = 0.05

-- Top-Left Telemetry Panel
local tlW = 1.14
local tlH = 0.32
local tlX = -aspect + (tlW / 2) + marginX
local tlY =  1.0 - (tlH / 2) - marginY

-- Top-Right Sensor Status Panel
local trW = 1.14
local trH = 0.32
local trX =  aspect - (trW / 2) - marginX
local trY =  1.0 - (trH / 2) - marginY

-- Top-Center Compass Tape
local compBoxW = 0.58
local compBoxH = 0.12
local compY    = 1.0 - (compBoxH / 2) - 0.04

-- Bottom-Left Enlarged Sensor Camera MFD Display (Solid Opaque, Sized Up ~45%)
local mfdW = 1.36
local mfdH = 1.02
local mfdX = -aspect + (mfdW / 2) + marginX
local mfdY = -1.0 + (mfdH / 2) + marginY

-- Bottom-Right Weapon Status & HOTAS Controls Panel
local brW  = 1.16
local brH  = 0.38
local brX  =  aspect - (brW / 2) - marginX
local brY  = -1.0 + (brH / 2) + marginY

-- =====================================================================================
-- 0. TACTICAL TARGETING SENSOR DISPLAY (BOTTOM-LEFT CORNER 100% SOLID OPAQUE MFD)
-- =====================================================================================
addSensorScreen("gimbal_sensor_mfd", mfdX, mfdY, mfdW, mfdH)

-- =====================================================================================
-- 1. TOP-CENTER DYNAMIC COMPASS HEADING BAR (UPDATING REAL-TIME FROM DCS)
-- =====================================================================================
addBackgroundBox("panel_compass", 0.0, compY, compBoxW, compBoxH)

-- Center pointing caret (^)
addDualLine("hdg_caret_l", {-0.016, compY - 0.034}, {0, compY - 0.016}, 2.4, matCyan)
addDualLine("hdg_caret_r", { 0.016, compY - 0.034}, {0, compY - 0.016}, 2.4, matCyan)

-- Dynamic heading value readout
addDynamicText("dyn_hdg_top", "COMPASS: %03.0f°", "CURRENT_HDG", {0.0, compY + 0.012}, "CenterCenter", fontCyan, {0.0020, 0.0020, 0, 0})

-- =====================================================================================
-- 2. TOP-LEFT PANEL: REAL-TIME FLIGHT TELEMETRY & ALTITUDE (TOP-LEFT CORNER)
-- =====================================================================================
addBackgroundBox("panel_tl", tlX, tlY, tlW, tlH)

local txtL = tlX - (tlW / 2) + 0.060
addStaticText("txt_title",  "MQ-9 REAPER MTS-B SENSOR", {txtL, tlY + 0.090}, "LeftCenter", fontCyan,  {0.0016, 0.0016, 0, 0})
addDynamicText("dyn_alt",   "ALT : %5.0f FT MSL", "CURRENT_ALT",  {txtL, tlY + 0.030}, "LeftCenter", fontWhite, {0.0018, 0.0018, 0, 0})
addDynamicText("dyn_ralt",  "RALT: %5.0f FT AGL", "CURRENT_RALT", {txtL, tlY - 0.030}, "LeftCenter", fontWhite, {0.0018, 0.0018, 0, 0})
addDynamicText("dyn_ias",   "SPD : %3.0f KT IAS", "CURRENT_IAS",  {txtL, tlY - 0.090}, "LeftCenter", fontGreen, {0.0018, 0.0018, 0, 0})

-- =====================================================================================
-- 3. TOP-RIGHT PANEL: SENSOR STATUS & TARGETING TELEMETRY (TOP-RIGHT CORNER)
-- =====================================================================================
addBackgroundBox("panel_tr", trX, trY, trW, trH)

local txtR = trX - (trW / 2) + 0.060
addStaticText("txt_laser",  "LASER: 1688 PRF [ARMED]",   {txtR, trY + 0.090}, "LeftCenter", fontAmber, {0.0016, 0.0016, 0, 0})
addDynamicText("dyn_hdg_r", "HDG  : %03.0f° MAGNETIC", "CURRENT_HDG", {txtR, trY + 0.030}, "LeftCenter", fontWhite, {0.0018, 0.0018, 0, 0})
addStaticText("txt_mode",   "MODE : GROUND DESIGNATE",   {txtR, trY - 0.030}, "LeftCenter", fontGreen, {0.0015, 0.0015, 0, 0})
addStaticText("txt_optic",  "OPTIC: 23x EO / FLIR MWIR", {txtR, trY - 0.090}, "LeftCenter", fontGreen, {0.0015, 0.0015, 0, 0})

-- =====================================================================================
-- 4. BOTTOM-RIGHT PANEL: WEAPON STATUS & HOTAS OPERATOR CONTROLS (BOTTOM-RIGHT CORNER)
-- =====================================================================================
addBackgroundBox("panel_br", brX, brY, brW, brH)

local txtBR = brX - (brW / 2) + 0.060
addStaticText("txt_wpn1",  "WPN    : AGM-114K HELLFIRE [RDY]",   {txtBR, brY + 0.110}, "LeftCenter", fontAmber, {0.0015, 0.0015, 0, 0})
addStaticText("txt_wpn2",  "RS SLEW: SENSOR & HUD MARKER",        {txtBR, brY + 0.040}, "LeftCenter", fontCyan,  {0.0014, 0.0014, 0, 0})
addStaticText("txt_wpn3",  "D-PAD  : [▲] 23x IN / [▼] 1x WIDE",   {txtBR, brY - 0.030}, "LeftCenter", fontGreen, {0.0014, 0.0014, 0, 0})
addStaticText("txt_wpn4",  "LOCK   : [X] LOCK / [RS CLICK] UNLK", {txtBR, brY - 0.100}, "LeftCenter", fontWhite, {0.0014, 0.0014, 0, 0})
