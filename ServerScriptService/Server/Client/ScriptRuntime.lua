--[[
    Author: interpreterK (717072114)
    ScriptRunTime.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local Players = S.Players

local PEnv = obtain'Environment'
local SS = obtain'SendServer'
local Log = obtain'MessageOut'
local UiInit = obtain'UiInit'

local SRT = {Loaded_Scripts = {}}
SRT.__index = SRT
local Sandbox = {}

local resume = coroutine.resume
local create = coroutine.create

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
    local Console = UiInit:GetSetting().Global_Console()
    if Console then
        Log:Game(Console, String, Type or 'Game_Client')
    end
end

local function Run(self, m, wrap)
    table.insert(self.Loaded_Scripts, m)
    local n = #self.Loaded_Scripts
    LogGame("Running Script "..n)

    local ran, error
    resume(create(function()
        ran, error = pcall(wrap)
        if not ran then
            LogGame("Script "..n..": "..error, 'Game_Error')
        end
    end))
    return ran, error
end

function Sandbox.NewLSobject(p)
    local LS = Instance.new("LocalScript")
    LS.Parent = p
    return LS
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
        script = Sandbox.NewLSobject(),
        getfenv = Sandbox.getfenv
    }))
end

function SRT:UnpackAndLoad_Debug(s, p)
    local bool, Loadstring = CreateNewScript()
    if bool then
        local script = Sandbox.NewLSobject(p)
        local ran, error = Run(self, Loadstring, Loadstring(s, CreateEnv({
            script = script,
            owner = Players.LocalPlayer,
            loadstring = loadstring,
            NLS = function(s, p)
                self:UnpackAndLoad(s, p)
                return script
            end,
            NS = function(s, p)
                SS:SendServer("Server", s, p)
                return Instance.new("Script")
            end
        })))
        return ran, error
    end
end

function SRT:UnpackAndLoad(s, p)
    local bool, Loadstring = CreateNewScript()
    if bool then
        local script = Sandbox.NewLSobject(p)
        Run(self, Loadstring, Loadstring(s, CreateEnv({
            script = script,
            owner = Players.LocalPlayer,
            loadstring = loadstring,
            NLS = function(s, p)
                self:UnpackAndLoad(s, p)
                return script
            end,
            NS = function(s, p)
                SS:SendServer("Server", s, p)
                return Instance.new("Script")
            end
        })))
        return script
    end
end

return SRT