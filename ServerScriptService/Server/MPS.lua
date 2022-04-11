--[[
    Author: interpreterK (717072114)
    MPS.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local MPS = S.MarketplaceService

local MPSM = {
    TagsPass = 20927854,
    FontsPass = 21183622
}
MPSM.__index = MPSM

local function UserOGP(Player, Id)
    local bool, hasPass = pcall(MPS.UserOwnsGamePassAsync, MPS, Player.UserId, Id)
    if not bool then
        warn(hasPass)
    end
    return bool and hasPass
end

function MPSM:UserHasTagsPass(Player)
    return UserOGP(Player, self.TagsPass)
end

function MPSM:UserHasFontsPass(Player)
    return UserOGP(Player, self.FontsPass)
end

function MPSM:PromptTagsPurchase(Player)
    MPS:PromptGamePassPurchase(Player, self.TagsPass)
end

function MPSM:PromptFontsPurchase(Player)
    MPS:PromptGamePassPurchase(Player, self.FontsPass)
end

return MPSM