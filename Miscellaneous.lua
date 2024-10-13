getgenv().identifyexecutor = function()
    return "Executor", 1.0
end
getgenv().getexecutorname = getgenv().identifyexecutor

getgenv().lz4compress = function(data)
    local out, i, dataLen = {}, 1, #data

    while i <= dataLen do
        local bestLen, bestDist = 0, 0

        for dist = 1, math.min(i - 1, 65535) do
            local matchStart, len = i - dist, 0

            while i + len <= dataLen and data:sub(matchStart + len, matchStart + len) == data:sub(i + len, i + len) do
                len += 1
                if len == 65535 then break end
            end

            if len > bestLen then bestLen, bestDist = len, dist end
        end

        if bestLen >= 4 then
            table.insert(out, string.char(0) .. string.pack(">I2I2", bestDist - 1, bestLen - 4))
            i += bestLen
        else
            local litStart = i

            while i <= dataLen and (i - litStart < 15 or i == dataLen) do i += 1 end
            table.insert(out, string.char(i - litStart) .. data:sub(litStart, i - 1))
        end
    end

    return table.concat(out)
end

getgenv().lz4decompress = function(data, size)
    local out, i, dataLen = {}, 1, #data

    while i <= dataLen and #table.concat(out) < size do
        local token = data:byte(i)
        i = i + 1

        if token == 0 then
            local dist, len = string.unpack(">I2I2", data:sub(i, i + 3))

            i = i + 4
            dist = dist + 1
            len = len + 4

            local start = #table.concat(out) - dist + 1
            local match = table.concat(out):sub(start, start + len - 1)

            while #match < len do
                match = match .. match
            end

            table.insert(out, match:sub(1, len))
        else
            table.insert(out, data:sub(i, i + token - 1))
            i = i + token
        end
    end

    return table.concat(out):sub(1, size)
end

getgenv().request = function(HttpRequest)
    HttpRequest.CachePolicy = Enum.HttpCachePolicy.None
    HttpRequest.Priority = 5
    HttpRequest.Timeout = 15000

    if type(HttpRequest) == "table" then
        local isTable = false
    end

    local requestType = type(HttpRequest)
    assert(requestType == "table", "invalid argument #1 to 'request' (table expected, got " .. requestType .. ") ", 2)

    HttpRequest.Url = HttpRequest.Url:gsub("roblox.com", "roproxy.com")

    local bindableEvent = Instance.new("BindableEvent")
    local httpService = game:GetService("HttpService")
    local internalRequestFunction = httpService.RequestInternal

    local requestResponse = internalRequestFunction(httpService, HttpRequest)
    local finalResponse = nil

    requestResponse.Start(requestResponse, function(arg1, response)
        finalResponse = response
        bindableEvent:Fire()
    end)

    bindableEvent.Event:Wait()

    return finalResponse
end
getgenv().http_request = getgenv().request
getgenv().http = {request = getgenv().request}

getgenv().setfpscap = function(fps)
    if _task then
        task.cancel(_task)
        _task = nil
    end

    if fps and fps > 0 and fps < 10000 then
        current_fps = fps
        local interval = 1 / fps

        _task = task.spawn(function()
            while true do
                local start = os.clock()
                run_service.Heartbeat:Wait()
                while os.clock() - start < interval do end
            end
        end)
    else 
        current_fps = nil
    end
end