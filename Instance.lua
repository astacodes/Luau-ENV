local stuff = {}
local everything = {game}

game.DescendantRemoving:Connect(function(des)
    stuff[des] = 'REMOVE'
end)

game.DescendantAdded:Connect(function(des)
    stuff[des] = true
    table.insert(everything, des)
end)

for i, v in pairs(game:GetDescendants()) do
    table.insert(everything, v)
end

getgenv().getnilinstances = function() -- Semi-Functional
	local nilInstances = {}

    for i, v in pairs(everything) do
        if v.Parent ~= nil then continue end
        table.insert(nilInstances, v)
    end

    return nilInstances
end

getgenv().fireclickdetector = function(object, distance)
    if distance then assert(type(distance) == "number", "The second argument must be number") end

    local OldMaxDistance, OldParent = object["MaxActivationDistance"], object["Parent"]
    local tmp = Instance.new("Part", workspace)

    tmp["CanCollide"], tmp["Anchored"], tmp["Transparency"] = false, true, 1
    tmp["Size"] = Vector3.new(30, 30, 30)
    object["Parent"] = tmp
    object["MaxActivationDistance"] = math["huge"]

    local Heartbeat = run_service["Heartbeat"]:Connect(function()
    local camera = workspace["CurrentCamera"]
    tmp["CFrame"] = camera["CFrame"] * CFrame.new(0, 0, -20) + camera["CFrame"]["LookVector"]
    virtual_user:ClickButton1(Vector2.new(20, 20), camera["CFrame"])
    end)

    object["MouseClick"]:Once(function()
        Heartbeat:Disconnect()
        object["MaxActivationDistance"] = OldMaxDistance
        object["Parent"] = OldParent
        tmp:Destroy()
    end)
end

getgenv().getcallbackvalue = function(a) -- Semi-Functional (Will NOT pass UNC)
    assert(typeof(a) == "function" or a:IsA("BindableFunction"), "argument is not a 'function' or 'BindableFunction'")
    
    if typeof(a) == "Instance" then
        local b, c = pcall(function()
            return a["Invoke"]
        end)
        
        if b and typeof(c) == "function" then
            return c()
        end
    end
    
    return a()
end

getgenv().getconnections = function(signal) -- Semi-Functional (Will NOT pass UNC)
    local c = signal:Connect(function() return end)
    c:Disconnect()
    return c
end

getgenv().getcustomasset = function(path) -- Semi-Functional (will not load from file)
    local cache = {}
	local cacheFile = function(path: string)
		if not cache[path] then
			local success, assetId = pcall(function()
				return game:GetService("ContentProvider"):PreloadAsync({path})
			end)
			if success then
				cache[path] = assetId
			else
				error("Failed to preload asset: " .. path)
			end
		end
		return cache[path]
	end

	return noCache and ("rbxasset://" .. path) or ("rbxasset://" .. (cacheFile(path) or path))
end

getgenv().gethui = function()
    local hui = Instance.new("ScreenGui")
	local success, H = pcall(function()
		return game:GetService("CoreGui").RobloxGui
	end)
	
	if success and H then
		if not hui.Parent then
			hui.Parent = H.Parent
		end
		return hui
	else
		if not hui.Parent then
			hui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
		end
	end
	return hui
end

getgenv().getinstances = function() -- Semi-Functional (will not grab instances outside of game)
    return game:GetDescendants()
end

getgenv().isscriptable = function(a, b)
    assert(typeof(a) == "Instance", "argument #1 is not an 'Instance'", 0)
    assert(typeof(b) == "string", "argument #2 is not a 'string'", 0)
    
    local old
    local c, d = pcall(function()
        old = a[b]
        a[b] = "bombom"
        return a[b] == "bombom"
    end)
    
    if c then
        a[b] = old
    end
    
    return c
end

