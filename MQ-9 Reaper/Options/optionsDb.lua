local oms = require('optionsModsScripts')

local cpList = nil
if oms and oms.getCPLocalList then
    pcall(function()
        cpList = oms.getCPLocalList("Cockpit_Su-25T")
    end)
end

return {
    CPLocalList = cpList or "default",
}
