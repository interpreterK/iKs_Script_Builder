local BadgeService = game:GetService("BadgeService")
--[[
    Author: interpreterK (717072114)
    Chatted.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local Commands = obtain'Commands'
local NModule = obtain'Notify'
local Ranks = obtain'GetRank'
local SC = obtain'SendClient'
local BS = obtain'BadgeService'

local ChatCommands = {
    CommanderHistory = {} -- Data for the Commander badge.
}
ChatCommands.__index = ChatCommands

local History = {}
local find = table.find
local insert = table.insert
local remove = table.remove
local concat = table.concat
local resume = coroutine.resume
local create = coroutine.create

local function GameLog(String)
    SC:SendAllClients("GameLog", String, 'Game_Command')
end

local function Prefix(String)
    local Str = String:sub(1,2):lower()
    local Got = Str == "g!" or Str == "c!"
    return Got and Str
end

local function GType(P)
    return P == "g!" and "Server" or P == "c!" and "Client"
end

local function CleanString(Str)
    local noW = Str:gsub("\t", "")
    local noS = noW:gsub(" ", "")
    return noS
end

local function CleanString_P(Str, P)
    local noS = CleanString(Str)
    local noP = noS:gsub(P, "")
    return noP
end

local function RemoveCMDSpacing(args)
    local newargs = {}
    -- Perform a custom table eqrem
    local c = 0
    while c ~= #args do
        c += 1
        if args[c] == "" then
            remove(args, c)
            c -= 1
        else
            newargs = args
            break
        end
    end
    --
    return newargs
end

local function AlreadyRan(madeargs)
    local rC = madeargs[1]:lower()
    if not find(History, rC) then
        insert(History, rC)
        return false
    end
    return true
end

function ChatCommands:Commander(Player, Command)
    local Data = self.CommanderHistory[Player.UserId]
    if Data.n < 10 then
        if not find(Data.History, Command:lower()) then
            insert(Data.History, Command:lower())
            Data.n += 1
        end
    else
        if not Data.Checked then
            resume(create(function()
                local Has = BS:HasCommanderBadge(Player)
                if not Has then
                    BS:AwardCommanderBadge(Player)
                end
                Data.Checked = true
            end))
        end
    end
end

function ChatCommands:Compile(Player, String)
    History = {}
    if not self.CommanderHistory[Player.UserId] then
        self.CommanderHistory[Player.UserId] = {Checked = false, n = 0, History = {}}
    end
    local Multi = String:split("|")
    for i = 1, #Multi do
        if i > 6 then
            break
        else
            local makeargs = Multi[i]:split(" ")
            local args = RemoveCMDSpacing(makeargs)
            local P = args[1] and Prefix(args[1])
            if P then
                if not AlreadyRan(args) then
                    local cExist = self:Run(Player, CleanString_P(args[1]:lower(), P):lower(), GType(P), args)
                    if not cExist then
                        remove(History, find(History, args[1]:lower()))
                    end
                end
            end
        end
    end
    if #History ~= 0 then
        GameLog(Player.Name .. " running command(s): " .. concat(History, ", "))
        for i = 1, #History do
            self:Commander(Player, History[i])
        end
    end
end

function ChatCommands:ConvertToPrefix(Type)
    return Type == "Server" and "g!" or "c!"
end

function ChatCommands:oppositeT(Type)
    local opposite_Type = Type == "Server" and "Client" or "Server"
    return opposite_Type, self:ConvertToPrefix(opposite_Type)
end

function ChatCommands:Run(Player, Command, Type, args)
    local Call = Commands[Type][Command]
    if Call then
        local Rank = Ranks:GetRank(Player.UserId)
        local CmdRank = Call[1]
        local CmdFunc = Call[2]
        if Rank >= CmdRank then
            if args[1]:lower() == self:ConvertToPrefix(Type) .. Command then
				remove(args, 1)
                CmdFunc(Player, args)
            end
        else
            NModule:Notify(Player, "No permission to access command: \""..Command.."\".")
        end
    else
        if Command ~= "" then
            local opposite_Type, argType = self:oppositeT(Type)
            if Commands[opposite_Type][Command] then
                NModule:Notify(Player, "\""..Command.."\" is a "..opposite_Type:lower().." command, Try using: "..argType)
            else
                NModule:Notify(Player, "Unknown Command: \""..Command.."\".")
            end
        end
    end
    return Call
end

return ChatCommands