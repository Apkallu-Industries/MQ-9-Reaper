
local env = {}
local f = loadfile("temp_range.lua")
setfenv(f, env)
f()

local function serialize(tbl, indent)
    indent = indent or ""
    local out = "{\n"
    for k, v in pairs(tbl) do
        local keyStr = type(k) == "number" and ("[" .. k .. "]") or ("[" .. string.format("%q", k) .. "]")
        if type(v) == "table" then
            out = out .. indent .. "  " .. keyStr .. " = " .. serialize(v, indent .. "  ") .. ",\n"
        elseif type(v) == "string" then
            out = out .. indent .. "  " .. keyStr .. " = " .. string.format("%q", v) .. ",\n"
        else
            out = out .. indent .. "  " .. keyStr .. " = " .. tostring(v) .. ",\n"
        end
    end
    out = out .. indent .. "}"
    return out
end

print(serialize(env.mission.weather))
