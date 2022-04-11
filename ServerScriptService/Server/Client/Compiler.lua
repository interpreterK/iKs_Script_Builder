--[[
    Author: interpreterK (717072114)
    Compiler.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local UiInit = obtain'UiInit'
local SRT = obtain'ScriptRuntime'
local SS = obtain'SendServer'
local MPS = obtain'MPS'

local function isValidRequire(String)
    return String:sub(1,7) == "require"
end

local function Converting(String)
    local split = String:split(" -")
    local l = split[#split]:lower()
    return l == "c" or l == "s" or l == "convert" or l == "server"
end

local function SortFindEnum(String, Enum)
    for _,v in next, Enum:GetEnumItems() do
        if v.Name:sub(1,#String):lower() == String:lower() then
            return v
        end
    end
    return nil
end

local function Compile(String)
    local S1 = String:split("/")
    if not S1[2] and S1[1]:lower() ~= "help" and S1[1]:lower() ~= "cmds" then return end
    local cmd, arg, arg2, arg3 = S1[1], S1[2], S1[3], S1[4]

    if cmd == "server" or cmd == "ser" or cmd == "s" then
        if isValidRequire(arg) then
            SS:SendServer("Server", arg)
        else
            if arg == "raw" or arg == "r" then
                SS:SendServer("Server", arg2)
            elseif arg == "paste" or arg == "p" then
                SS:SendServer("Http_Server", String:sub(#cmd + #arg + 3), Converting(S1[#S1]))
            elseif arg == "gear" or arg == "g" then
                if tonumber(arg2) then
                    SS:SendServer("Gear", arg2)
                end
            end
        end
    elseif cmd == "client" or cmd == "cli" or cmd == "c" then
        if arg == "raw" or arg == "r" then
            SRT:UnpackAndLoad(arg2)
        elseif arg == "paste" or arg == "p" then
            local fetch, HttpInfo = SS:RequestServer("Http", String:sub(#cmd + #arg + 3))
            if fetch then
                SRT:UnpackAndLoad(HttpInfo)
            else
                warn(HttpInfo)
            end
        elseif arg == "info" or arg == "i" then
            if tonumber(arg2) then
                local info = MPS:GetPinfo(arg2, Enum.InfoType.Asset)
                if info then
                    UiInit:Prompt(info)
                end
            else
                local sf = SortFindEnum(arg2:sub(1,1), Enum.InfoType)
                if sf then
                    UiInit:Prompt(MPS:GetPinfo(arg3, sf))
                end
            end
        else
            SRT:UnpackAndLoad(arg)
        end
    elseif cmd == "parallel" or cmd == "par" or cmd == "p" then
        SS:SendServer("Server", arg)
        SRT:UnpackAndLoad(arg)
    elseif cmd == "cmd" or cmd == "command" then
        local gsub = String:gsub(cmd.."/", "")
        SS:SendServer("Command", gsub)
    elseif cmd == "help" or cmd == "cmds" then
        UiInit:Info()
    end
end

return Compile