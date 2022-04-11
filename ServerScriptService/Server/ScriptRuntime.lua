--[[
    Author: interpreterK (717072114)
    ScriptRunTime.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local Http = obtain'Http'
local Modules = obtain'Public'
local PEnv = obtain'Environment'
local SC = obtain'SendClient'

local SRT = {Loaded_Scripts = {}}
SRT.__index = SRT
local Sandbox = {}

local resume = coroutine.resume
local create = coroutine.create

local function cB(s)
    for _,v in next, Modules.Blacklisted do
        if s:find(v) then
            return true
        end
    end
end

local function hasBlacklisted(Source)
    if Source then
        local lines = Source:split("\n")
        for _, line in next, lines do
            if line ~= "" then
                local s = tostring(line)
                if s then
                    if cB(s) then
                        return true
                    end
                end
            end
        end
        return false
    end
end

local function CreateNewScript()
    return pcall(require, obtain'Loadstring')
end

local function CreateEnv(env)
    return setmetatable(env, {
        __index = function(t, i)
            return rawget(t, i) or PEnv[i]
        end,
        __newindex = function(_, i, v)
            PEnv[i] = v
        end,
        __metatable = "This metatable is locked."
    })
end

local function LogGame(String, Type)
    SC:SendAllClients("GameLog", String, Type)
end

local function Run(self, m, Player, wrap)
    table.insert(self.Loaded_Scripts, m)
    local n = #self.Loaded_Scripts
    LogGame("Running Script "..n.." -"..Player.Name)

    local ran, error
    resume(create(function()
        ran, error = pcall(wrap)
        if not ran then
            LogGame("Script "..n..": "..error, 'Game_Error')
        end
    end))
    return ran, error
end

function Sandbox.NewSobject(p)
    local S = Instance.new("Script")
    S.Parent = p
    return S
end

function Sandbox.getfenv(target)
    -- Patches an exploit with getfenv to access game modules.
    local i = target and tonumber(target)
    if i and (i == 0 or i >= 2) then
        return nil
    end
    return PEnv
end

function Sandbox.loadstring(s)
    return require(obtain'Loadstring')(s, CreateEnv({
        script = Sandbox.NewSobject(),
        getfenv = Sandbox.getfenv
    }))
end

function SRT:UnpackAndLoad(Player, s, p)
    if not hasBlacklisted(s) then
        local bool, Loadstring = CreateNewScript()
        if bool then
            local script = Sandbox.NewSobject(p)
            Run(self, Loadstring, Player, Loadstring(s, CreateEnv({
                script = script,
                owner = Player,
                loadstring = Sandbox.loadstring,
                getfenv = Sandbox.getfenv,
                NLS = function(s, p)
                    SC:RequestClient(Player, "NLS", s, p)
                    return Instance.new("LocalScript")
                 end,
                NS = function(s, p)
                    self:UnpackAndLoad(Player, s, p)
                    return script
                end
            })))
            return script
        end
    else
        LogGame("Malicious code found, terminating script(s)...", 'Game_Error')
    end
end

function SRT:UnpackAndLoad_Debug(Player, s, p)
    if not hasBlacklisted(s) then
        local bool, Loadstring = CreateNewScript()
        if bool then
            local script = Sandbox.NewSobject(p)
            local ran, error = Run(self, Loadstring, Player, Loadstring(s, CreateEnv({
                script = script,
                owner = Player,
                loadstring = Sandbox.loadstring,
                NLS = function(s, p)
                    SC:RequestClient(Player, "NLS", s, p)
                    return Instance.new("LocalScript")
                 end,
                NS = function(s, p)
                    self:UnpackAndLoad(Player, s, p)
                    return script
                end
            })))
            return ran, error
        end
    else
        LogGame("Malicious code found, terminating script(s)...", 'Game_Error')
    end
end

local function ConvertingToLink(str, isc)
    if str and isc then
        return str:sub(0,-4)
    end
    return str
end

local function EzConverter(FiOne_Env, Player)
    local f, conv = pcall(require, Modules.Public.EzConverter)
    if f then
        conv(FiOne_Env, Player)
    else
        warn("Couldn't fetch EzConverter.", conv)
    end
end

function SRT:UnpackAndLoad_Http(Player, s, i, p)
    local Link = ConvertingToLink(s, i)
    local fetch, HttpInfo = Http(Link)
    if fetch then
        if not hasBlacklisted(HttpInfo) then
            local bool, Loadstring = CreateNewScript()
            if bool then
                local script = Sandbox.NewSobject(p)
                local FiOne_Env = CreateEnv({
                    script = script,
                    owner = Player,
                    loadstring = Sandbox.loadstring,
                    NLS = function(s, p)
                        SC:RequestClient(Player, "NLS", s, p)
                        return Instance.new("LocalScript")
                    end,
                    NS = function(s, p)
                        self:UnpackAndLoad(Player, s, p)
                        return script
                    end
                })
                if i then
                    EzConverter(FiOne_Env, Player)
                end
                Run(self, Loadstring, Player, Loadstring(HttpInfo, FiOne_Env))
            end
        else
            LogGame("Malicious code found, terminating script(s)...", 'Game_Error')
        end
    end
end

return SRT