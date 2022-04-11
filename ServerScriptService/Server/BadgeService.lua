--[[
    Author: interpreterK (717072114)
    BadgeService.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local BS = S.BadgeService

local BadgeService = {
    BeginnerScripter = 2124814821,
    Commander = 2124860393
}
BadgeService.__index = BadgeService

local function Badge(Player, Id)
    local s, b = pcall(BS.UserHasBadgeAsync, BS, Player.UserId, Id)
    if not s then
        warn(b)
    end
    return s and b
end

local function Award(Player, Id)
    local s, b = pcall(BS.AwardBadge, BS, Player.UserId, Id)
    if not s then
        warn(b)
    end
end

function BadgeService:HasBeginnerBadge(Player)
    return Badge(Player, self.BeginnerScripter)
end

function BadgeService:HasCommanderBadge(Player)
    return Badge(Player, self.Commander)
end

function BadgeService:AwardBeginnerBadge(Player)
    if not self:HasBeginnerBadge(Player) then
        Award(Player, self.BeginnerScripter)
    end
end

function BadgeService:AwardCommanderBadge(Player) -- Chatted.lua will do a manual check.
    Award(Player, self.Commander)
end

return BadgeService