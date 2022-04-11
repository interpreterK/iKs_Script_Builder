--[[
    Author: interpreterK (717072114)
    PlayerAdded.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local UserModule = obtain'UsersModule'
local ChatCommands = obtain'Chatted'
local NModule = obtain'Notify'
local Client = obtain'Client'
local BadgeService = obtain'BadgeService'
local ChatService = obtain'ChatService'
local SC = obtain'SendClient'

local PlayerAdded = {}
PlayerAdded.__index = PlayerAdded

local function WaitForChildOfClass(Parent, Class)
	local child = Parent:FindFirstChildOfClass(Class)
	while not child do
		child = Parent.ChildAdded:Wait()
	end
	return child
end

local function Prefix(String)
    local Str = String:sub(1,2):lower()
    local Got = Str == "g!" or Str == "c!"
    return Got and Str
end

function PlayerAdded:ChatCommands(Player)
    Player.Chatted:Connect(function(String)
        local P = Prefix(String)
        if P then
            ChatCommands:Compile(Player, String)
        end
    end)
end

function PlayerAdded:Initialize_ClientSide(Player)
    local CS = coroutine.wrap(function()
        local Loader = Client:Clone()
        Loader.Archivable = false
        Loader.Parent = WaitForChildOfClass(Player, "PlayerGui")
    end)
    return pcall(CS)
end

function PlayerAdded:Client(Player)
    local CS = self:Initialize_ClientSide(Player)
    while not CS do
        task.wait()
        CS = self:Initialize_ClientSide(Player)
    end
    self:ChatCommands(Player)
    BadgeService:AwardBeginnerBadge(Player)
end

function PlayerAdded.Added(Player)
    if Player.AccountAge < 59 and game.PrivateServerId == "" then
        Player:Kick("Your account must be 60 days or older to play in public servers.")
    end
    for Name, Reason in next, UserModule.Banned do
        if Player.Name == Name then
            Player:Kick(Reason)
        end
    end
    if UserModule.Slock then
        Player:Kick("This server is locked by the private server owner.")
    end
    for _, Admin in next, UserModule.Admins do
        if Player.UserId == Admin then
            NModule:Notify(Player, "You are ranked Admin, you have Admin benefits.")
        end
    end
    for _, Mod in next, UserModule.Mods do
        if Player.UserId == Mod then
            NModule:Notify(Player, "You are ranked Mod, you have Mod benefits.")
        end
    end
    if Player.UserId == game.CreatorId then
        NModule:Notify(Player, "You are ranked Owner, you have Owner benefits.")
        ChatService:NewCustom_Tag(Player, "🛠️", "red")
        ChatService:NewCustom_ChatColor(Player, "yellow")
        ChatService:NewCustom_NameColor(Player, "rainbow")
    elseif Player.UserId == 53267324 then -- MRRR MAD MANNNNNNNNNNNNNNNNN
        ChatService:NewCustom_Tag(Player, "🔨👑", "red")
        ChatService:NewCustom_ChatColor(Player, "shrek_green")
        ChatService:NewCustom_NameColor(Player, "shrek_green")
    end
    if game.PrivateServerId ~= "" and Player.UserId == game.PrivateServerOwnerId then
        NModule:Notify(Player, "You are the VIP server owner, you have VIP benefits.")
    end

    PlayerAdded:Client(Player)
    SC:SendAllClients("GameLog", Player.Name.." has joined the server.", 'Game_Player')
end

return PlayerAdded