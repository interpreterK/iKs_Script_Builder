--[[
    Author: interpreterK (717072114)
    PlayerRemoving.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local SC = obtain'SendClient'

local PlayerRemoving = {}
PlayerRemoving.__index = PlayerRemoving

function PlayerRemoving.Removing(Player)
    SC:SendAllClients("GameLog", Player.Name.." has left the server.", 'Game_Player')
end

return PlayerRemoving