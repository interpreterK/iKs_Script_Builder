--[[
    Author: interpreterK (717072114)
    TextService.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local TextService = S.TextService

local TS = {}
TS.__index = TS

function TS:TextObject(String, PlayerId)
    local bool, Object = pcall(TextService.FilterStringAsync, TextService, String, PlayerId, Enum.TextFilterContext.PublicChat)
    return bool and Object
end

function TS:FilteredString(Object)
    local bool, Filtered = pcall(Object.GetNonChatStringForBroadcastAsync, Object)
    return bool and Filtered
end

function TS:CreateMessage(Player, String)
    local TO = self:TextObject(String, Player.UserId)
    local FS = TO and self:FilteredString(TO)
    return FS
end

function TS:FilterOnComing(Player, String)
    return self:CreateMessage(Player, String)
end

return TS