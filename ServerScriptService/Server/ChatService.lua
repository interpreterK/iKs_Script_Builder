--[[
    Author: interpreterK (717072114)
    ChatService.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local SSS = S.ServerScriptService
local Players = S.Players

local PresetColors = obtain'PresetColors'

local CSM = {}
CSM.__index = CSM

local Customs = {
    Tags = {},
    ChatColor = {},
    NameColor = {}
}

local CS = SSS:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService")
local ChatService = require(CS)

ChatService.SpeakerAdded:Connect(function(User)
    local Speaker = ChatService:GetSpeaker(User)
    local Player = Players[User]

    if Customs.Tags[Player.UserId] then
        Speaker:SetExtraData("Tags", {Customs.Tags[Player.UserId]})
    end
    if Customs.ChatColor[Player.UserId] then
        Speaker:SetExtraData("ChatColor", Customs.ChatColor[Player.UserId])
    end
    if Customs.NameColor[Player.UserId] then
        Speaker:SetExtraData("NameColor", Customs.NameColor[Player.UserId])
    end
end)

function CSM:NewCustom_Tag(Player, Text, Color)
    Customs.Tags[Player.UserId] = {
        TagText = Text,
        TagColor = PresetColors[Color]
    }
    local Speaker = ChatService:GetSpeaker(Player.Name)
    if Speaker then
        Speaker:SetExtraData("Tags", {Customs.Tags[Player.UserId]})
    end
end

function CSM:NewCustom_ChatColor(Player, Color)
    Customs.ChatColor[Player.UserId] = PresetColors[Color]
    local Speaker = ChatService:GetSpeaker(Player.Name)
    if Speaker then
        Speaker:SetExtraData("ChatColor", Customs.ChatColor[Player.UserId])
    end
end

function CSM:NewCustom_NameColor(Player, Color)
    Customs.NameColor[Player.UserId] = PresetColors[Color]
    local Speaker = ChatService:GetSpeaker(Player.Name)
    if Speaker then
        Speaker:SetExtraData("NameColor", Customs.NameColor[Player.UserId])
    end
end

function CSM:RemoveData(Player, Type)
    if Customs[Type][Player.UserId] then
        table.remove(Customs[Type], Player.UserId)

        local Speaker = ChatService:GetSpeaker(Player.Name)
        if Speaker then
            Speaker:SetExtraData(Type)
        end
    end
end

return CSM