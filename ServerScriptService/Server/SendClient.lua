--[[
    Author: interpreterK (717072114)
    SendClient.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local Storage = S.ReplicatedStorage

local C = {}
C.__index = C

function C:Shared()
    local S = Storage:WaitForChild("Shared", 1)
    if not S then
        warn("Failed to get the shared folder for client.")
    end
    return S
end

function C:ClientRemote()
    local S = self:Shared()
    local R = S and S:WaitForChild("Client", 1)
    if not R then
        warn("Failed to send info to the client remote.")
    end
    return R
end

function C:ClientReturn()
    local R = self:ClientRemote()
    local RE = R and R:WaitForChild("Return", 1)
    if not RE then
        warn("Failted to get info from the client remote")
    end
    return RE
end

function C:RequestClient(Player, ...)
    local R = self:ClientReturn()
    if R then
        return R:InvokeClient(Player, ...)
    else
        warn("Failed to fetch client return.")
    end
    return nil
end

function C:SendClient(Player, ...)
    local R = self:ClientRemote()
    if R then
        R:FireClient(Player, ...)
    else
        warn("Failed to fetch client remote.")
    end
end

function C:SendAllClients(...)
    local R = self:ClientRemote()
    if R then
        R:FireAllClients(...)
    else
        warn("Failed to fetch client remote.")
    end
end

return C