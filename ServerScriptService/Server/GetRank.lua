--[[
    Author: interpreterK (717072114)
    GetRank.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local UsersModule = obtain'UsersModule'

local Ranks = {
    global = 1,
    vip = 2,
    mod = 3,
    admin = 4,
    owner = 5
}
Ranks.__index = Ranks

function Ranks:GetRank(Id)
    if game.PrivateServerId ~= "" and Id == game.PrivateServerOwnerId then
        return self.vip
    end
    for i = 1, #UsersModule.Mods do
        if Id == UsersModule.Mods[i] then
            return self.mod
        end
    end
    for i = 1, #UsersModule.Admins do
        if Id == UsersModule.Admins[i] then
            return self.admin
        end
    end
    if Id == game.CreatorId then
        return self.owner
    end
    return self.global
end

return Ranks