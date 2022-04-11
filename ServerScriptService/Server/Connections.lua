--[[
    Author: interpreterK (717072114)
    Connections.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local LogService = S.LogService
local Players = S.Players

local PlayerAdded = obtain'PlayerAdded'
local PlayerRemoving = obtain'PlayerRemoving'
local NModule = obtain'Notify'
local SC = obtain'SendClient'
local Remotes = obtain'Remotes'

-- PlayersService --
Players.PlayerAdded:Connect(PlayerAdded.Added)
Players.PlayerRemoving:Connect(PlayerRemoving.Removing)
--

-- LogService --
local function FilterMessage(Message, Type)
    local T1 = Message:find("appears to be spamming remote events.")
    local T2 = Type == Enum.MessageType.MessageWarning

    if T1 and T2 then
        local split = Message:split("\"")
        local Player = split[2] and Players:FindFirstChild(split[2])
        if Player then
            NModule:Notify_SpammingRemotes(Player)
        end
    end
end

LogService.MessageOut:Connect(function(Message, Type)
    SC:SendAllClients("MessageOut", Message, Type)
    FilterMessage(Message, Type) -- Custom behaviour
end)
--

-- The ServerSide --
Remotes()
--

return true