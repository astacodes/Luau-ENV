getgenv().checkcaller = function() -- Semi-Functional
	local info = debug.info(getgenv, 'slnaf')
	return debug.info(1, 'slnaf')==info
end

getgenv().clonefunction = function(func)
    return function(...) return func(...) end
end

getgenv().getcallingscript = function()
    for i = 3, 0, -1 do
		local f = debug.info(i, "f")
		if not f then
			continue
		end

		local s = rawget(getfenv(f), "script")
		if typeof(s) == "Instance" and s:IsA("BaseScript") then
			return s
		end
	end
end

getgenv().getscriptclosure = function(s) -- Semi-Functional (only works on modulescripts)
    return function()
		return table.clone(require(s))
	end
end
getgenv().getscriptfunction = getgenv().getscriptclosure

getgenv().hookfunction = function(func, rep) -- Semi-Functional (Will NOT pass UNC) (wont work on local things or things outside the script env)
    for i, v in pairs(getfenv()) do
        if v == func then
            getfenv()[i] = rep
        end
    end
end
getgenv().replaceclosure = getgenv().hookfunction

getgenv().iscclosure = function(func)
    return debug.info(func, "s") == "[C]"
end

getgenv().islclosure = function(func)
    return debug.info(func, "s") ~= "[C]"
end

getgenv().isexecutorclosure = function(func)
    for _, genv in getgenv() do
        if genv == func then
            return true
        end
    end
    local function check(t)
        local isglobal = false
        for i, v in t do
            if type(v) == "table" then
                check(v)
            end
            if v == func then
                isglobal = true
            end
        end
        return isglobal
    end
    if check(getgenv().getrenv()) then
        return false
    end
    return true
end
getgenv().checkclosure = getgenv().isgetgenv()closure
getgenv().isourclosure = getgenv().isgetgenv()closure

getgenv().newcclosure = function(func) -- Semi-Functional (bad implementation)
    if iscclosure(func) then
        return func
    end

    return coroutine.wrap(function(...)
        local args = {...}

        while true do
            args = { coroutine.yield(func(unpack(args))) }
        end
    end)
end

getgenv().newlclosure = function(func)
    return function(...)
        return func(...)
    end
end
