--[[
    Author: interpreterK (717072114)
    ClientSide.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local Storage = S.ReplicatedStorage

local ClientS = {
    ClientRef = {},
    ClientRef_R = {}
}
ClientS.__index = ClientS

local function ConnectClient(self, Remote, Function)
    Remote.OnClientEvent:Connect(function(Type, ...)
        self.ClientRef[Type](...)
    end)
    Function.OnClientInvoke = function(Type, ...)
        return self.ClientRef_R[Type](...)
    end
end

local function reInitializer(self, p)
    p:GetPropertyChangedSignal("Parent"):Connect(function()
        if p.Parent ~= Storage then
            local c = Storage:WaitForChild("Shared"):WaitForChild("Client")
            reInitializer(self, c.Parent)
            ConnectClient(self, c, c:WaitForChild("Return"))
        end
    end)
end

function ClientS:Initialize()
    local c = Storage:WaitForChild("Shared"):WaitForChild("Client")
    reInitializer(self, c.Parent)
    ConnectClient(self, c, c:WaitForChild("Return"))
end

function ClientS:ConnectRef(Name, Func)
    self.ClientRef[Name] = Func
end

function ClientS:ConnectRef_R(Name, Func)
    self.ClientRef_R[Name] = Func
end

return ClientS