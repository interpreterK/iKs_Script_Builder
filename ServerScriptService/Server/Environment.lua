--[[
    Author: interpreterK (717072114)
    Environment.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local fenv = getfenv()
fenv.script = nil

return setmetatable({},{
    __index = function(self, i)
        if i ~= 'getfenv' then
            return fenv[i]
        end
    end,
    __newindex = function(self, i, v)
        fenv[i] = v
    end,
    __metatable = nil
})