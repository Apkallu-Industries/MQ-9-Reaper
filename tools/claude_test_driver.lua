-- [CLAUDE_TEST] driver: AI-flown smoke test for a BNS aircraft mod.
-- Loaded by a mission-start trigger. CLAUDE_TEST_CFG is defined by the trigger before this file runs:
--   { group = "<group name>", type = "<unit type>", alt_min = m, alt_max = m, spd_min = m/s, spd_max = m/s,
--     t_check = s, t_end = s, min_travel = m }
-- Every result is one dcs.log line: "[CLAUDE_TEST] PASS <name> <detail>" or "[CLAUDE_TEST] FAIL <name> <detail>",
-- then "[CLAUDE_TEST] SUMMARY <pass> PASS <fail> FAIL" and "[CLAUDE_TEST] DONE".
-- DCS SSE only (Lua 5.1): Group:getUnits()[1], not Group:getUnit (registry #9).

local C = CLAUDE_TEST_CFG or {}
local R = { pass = 0, fail = 0, done = false }
local start_pos = nil

local function log(ok, name, detail)
  if ok then R.pass = R.pass + 1 else R.fail = R.fail + 1 end
  local line = string.format("[CLAUDE_TEST] %s %s %s", ok and "PASS" or "FAIL", name, detail or "")
  env.info(line)
  trigger.action.outText(line, 15)
end

local function unit_of()
  local g = Group.getByName(C.group)
  if not g then return nil end
  local us = g:getUnits()
  if not us or not us[1] or not us[1]:isExist() then return nil end
  return us[1]
end

local function speed(u)
  local v = u:getVelocity()
  return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
end

local function finish()
  if R.done then return end
  R.done = true
  env.info(string.format("[CLAUDE_TEST] SUMMARY %d PASS %d FAIL", R.pass, R.fail))
  env.info("[CLAUDE_TEST] DONE")
  trigger.action.outText(string.format("[CLAUDE_TEST] SUMMARY %d PASS %d FAIL", R.pass, R.fail), 60)
end

local H = {}
function H:onEvent(e)
  if R.done or not e or not e.initiator then return end
  local ok, name = pcall(function() return e.initiator:getName() end)
  if not ok or not name then return end
  local u = unit_of()
  local mine = u and name == u:getName()
  if not mine and e.initiator.getGroup then
    local okg, g = pcall(function() return e.initiator:getGroup() end)
    mine = okg and g and g:getName() == C.group
  end
  if not mine then return end
  if e.id == world.event.S_EVENT_CRASH or e.id == world.event.S_EVENT_DEAD
     or e.id == world.event.S_EVENT_EJECTION or e.id == world.event.S_EVENT_PILOT_DEAD then
    log(false, "survives", "event " .. tostring(e.id) .. " at t=" .. string.format("%.0f", timer.getTime()))
    finish()
  end
end
world.addEventHandler(H)

local function t_spawn()
  local u = unit_of()
  log(u ~= nil, "spawn", "group " .. tostring(C.group))
  if not u then finish() return nil end
  log(u:getTypeName() == C.type, "type", "got " .. tostring(u:getTypeName()) .. " want " .. tostring(C.type))
  local d = u:getDesc()
  log(d ~= nil and d.category == Unit.Category.AIRPLANE, "category", "desc.category " .. tostring(d and d.category))
  log((u:getFuel() or 0) > 0, "fuel", string.format("%.2f", u:getFuel() or -1))
  start_pos = u:getPoint()
  return nil
end

local function t_check()
  if R.done then return nil end
  local u = unit_of()
  if not u then log(false, "alive_at_check", "unit gone") finish() return nil end
  local p = u:getPoint()
  local s = speed(u)
  log(p.y >= C.alt_min and p.y <= C.alt_max, "altitude",
      string.format("%.0f m (band %d..%d)", p.y, C.alt_min, C.alt_max))
  log(s >= C.spd_min and s <= C.spd_max, "speed",
      string.format("%.1f m/s (band %d..%d)", s, C.spd_min, C.spd_max))
  log(u:inAir(), "in_air", "")
  return nil
end

local function t_end()
  if R.done then return nil end
  local u = unit_of()
  if not u then log(false, "alive_at_end", "unit gone") finish() return nil end
  local p = u:getPoint()
  local dx, dz = p.x - (start_pos and start_pos.x or p.x), p.z - (start_pos and start_pos.z or p.z)
  local dist = math.sqrt(dx * dx + dz * dz)
  log(true, "alive_at_end", string.format("t=%.0f", timer.getTime()))
  log(dist >= C.min_travel, "follows_route", string.format("%.0f m travelled (min %d)", dist, C.min_travel))
  finish()
  return nil
end

env.info("[CLAUDE_TEST] START " .. tostring(C.type) .. " group " .. tostring(C.group))
timer.scheduleFunction(t_spawn, nil, timer.getTime() + 2)
timer.scheduleFunction(t_check, nil, timer.getTime() + (C.t_check or 60))
timer.scheduleFunction(t_end, nil, timer.getTime() + (C.t_end or 600))
