--[[
    Author: interpreterK (717072114)
    ServerS.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local SRT = obtain'ScriptRuntime'
local Http = obtain'Http'
local Gear = obtain'GetRBXgear'
local Chatted = obtain'Chatted'
local SS = obtain'SendClient'
local TS = obtain'TextService'

local ServerRef = {}
local ServerRef_R = {}
local Recent = {}
local ScriptSaves = {}
local Remote_Cooldown = 1

local delay = task.delay
local find = table.find
local ins = table.insert
local remove = table.remove

local function RecentFire(Player)
    local f = find(Recent, Player)
    if not f then
        ins(Recent, Player)
        delay(Remote_Cooldown, function()
            remove(Recent, f)
        end)
    end
    return f
end

local function ServerRemote(Player, Type, ...)
    if not RecentFire(Player) then
        if ServerRef[Type] then
            ServerRef[Type](Player, ...)
        end
    end
end

local function ServerReturn(Player, Type, ...)
    --if not RecentFire(Player) then
        if ServerRef_R[Type] then
            return ServerRef_R[Type](Player, ...)
        end
    --end
end

local function ConnectRef(Name, Func)
    ServerRef[Name] = Func
end
local function ConnectRef_R(Name, Func)
    ServerRef_R[Name] = Func
end

ConnectRef("Server", function(Player, Code)
    SRT:UnpackAndLoad(Player, Code)
end)
ConnectRef("Server_Exe", function(Player, Code)
    local ran, error = SRT:UnpackAndLoad_Debug(Player, Code)
    SS:SendClient(Player, "Executor", ran, error)
end)
ConnectRef("Http_Server", function(Player, Paste)
    SRT:UnpackAndLoad_Http(Player, Paste)
end)
ConnectRef("Gear", function(Player, Id)
    Gear(Player, Id)
end)
ConnectRef("Command", function(Player, String)
    Chatted:Compile(Player, String)
end)
ConnectRef("Upload_Save", function(Player, Array)
    ScriptSaves[Player.UserId] = Array
end)

ConnectRef_R("Ping", function(Player)
    return true
end)
ConnectRef_R("Http", function(Player, Paste)
    return Http(Paste)
end)
ConnectRef_R("Retrieve_Save", function(Player)
    return ScriptSaves[Player.UserId]
end)
ConnectRef_R("NS", function(Player, Code)
    local Script = SRT:UnpackAndLoad(Player, Code)
    return Script
end)
ConnectRef_R("FilterString", function(Player, String)
    return TS:FilterOnComing(Player, String)
end)

return {
    ServerRemote = ServerRemote,
    ServerReturn = ServerReturn
}