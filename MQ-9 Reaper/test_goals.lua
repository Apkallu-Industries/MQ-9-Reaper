
local env = {}
local f = loadfile("temp_range.lua")
setfenv(f, env)
f()

local function dump(tbl, indent)
    indent = indent or 0
    for k, v in pairs(tbl) do
        local prefix = string.rep("  ", indent) .. tostring(k) .. ": "
        if type(v) == "table" then
            print(prefix .. "{")
            dump(v, indent + 1)
            print(string.rep("  ", indent) .. "}")
        else
            print(prefix .. tostring(v))
        end
    end
end

print("=== GOALS ===")
dump(env.mission.goals)
print("=== TRIGRULES ===")
dump(env.mission.trigrules)
