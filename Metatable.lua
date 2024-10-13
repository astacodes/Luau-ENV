local frozen = {}
local rTable = table
local table = {}

for i, v in pairs(rTable) do
    table[i] = v
end

getgenv().table.freeze = function(t)
    getgenv().setreadonly(t, true)
end

getgenv().table.isfrozen = function(t)
    return rTable.isfrozen(t) or frozen[t]
end

getgenv().table.freeze(table)
getgenv().table = table

getgenv().setreadonly = function(t, r)
    frozen[t] = r
    local newVals = {}
    setmetatable(t, {
        __index = function(self, name)
            return newVals[name] or t[name]
        end,
        __newindex = function(self, name, val)
            if frozen[name] then
                return error("Attempt to modify a readonly table")
            end
            newVals[name] = val
        end,
    })
end

getgenv().isreadonly = function(t)
    return getgenv().table.isfrozen(t)
end

