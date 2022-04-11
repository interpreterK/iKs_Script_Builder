--[[
    Author: interpreterK (717072114)
    init.server.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

task.wait()
script.Parent.Parent = nil

local par = script.Parent

local function getObtain(object, Obtainers)
    local function verifiedObtain()
        for i = 1, #Obtainers do
            if getfenv(4).script == nil then
                return false
            end
            if getfenv(4).script == Obtainers[i] then
                return true
            end
        end
        return false
    end

    if verifiedObtain() then
        if object.ClassName == "ModuleScript" then
            if object.Name == "Loadstring" then
                return object:Clone()
            else
                local s,f = pcall(require, object)
                if s then
                    return f
                else
                    warn(f, "| Module=", object.Name..".lua")
                end
            end
        else
            return object
        end
        return nil
    end
    return nil
end
local function Getobtainer(obtain)
    local obtainers = par:GetChildren()
    for i = 1, #obtainers do
        if obtainers[i].Name == obtain then
            return getObtain(obtainers[i], obtainers)
        end
    end
    if obtain == "S" then
        return setmetatable({}, {
            __index = function(_,v)
                return game:GetService(v)
            end,
            __metatable = nil
        })
    end
end

_G.obtain = Getobtainer
coroutine.resume(coroutine.create(function()
    while task.wait() do
        if _G.obtain ~= Getobtainer then
            _G.obtain = Getobtainer
        end
    end
end))

require(script.Parent.Connections)