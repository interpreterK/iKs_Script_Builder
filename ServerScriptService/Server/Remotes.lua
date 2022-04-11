--[[
    Author: interpreterK (717072114)
    Remotes.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local Storage = S.ReplicatedStorage
local RS = S.RunService

local ServerSide = obtain'ServerS'

local Server, ServerReturn
local Client, ClientReturn
local Shared
local Fired = false

local function Remotes()
    Server = Instance.new("RemoteEvent")
    Server.Name = "Server"
    Server.Archivable = false
    Server.Parent = Shared
    ServerReturn = Instance.new("RemoteFunction")
    ServerReturn.Name = "Return"
    ServerReturn.Archivable = false
    ServerReturn.Parent = Server
    Client = Instance.new("RemoteEvent")
    Client.Name = "Client"
    Client.Archivable = false
    Client.Parent = Shared
    ClientReturn = Instance.new("RemoteFunction")
    ClientReturn.Name = "Return"
    ClientReturn.Archivable = false
    ClientReturn.Parent = Client

    Server.OnServerEvent:Connect(ServerSide.ServerRemote)
    ServerReturn.OnServerInvoke = ServerSide.ServerReturn
    RS.Heartbeat:Wait()
    Server.Changed:Connect(Shared_Function)
    Client.Changed:Connect(Shared_Function)
    ServerReturn.Changed:Connect(Shared_Function)
    ClientReturn.Changed:Connect(Shared_Function)
    Fired = false
end

function Shared_Function()
    if not Fired then
        Fired = true
        if Shared then
            Shared:Destroy()
        end
        Shared = Instance.new("Folder")
        Shared.Name = "Shared"
        Shared.Archivable = false
        Shared.Parent = Storage
        Shared.Changed:Connect(Shared_Function)
        Remotes()
    end
end

return Shared_Function