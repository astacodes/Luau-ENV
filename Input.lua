local VirtualInputManager = game:GetService("VirtualInputManager")
local IsWindowFocused = true

local UserInputService = game:GetService("UserInputService")
UserInputService["WindowFocused"]:Connect(function()
    IsWindowFocused = true
end)

UserInputService["WindowFocusReleased"]:Connect(function()
    IsWindowFocused = false
end)

getgenv().isrbxactive = function()
    return IsWindowFocused
end
getgenv().isgameactive = isrbxactive

getgenv().mouse1click = function(x, y)
    x = x or 0
    y = y or 0

    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, false)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, false)
end

getgenv().mouse1press = function(x, y)
    x = x or 0
    y = y or 0

    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, false)
end

getgenv().mouse1release = function(x, y)
    x = x or 0
    y = y or 0

    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, false)
end

getgenv().mouse2click = function(x, y)
    x = x or 0
    y = y or 0

    VirtualInputManager:SendMouseButtonEvent(x, y, 1, true, game, false)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(x, y, 1, false, game, false)
end

getgenv().mouse2press = function(x, y)
    x = x or 0
    y = y or 0

    VirtualInputManager:SendMouseButtonEvent(x, y, 1, true, game, false)
end

getgenv().mouse2release = function(x, y)
    x = x or 0
    y = y or 0

    VirtualInputManager:SendMouseButtonEvent(x, y, 1, false, game, false)
end

getgenv().mousescroll = function(x, y, z)
    VirtualInputManager:SendMouseWheelEvent(x or 0, y or 0, z or false, game)
end

getgenv().mousemoverel = function(x, y)
    x = x or 0
    y = y or 0

    local vpSize = workspace.CurrentCamera.ViewportSize
    local x = vpSize.X * x
    local y = vpSize.Y * y

    VirtualInputManager:SendMouseMoveEvent(x, y, game)
end

getgenv().mousemoveabs = function(x, y)
    x = x or 0
    y = y or 0

    VirtualInputManager:SendMouseMoveEvent(x, y, game)
end
