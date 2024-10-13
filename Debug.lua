getgenv().debug = { -- debug.getinfo is the only one possible in Luau
    getinfo = function(f, options) -- Semi-Functional (nups do not work due to debug.getupvalues not being able to be accessed)
        if type(options) == "string" then
            options = string.lower(options) 
        else
            options = "sflnu"
        end
        local result = {}
        for index = 1, #options do
            local option = string.sub(options, index, index)
            if "s" == option then
                local short_src = debug.info(f, "s")
                result.short_src = short_src
                result.source = "=" .. short_src
                result.what = if short_src == "[C]" then "C" else "Lua"
            elseif "f" == option then
                result.func = debug.info(f, "f")
            elseif "l" == option then
                result.currentline = debug.info(f, "l")
            elseif "n" == option then
                result.name = debug.info(f, "n")
            elseif "u" == option or option == "a" then
                local numparams, is_vararg = debug.info(f, "a")
                result.numparams = numparams
                result.is_vararg = if is_vararg then 1 else 0
                if "u" == option then
                    result.nups = -1
                end
            end
        end
        return result
    end
}