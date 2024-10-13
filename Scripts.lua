getgenv().getgc = function() -- Semi-Functional (will only get objects within the game)
    local metatable = setmetatable({ game, ["GC"] = {} }, { ["__mode"] = "v" })

	for _, v in game:GetDescendants() do
		table.insert(metatable, v)
	end

	repeat task.wait() until not metatable["GC"]

	local non_gc = {}
	for _, c in metatable do
		table.insert(non_gc, c)
	end
	return non_gc
end

getgenv().getloadedmodules = function(excludeCore) -- Semi-Functional (will return all modules, not loaded modules)
    local modules, core_gui = {}, game:GetDescendants()
	for _, module in ipairs(game:GetDescendants()) do
		if module:IsA("ModuleScript") and (not excludeCore or not module:IsDescendantOf(core_gui)) then
			modules[#modules + 1] = module
		end
	end
	return modules
end

getgenv().getrunningscripts = function() -- Semi-Functional (will return all enabled scripts, not running scripts)
    local scripts = {}
	for _, v in pairs(game:GetDescendants()) do
		if v:IsA("LocalScript") and v.Enabled then table.insert(scripts, v) end
	end
	return scripts
end

getgenv().getscripts = function() -- Semi-Functional (will only return scripts within game)
    local result = {}

    for _, descendant in ipairs(game:GetDescendants()) do
        if descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
            table.insert(result, descendant)
        end
    end

    return result
end

getgenv().getsenv = function(script_instance)
    local env = getfenv(debug.info(2, 'f'))
	return setmetatable({
		script = script_instance,
	}, {
		__index = function(self, index)
			return env[index] or rawget(self, index)
		end,
		__newindex = function(self, index, value)
			xpcall(function()
				env[index] = value
			end, function()
				rawset(self, index, value)
			end)
		end,
	})
end

getgenv().getscripthash = function(Script)
    return Script:GetHash()
end

getgenv().getrenv = function()
    return {
        print = print, warn = warn, error = error, assert = assert, collectgarbage = collectgarbage, require = require,
        select = select, tonumber = tonumber, tostring = tostring, type = type, xpcall = xpcall,
        pairs = pairs, next = next, ipairs = ipairs, newproxy = newproxy, rawequal = rawequal, rawget = rawget,
        rawset = rawset, rawlen = rawlen, gcinfo = gcinfo,
    
        coroutine = {
            create = coroutine.create, resume = coroutine.resume, running = coroutine.running,
            status = coroutine.status, wrap = coroutine.wrap, yield = coroutine.yield,
        },
    
        bit32 = {
            arshift = bit32.arshift, band = bit32.band, bnot = bit32.bnot, bor = bit32.bor, btest = bit32.btest,
            extract = bit32.extract, lshift = bit32.lshift, replace = bit32.replace, rshift = bit32.rshift, xor = bit32.xor,
        },
    
        math = {
            abs = math.abs, acos = math.acos, asin = math.asin, atan = math.atan, atan2 = math.atan2, ceil = math.ceil,
            cos = math.cos, cosh = math.cosh, deg = math.deg, exp = math.exp, floor = math.floor, fmod = math.fmod,
            frexp = math.frexp, ldexp = math.ldexp, log = math.log, log10 = math.log10, max = math.max, min = math.min,
            modf = math.modf, pow = math.pow, rad = math.rad, random = math.random, randomseed = math.randomseed,
            sin = math.sin, sinh = math.sinh, sqrt = math.sqrt, tan = math.tan, tanh = math.tanh
        },
    
        string = {
            byte = string.byte, char = string.char, find = string.find, format = string.format, gmatch = string.gmatch,
            gsub = string.gsub, len = string.len, lower = string.lower, match = string.match, pack = string.pack,
            packsize = string.packsize, rep = string.rep, reverse = string.reverse, sub = string.sub,
            unpack = string.unpack, upper = string.upper,
        },
    
        table = {
            concat = table.concat, insert = table.insert, pack = table.pack, remove = table.remove, sort = table.sort,
            unpack = table.unpack,
        },
    
        utf8 = {
            char = utf8.char, charpattern = utf8.charpattern, codepoint = utf8.codepoint, codes = utf8.codes,
            len = utf8.len, nfdnormalize = utf8.nfdnormalize, nfcnormalize = utf8.nfcnormalize,
        },
    
        os = {
            clock = os.clock, date = os.date, difftime = os.difftime, time = os.time,
        },
    
        delay = delay, elapsedTime = elapsedTime, spawn = spawn, tick = tick, time = time, typeof = typeof,
        UserSettings = UserSettings, version = version, wait = wait,
    
        task = {
            defer = task.defer, delay = task.delay, spawn = task.spawn, wait = task.wait,
        },
    
        debug = {
            traceback = debug.traceback, profilebegin = debug.profilebegin, profileend = debug.profileend,
        },
    
        game = game, workspace = workspace,
    
        getmetatable = getmetatable, setmetatable = setmetatable
    }
end

