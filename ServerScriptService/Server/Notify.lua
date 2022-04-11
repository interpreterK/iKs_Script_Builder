--[[
    Author: interpreterK (717072114)
    Chatted.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local SS = obtain'SendClient'

local NModule = {}
NModule.__index = NModule
local resume = coroutine.resume
local create = coroutine.create

function NModule:Notify(Player, Text)
    resume(create(function()
        SS:SendClient(Player, "Notify", Text)
    end))
end

function NModule:Notify_SpammingRemotes(Player)
    resume(create(function()
        SS:SendClient(Player, "Notify_SpammingRemotes")
    end))
end

return NModule