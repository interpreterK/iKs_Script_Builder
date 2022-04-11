--[[
    Author: interpreterK (717072114)
    SendServer.lua

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
        warn("Failed to fetch the shared folder.")
    end
    return S 
end

function C:ServerRemote()
    local S = self:Shared()
    local R = S and S:WaitForChild("Server", 1)
    if not R then
        warn("Failed to fetch the server remote.")
    end
    return R
end

function C:ServerReturn()
    local R = self:ServerRemote()
    local RE = R and R:WaitForChild("Return", 1)
    if not RE then
        warn("Failed to fetch the server return remote.")
    end
    return RE
end

function C:RequestServer(...)
    local R = self:ServerReturn()
    if R then
        return R:InvokeServer(...)
    else
        warn("Failed to send the server return data.")
    end
    return nil
end

function C:SendServer(...)
    local R = self:ServerRemote()
    if R then
        R:FireServer(...)
    else
        warn("Failed to send the server return data.")
    end
end

return C