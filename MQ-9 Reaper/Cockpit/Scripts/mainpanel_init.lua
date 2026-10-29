-- MQ-9A Reaper (BNS): main panel of a UAV flown from a Ground Control Station.
-- The real MQ-9A has no cockpit: the pilot and the sensor operator sit at GCS consoles and fly from the MTS-B sensor
-- picture. So the player view is the sensor view (Views.lua CockpitLocalPoint at the chin turret) plus the screen-space
-- GCS_HUD indicator; there is no cockpit geometry to draw.
-- DCS still loads one cockpit shape per flyable: BNS-AV-GCS-0001 (BNS library, sensor-view cockpit shape) is that shape,
-- a root node and the PNT_SENSOR_EYE connector only, no render geometry. It replaced the borrowed ED cockpit shell
-- (clean-room fix 2026-10-29). Pattern: support_for_cws + MainPanel + own shape_name, as the BNS Camel and A6M2 do.
shape_name = "BNS-AV-GCS-0001_DCS"
is_EDM = true
new_model_format = true

ambient_light    = { 255, 255, 255 }
ambient_color_day_texture   = { 255, 255, 255 }
ambient_color_night_texture = { 40, 60, 40 }
ambient_color_from_devices  = { 0, 0, 0 }
ambient_color_from_panels   = { 0, 0, 0 }
dusk_border = 0.4

draw_pilot  = false            -- nobody on board
use_external_views = false
cockpit_local_point = { 7.500, -1.050, 0.000 }   -- = Views.lua CockpitLocalPoint (MTS-B turret, under the nose)

day_texture_set_value   = 0.0
night_texture_set_value = 0.1
need_to_be_closed = true       -- the operator sits in a closed GCS shelter: no wind or rain on the view
