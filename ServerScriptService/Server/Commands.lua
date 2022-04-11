--[[
    Author: interpreterK (717072114)
    Commands.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local Players = S.Players
local Lighting = S.Lighting
local SS = S.SoundService
local TS = S.TeleportService
local RS = S.RunService
local Tween = S.TweenService
local RunService = S.RunService
local MarketPS = S.MarketplaceService

local UserModule = obtain'UsersModule'
local Modules = obtain'Public'
local Ranks = obtain'GetRank'
local ChatService = obtain'ChatService'
local MPS = obtain'MPS'
local NModule = obtain'Notify'
local SC = obtain'SendClient'

local NPCS = {}
local AFK = {}
local CMDS = {
    Server = {},
    Client = {}
}
local Funcs = {dp = {ps = {}}}
Funcs.__index = Funcs

local ins = table.insert
local find = table.find
local remove = table.remove
local move = table.move
local resume = coroutine.resume
local create = coroutine.create
local wait = task.wait

local IsA = game.IsA
local ClearAllC = game.ClearAllChildren

local function makeCommand_Server(Name, Level, Alias, Func)
    if not CMDS.Server[Name] then
        CMDS.Server[Name] = {Level, Func}
        for _,v in next, Alias do
            if not CMDS.Server[v] then
                CMDS.Server[v] = {Level, Func}
            else
                print("Server command alias: \""..v.."\" for: \""..Name.."\" already exists.")
            end
        end
    else
        print("Server command: \""..Name.."\" already exists.")
    end
end

local function makeCommand_Client(Name, Level, Alias, Func)
    if not CMDS.Client[Name] then
        CMDS.Client[Name] = {Level, function(Player, ...)
            SC:SendClient(Player, "Command", Func, ...)
        end}
        for _,v in next, Alias do
            if not CMDS.Client[v] then
                CMDS.Client[v] = {Level, function(Player, ...)
                    SC:SendClient(Player, "Command", Func, ...)
                end}
            else
                print("Client command alias: \""..v.."\" for: \""..Name.."\" already exists.")
            end
        end
    else
        print("Client command: \""..Name.."\" already exists.")
    end
end

local function WaitForChildOfClass(Parent, Class)
	local child = Parent:FindFirstChildOfClass(Class)
	while not child do
		child = Parent.ChildAdded:Wait()
	end
	return child
end

function Funcs:ResetTerrainProps()
    local Terrain = Funcs:Terrain()
    if Terrain then
        Terrain.WaterColor = Color3.fromRGB(12, 84, 91)
        Terrain.WaterReflectance = 1
        Terrain.WaterTransparency = 0.3
        Terrain.WaterWaveSize = 0.15
        Terrain.WaterWaveSpeed = 10
    end
end

function Funcs:WorkspaceCleaner()
    local Terrain = Funcs:Terrain()
    local Instances = workspace:GetChildren()
    if Terrain then
        Terrain:Clear()
        Funcs:ResetTerrainProps()
        remove(Instances, find(Instances, Terrain))

        for _, Inst in next, Terrain:GetChildren() do
            if not Players:GetPlayerFromCharacter(Inst) then
                pcall(function()
                    ins(Instances, Inst)
                end)
            end
        end
    end
    for _, Inst in next, Instances do
        if not Players:GetPlayerFromCharacter(Inst) then
            pcall(function()
                Inst:Destroy()
            end)
        end
    end
end

function Funcs:GetRoot(Char)
    if Char then
        local Root = Char:FindFirstChild("HumanoidRootPart")
        if Root then
            return Root
        end
    end
    return nil
end

function Funcs:ToRoot(P1, P2)
    local Root1 = self:GetRoot(P1.Character)
    local Root2 = self:GetRoot(P2.Character)
    if Root1 then
        if Root2 then
            Root1.CFrame = Root2.CFrame
        else
            print("No root for:", P2.Name)
        end
    else
        print("No root for:", P1.Name)
    end
end

function Funcs:SetRoot(Char, CFrame)
    local Root = self:GetRoot(Char)
    if Root then
        Root.CFrame = CFrame
    else
        print("No root for:", Players:GetPlayerFromCharacter(Char).Name)
    end
end

function Funcs:WaitRoot(Char)
    return Char:WaitForChild("HumanoidRootPart", 60)
end

function Funcs:RandomButSelected(Player)
    local PlayersList = Players:GetPlayers()
    remove(PlayersList, find(PlayersList, Player))
    if #PlayersList == 0 then
        return Player
    end
    return PlayersList[math.random(1, #PlayersList)]
end

function Funcs:GetHumanoid(Char)
    if Char then
        return Char:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

function Funcs:GetPlayer(Player)
    return Players:FindFirstChild(Player)
end

function Funcs:FilterName(Player, String)
    local P = Players:GetPlayers()
    local S = String:lower()
    remove(P, find(P, Player))
    for _,v in next, P do
        if v.Name:lower():sub(1,#S) == S then
            return v
        end
    end
    return nil
end

function Funcs:AdvancedFilterName(Player, String, useAll)
    local T = {}
    local S = String:lower()
    if S == "all" then
        if useAll then
            return Players:GetPlayers()
        end
        local P = Players:GetPlayers()
        remove(P, find(P, Player))
        return P
    elseif S == "others" then
        local P = Players:GetPlayers()
        remove(P, find(P, Player))
        return P
    else
        local P = Players:GetPlayers()
        remove(P, find(P, Player))
        for _,v in next, P do
            if v.Name:lower():sub(1,#S) == S then
                ins(T, v)
            end
        end
    end
    return #T ~= 0 and T
end

function Funcs:SortFindEnum(String, Enum)
    for _,v in next, Enum:GetEnumItems() do
        if v.Name:sub(1,#String):lower() == String:lower() then
            return v
        end
    end
    return nil
end

function Funcs:SavePos_db(Player)
    if Player.Character then
        local Root = self:GetRoot(Player.Character)
        if Root then
            self.dp.ps[Player.UserId] = Root.CFrame
        end
    end
end

function Funcs:GetPos_db(Player)
    return self.dp.ps[Player.UserId]
end

function Funcs:RemPos_db(Player)
    if self:GetPos_db(Player) then
        self.dp.ps[Player.Name] = nil
    end
end

function Funcs:cVipBan_db(Player)
    return UserModule.Banned[Player.Name]
end

function Funcs:VipBan_db(Player, Reason)
    UserModule.Banned[Player.Name] = Reason
end

function Funcs:rVipBan_db(Name)
    UserModule.Banned[Name] = nil
end

function Funcs:FilterTable(Array, String)
    local S = String:lower()
    for i in next, Array do
        if i:lower():sub(1,#S) == S then
            return i
        end
    end
    return nil
end

function Funcs:ConString(String, useTarget, args)
    local s = String
    local a = {}
    if useTarget then
        if args[2] ~= nil and args[2]:gsub(" ", "") ~= "" then
            move(args, 2, #args, 1, a)
            s = s..": "..table.concat(a, " ")
        end
    else
        if args[1] ~= nil and args[1]:gsub(" ", "") ~= "" then
            move(args, 1, #args, 1, a)
            s = s..": "..table.concat(a, " ")
        end
    end
    return s
end

function Funcs:Terrain()
    return workspace:FindFirstChildOfClass("Terrain")
end

function Funcs:CHMFUI(Player)
    local b, M = pcall(Players.CreateHumanoidModelFromUserId, Players, Player.UserId)
    if not b then
        warn(M)
    end
    return M
end

function Funcs:CreatePlayerModel(Description, rigType)
    local b, M = pcall(Players.CreateHumanoidModelFromDescription, Players, Description, rigType)
    if not b then
        warn(M)
    end
    return M
end

function Funcs:CurrentMapOrigins()
    for _,v in next, workspace:GetDescendants() do
        if IsA(v, "SpawnLocation") then
            return v.Position
        end
    end
    return Vector3.new(0, 100, 0)
end

function Funcs:GetGame()
    local Services = game:GetChildren()
    remove(Services, find(Services, S.Players))
    remove(Services, find(Services, S.Chat))
    remove(Services, find(Services, S.Stats))
    remove(Services, find(Services, S.NetworkServer))
    remove(Services, find(Services, S.RobloxReplicatedStorage))
    remove(Services, find(Services, S.ScriptContext))
    ins(Services, S.StarterPlayer:FindFirstChildOfClass("StarterCharacterScripts"))
    return Services
end

local Ignore, Services, Etc = {}, {}
resume(create(function()
    Ignore = {
        [1] = S.ServerScriptService:WaitForChild("ChatServiceRunner"),
        [2] = S.ReplicatedStorage:WaitForChild("Shared"),
        [3] = S.ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
    }
    Services = {
        S.ReplicatedStorage,
        S.SoundService,
        S.ServerStorage,
        S.Teams,
        S.StarterPack,
        S.StarterGui,
        S.Lighting,
        S.ServerScriptService,
        S.ReplicatedFirst
    }
    Etc = WaitForChildOfClass(S.StarterPlayer, "StarterCharacterScripts")
end))
makeCommand_Server("wipegame", Ranks.global, {}, function()
    local Terrain = Funcs:Terrain()
    for _, serv in next, Services do
        for _, v in next, serv:GetChildren() do
            if serv == S.ServerScriptService then
                if Ignore[1] and v ~= Ignore[1]  then
                    v:Destroy()
                end
            elseif serv == S.ReplicatedStorage then
                if Ignore[2] and Ignore[3] and v ~= Ignore[2] and v ~= Ignore[3] then
                    v:Destroy()
                end
            else
                if not IsA(v, "Terrain") then
                    v:Destroy()
                end
            end
        end
    end
    for _,v in next, Etc:GetChildren() do
        v:Destroy()
    end
    if Terrain then
        Terrain:Clear()
        Funcs:ResetTerrainProps()
    end
    Funcs:WorkspaceCleaner()
    Players.RespawnTime = 3
end)

makeCommand_Server("cmds", Ranks.global, {"commands"}, function(Player)
    SC:SendClient(Player, "Command", "Commands")
end)
makeCommand_Client("cmds", Ranks.global, {"commands"}, "Commands")

makeCommand_Server("baseplate", Ranks.global, {"b"}, function()
    Funcs:WorkspaceCleaner()
    local CFrameMap = {
        CFrame.new(-0.0192869995, 3, -0.00707999989),
        CFrame.new(-0.0192869995, 3, -2047.99146),
        CFrame.new(-2047.98059, 3, -2047.99146),
        CFrame.new(-2047.98059, 3, 2047.99133),
        CFrame.new(-0.0192869995, 3, 2047.99133),
        CFrame.new(2047.98071, 3, -2047.99146),
        CFrame.new(2047.98071, 3, 2047.99133),
        CFrame.new(2047.98071, 3, 0.0520559996),
        CFrame.new(-2047.92688, 3, 0.0520559996)
    }
    local function CreateBSpart(Model)
        local Part = Instance.new("Part")
        Part.Name = "Grass"
        Part.Material = Enum.Material.Grass
        Part.BrickColor = BrickColor.new("Sea green")
        Part.Locked = true
        Part.Anchored = true
        Part.CanTouch = false
        Part.Size = Vector3.new(2048, 20, 2048)
        Part.Parent = Model
        return Part
    end
    for i = 1, #CFrameMap do
        CreateBSpart(workspace).CFrame = CFrameMap[i]
    end
end)

makeCommand_Server("baseplate2", Ranks.global, {"b2"}, function()
    Funcs:WorkspaceCleaner()
    local CFrameMap = {
        CFrame.new(-0.0192869995, 3, -0.00707999989),
        CFrame.new(-0.0192869995, 3, -2047.99146),
        CFrame.new(-2047.98059, 3, -2047.99146),
        CFrame.new(-2047.98059, 3, 2047.99133),
        CFrame.new(-0.0192869995, 3, 2047.99133),
        CFrame.new(2047.98071, 3, -2047.99146),
        CFrame.new(2047.98071, 3, 2047.99133),
        CFrame.new(2047.98071, 3, 0.0520559996),
        CFrame.new(-2047.92688, 3, 0.0520559996)
    }
    local function CreateBSpart(Model)
        local Part = Instance.new("Part")
        Part.Name = "Grass"
        Part.Material = Enum.Material.Grass
        Part.BrickColor = BrickColor.new("Mid gray")
        Part.Locked = true
        Part.Anchored = true
        Part.CanTouch = false
        Part.Size = Vector3.new(2048, 20, 2048)
        Part.Parent = Model
        return Part
    end
    for i = 1, #CFrameMap do
        CreateBSpart(workspace).CFrame = CFrameMap[i]
    end
    local T = Funcs:Terrain()
    if T then
        local StormySnow = Instance.new("Clouds")
        StormySnow.Cover = 0.75
        StormySnow.Density = 1
        StormySnow.Parent = T
    end
end)

makeCommand_Server("npc", Ranks.global, {"dummy","d"}, function(Player, args)
    local Amount = math.min(tonumber(args[1]) or 1, 10)
    local Types = {
        Enum.HumanoidRigType.R6.Name,
        Enum.HumanoidRigType.R15.Name
    }
    local function SpawnNpc()
        local b, Func = pcall(require, Modules.Public.NPC)
        local Model
        if b then
            Model = Func(Types[math.random(1, 2)])
            if #NPCS >= 50 then
                for i = 1, 10 do
                    NPCS[i]:Destroy()
                    NPCS[i] = nil
                end
            end
            local Humanoid = WaitForChildOfClass(Model, "Humanoid")
            if Humanoid then
                Humanoid.Died:Connect(function()
                    wait(5)
                    Model:Destroy()
                    remove(NPCS, find(NPCS, Model))
                end)
            end
        else
            warn(Func)
        end
        return Model
    end

    for i = 1, Amount do
        local Npc = SpawnNpc()
        
        if Npc then
            ins(NPCS, Npc)
            Npc.Parent = workspace
            local R = Funcs:GetRoot(Player.Character)
            local NR = Funcs:GetRoot(Npc)
            if R then
                NR.CFrame = R.CFrame
            else
                Npc:MoveTo(Funcs:CurrentMapOrigins())
            end
        end
    end
end)

makeCommand_Server("killnpcs", Ranks.global, {"knpcs","killdummies","kdummies"}, function()
    for _,v in next, NPCS do
        local Hum = Funcs:GetHumanoid(v)
        if Hum then
            Hum.Health = 0
        end
    end
end)

makeCommand_Server("removenpcs", Ranks.global, {"rnpcs","removedummies","rdummies"}, function()
    for i,v in next, NPCS do
        v:Destroy()
        NPCS[i] = nil
    end
end)

makeCommand_Server("bringnpcs", Ranks.global, {"bnpcs"}, function(Player)
    local Char = Player.Character
    local Root = Funcs:GetRoot(Char)
    for _,v in next, NPCS do
        if Root then
            v:MoveTo(Root.Position)
        else
            v:MoveTo(Vector3.new(0, 20, 0))
        end
    end
end)

makeCommand_Server("kick", Ranks.vip, {}, function(Player, args)
    local Target = args[1]
    local Reason = Funcs:ConString("You were kicked from this server", true, args)
    if Target then
        local F = Funcs:AdvancedFilterName(Player, Target, false)
        if F then
            for _,v in next, F do
                v:Kick(Reason)
            end
        end
    end
end)

makeCommand_Server("ban", Ranks.vip, {}, function(Player, args)
    local Target = args[1]
    local Reason = Funcs:ConString("You are banned from this server", true, args)
    if Target then
        local F = Funcs:FilterName(Player, Target)
        if F and F ~= Player then
            Funcs:VipBan_db(F, Reason)
            NModule:Notify(Player, "Banned: "..F.Name)
            F:Kick(Reason)
        end
    end
end)

-- do ban tomorrow (9/1/2021)
makeCommand_Server("unban", Ranks.vip, {}, function(Player, args)
    local Target = args[1]
    if Target then
        local Name = Funcs:FilterTable(UserModule.Banned, Target)
        if Name then
            Funcs:rVipBan_db(Name)
            NModule:Notify(Player, "Unbanned: "..Name)
        end
    end
end)

makeCommand_Server("slock", Ranks.vip, {"serverlock"}, function(Player)
    UserModule.Slock = not UserModule.Slock
    if UserModule.Slock then
        NModule:Notify(Player, "Slock: ON")
    else
        NModule:Notify(Player, "Slock: OFF")
    end
end)

makeCommand_Server("bring", Ranks.vip, {}, function(Player, args)
    local Target = args[1]
    if Target then
        local F = Funcs:AdvancedFilterName(Player, Target, false)
        if F then
            for _,v in next, F do
                Funcs:ToRoot(v, Player)
            end
        end
    end
end)

makeCommand_Server("lighting", Ranks.global, {"l"}, function()
    Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    Lighting.Brightness = 3
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    Lighting.EnvironmentDiffuseScale = 1
    Lighting.EnvironmentSpecularScale = 1
    Lighting.GlobalShadows = true
    Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    Lighting.ShadowSoftness = 0.5
    Lighting.ClockTime = 14
    Lighting.GeographicLatitude = 41
    Lighting.Name = "Lighting"
    Lighting.TimeOfDay = "14:00:00"
    Lighting.FogColor = Color3.fromRGB(191, 191, 191)
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    Lighting.ShadowColor = Color3.fromRGB(178, 178, 183)
    Lighting.Archivable = true
    Lighting.ExposureCompensation = 0
    pcall(ClearAllC, Lighting)
end)

makeCommand_Server("night", Ranks.global, {}, function()
    local info = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local Anim = Tween:Create(Lighting, info, {ClockTime = 0})
    Anim:Play()
end)

makeCommand_Server("day", Ranks.global, {}, function()
    local info = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local Anim = Tween:Create(Lighting, info, {ClockTime = 14})
    Anim:Play()
end)

makeCommand_Server("clocktime", Ranks.global, {"time"}, function(Player, args)
    local Time = tonumber(args[1])
    if Time then
        local info = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local Anim = Tween:Create(Lighting, info, {ClockTime = math.max(0, math.min(Time, 23.99))})
        Anim:Play()
    else
        if Lighting.ClockTime ~= 14 then
            local info = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local Anim = Tween:Create(Lighting, info, {ClockTime = 14})
            Anim:Play()
        end
    end
end)

makeCommand_Server("visuals", Ranks.global, {"graphics"}, function()
    local T = Funcs:Terrain()
    local Atmosphere = Instance.new("Atmosphere")
    local Sky = Instance.new("Sky")
    local Bloom = Instance.new("BloomEffect")
    local DepthOfField = Instance.new("DepthOfFieldEffect")
    local SunRay = Instance.new("SunRaysEffect")
    Atmosphere.Density = 0.269
    Atmosphere.Offset = 0.25
    Atmosphere.Color = Color3.fromRGB(199, 199, 199)
    Atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    Atmosphere.Glare = 0
    Atmosphere.Haze = 0
    Sky.MoonTextureId = "rbxassetid://6444320592"
    Sky.SkyboxBk = "rbxassetid://6444884337"
    Sky.SkyboxDn = "rbxassetid://6444884785"
    Sky.SkyboxFt = "rbxassetid://6444884337"
    Sky.SkyboxLf = "rbxassetid://6444884337"
    Sky.SkyboxRt = "rbxassetid://6444884337"
    Sky.SkyboxUp = "rbxassetid://6412503613"
    Sky.SunTextureId = "rbxassetid://6196665106"
    Bloom.Intensity = 1
    Bloom.Size = 24
    Bloom.Threshold = 2
    DepthOfField.FarIntensity = 0.1
    DepthOfField.FocusDistance = 0.05
    DepthOfField.InFocusRadius = 30
    DepthOfField.NearIntensity = 0.75
    SunRay.Intensity = 0.1
    SunRay.Spread = 1
    Atmosphere.Parent = Lighting
    Sky.Parent = Lighting
    Bloom.Parent = Lighting
    DepthOfField.Parent = Lighting
    SunRay.Parent = Lighting
    if T then
        local Clouds = Instance.new("Clouds")
        Clouds.Cover = 0.66
        Clouds.Density = 0.1
        Clouds.Parent = T
    end
end)

makeCommand_Server("clouds", Ranks.global, {}, function()
    local T = Funcs:Terrain()
    if T then
        local Clouds = Instance.new("Clouds")
        Clouds.Cover = 0.66
        Clouds.Density = 0.1
        Clouds.Parent = T
    end
end)

makeCommand_Server("novisuals", Ranks.global, {"nographics"}, function()
    local T = Funcs:Terrain()
    local Graphics = {"Sky","Clouds","Atmosphere","BloomEffect","DepthOfFieldEffect","SunRaysEffect","ColorCorrectionEffect","BlurEffect"}
    for _,v in next, Lighting:GetChildren() do
        for _,v2 in next, Graphics do
            if v.ClassName == v2 then
                v:Destroy()
            end
        end
    end
    if T then
        for _,v in next, T:GetChildren() do
            if IsA(v, "Clouds") then
                v:Destroy()
            end
        end
    end
end)

makeCommand_Server("noclouds", Ranks.global, {"dclouds"}, function()
    local T = Funcs:Terrain()
    if T then
        for _,v in next, T:GetChildren() do
            if IsA(v, "Clouds") then
                v:Destroy()
            end
        end
    end
end)

makeCommand_Server("dex", Ranks.global, {"explorer","dex_server"}, function(Player)
    local b, Call = pcall(require, Modules.Public.Explorer)
    if b then
        Call(Player.Name)
    else
        warn(Call)
    end
end)

makeCommand_Server("dex_client", Ranks.global, {}, function(Player)
    local b, Call = pcall(require, Modules.Public.Explorer_Client) --https://cdn.wearedevs.net/scripts/Dex%20Explorer%20V2.txt
    if b then
        Call(Player)
    else
        warn(Call)
    end
end)

makeCommand_Server("respawn", Ranks.global, {"re","r"}, function(Player)
    Player:LoadCharacter()
end)

makeCommand_Server("reset", Ranks.global, {"res"}, function(Player)
    local Char = Player.Character
    local Hum = Funcs:GetHumanoid(Char)
    if Char and Hum then
        Hum.Health = 0
    end
end)

makeCommand_Server("refresh", Ranks.global, {"ref"}, function(Player)
    local Char = Player.Character
    local Saved
    if Char then
        local Root = Funcs:GetRoot(Char)
        Saved = Root and Root.CFrame

        resume(create(function()
            Player.CharacterAdded:Wait()

            local NewChar = Player.Character
            repeat wait() until NewChar.PrimaryPart
            NewChar:SetPrimaryPartCFrame(Saved)
        end))
    end
    Player:LoadCharacter()
end)

makeCommand_Server("startserver", Ranks.vip, {"newserver","privateserver"}, function(Player)
    local Reserve = TS:ReserveServer(game.PlaceId)
    TS:TeleportToPrivateServer(game.PlaceId, Reserve, Players:GetPlayers())
    NModule:Notify(Player, "Starting a new server...")
end)

makeCommand_Server("gm_flatgrass", Ranks.global, {"flatgrass"}, function()
    local b, Call = pcall(require, Modules.Public.gm_flatgrass)
    if b then
        Funcs:WorkspaceCleaner()
        Call()
    else
        warn(Call)
    end
end)

makeCommand_Server("happyhome", Ranks.global, {}, function()
    local b, Call = pcall(require, Modules.Public.happyhome)
    if b then
        Funcs:WorkspaceCleaner()
        Call()
    else
        warn(Call)
    end
end)

makeCommand_Server("studiobaseplate", Ranks.global, {"studiobaseplate_new"}, function()
    Funcs:WorkspaceCleaner()
    
    local Part0 = Instance.new("Part")
    local Texture1 = Instance.new("Texture")
    local SpawnLocation0 = Instance.new("SpawnLocation")
    local Decal1 = Instance.new("Decal")
    Part0.Name = "Baseplate"
    Part0.Parent = workspace
    Part0.CFrame = CFrame.new(0, -8, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    Part0.Position = Vector3.new(0, -8, 0)
    Part0.Color = Color3.new(0.356863, 0.356863, 0.356863)
    Part0.Size = Vector3.new(2048, 16, 2048)
    Part0.Anchored = true
    Part0.BottomSurface = Enum.SurfaceType.Smooth
    Part0.BrickColor = BrickColor.new("Dark grey metallic")
    Part0.Locked = true
    Part0.TopSurface = Enum.SurfaceType.Smooth
    Texture1.Parent = Part0
    Texture1.Texture = "rbxassetid://6372755229"
    Texture1.Transparency = 0.8
    Texture1.Face = Enum.NormalId.Top
    Texture1.Color3 = Color3.new(0, 0, 0)
    Texture1.StudsPerTileU = 8
    Texture1.StudsPerTileV = 8
    SpawnLocation0.Parent = workspace
    SpawnLocation0.CFrame = CFrame.new(0, 0.5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    SpawnLocation0.Position = Vector3.new(0, 0.5, 0)
    SpawnLocation0.Size = Vector3.new(12, 1, 12)
    SpawnLocation0.Anchored = true
    SpawnLocation0.BottomSurface = Enum.SurfaceType.Smooth
    SpawnLocation0.TopSurface = Enum.SurfaceType.Smooth
    SpawnLocation0.Duration = 0
    Decal1.Parent = SpawnLocation0
    Decal1.Texture = "rbxasset://textures/SpawnLocation.png"
    Decal1.Face = Enum.NormalId.Top
end)

makeCommand_Server("studiobaseplate_classic", Ranks.global, {"studiobaseplate_old"}, function()
    Funcs:WorkspaceCleaner()

    local Part0 = Instance.new("Part")
    Part0.Name = "Baseplate"
    Part0.Parent = workspace
    Part0.CFrame = CFrame.new(0, -10, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    Part0.Position = Vector3.new(0, -10, 0)
    Part0.Color = Color3.new(0.388235, 0.372549, 0.384314)
    Part0.Size = Vector3.new(512, 20, 512)
    Part0.Anchored = true
    Part0.BrickColor = BrickColor.new("Dark stone grey")
    Part0.Locked = true
end)

makeCommand_Server("cs", Ranks.global, {"clearscripts"}, function(Player)
    local function Wipe(Class)
        if not Class then return end
        for _,v in next, Class:GetDescendants() do
            if IsA(v, "Script") then
                v.Disabled = true
                v:Destroy()
            end
        end
    end

    Wipe(Player.Character)
    Wipe(Player:FindFirstChildOfClass("Backpack"))
    Wipe(Player:FindFirstChildOfClass("PlayerGui"))
end)

makeCommand_Server("stopsounds", Ranks.global, {"sounds"}, function()
    for _,v in next, game:GetDescendants() do
        pcall(function()
            if IsA(v, "Sound") then
                v:Stop()
            end
        end)
    end
end)

makeCommand_Server("clearsounds", Ranks.global, {"destroysounds","dsounds"}, function()
    for _,v in next, game:GetDescendants() do
        pcall(function()
            if IsA(v, "Sound") then
                v:Destroy()
            end
        end)
    end
end)

makeCommand_Server("dump_sounds", Ranks.global, {}, function(Player)
    local got = 0
    local fetched = {}
    for _,v in next, game:GetDescendants() do
        pcall(function()
            if IsA(v, "Sound") then
                got += 1
                table.insert(fetched, got .. ":"..(" ".. v.Name .. " | ".. v.SoundId .. " | ".. v:GetFullName()))
            end
        end)
    end
    SC:SendClient(Player, "Prompt", table.concat(fetched, "\n"))
end)
makeCommand_Client("dump_sounds", Ranks.global, {}, "dump_sounds")

makeCommand_Server("soundservice", Ranks.global, {"ss"}, function()
    SS.AmbientReverb = Enum.ReverbType.NoReverb
    SS.DistanceFactor = 3.33
    SS.DopplerScale = 1
    SS.Name = "SoundService"
    SS.RespectFilteringEnabled = true
    SS.RolloffScale = 1
    SS.Archivable = true
end)

makeCommand_Server("terrain", Ranks.global, {"t"}, function()
    local Terrain = Funcs:Terrain()
    if Terrain then
        Terrain:Clear()
    end
    Funcs:ResetTerrainProps()
end)

makeCommand_Server("btools", Ranks.global, {"f3x"}, function(Player)
    local function f3xAsset(Parent)
        local b, Call = pcall(require, Modules.Public.f3x)
        if b then
            Call(Parent)
        else
            warn(Call)
        end
    end
    
    local BP = Player:FindFirstChildOfClass("Backpack")
    local SG = Player:FindFirstChildOfClass("StarterGear")
    if BP then
        f3xAsset(BP)
    end
    if SG then
        f3xAsset(SG)
    end
end)

makeCommand_Server("ctools", Ranks.global, {"cleartools","tools"}, function(Player)
    local BP = Player:FindFirstChildOfClass("Backpack")
    local SG = Player:FindFirstChildOfClass("StarterGear")
    if BP then
        for _,v in next, BP:GetChildren() do
            if IsA(v, "Tool") then
                v:Destroy()
            end
        end
    end
    if SG then
        for _,v in next, SG:GetChildren() do
            if IsA(v, "Tool") then
                v:Destroy()
            end
        end
    end
end)

makeCommand_Server("goto", Ranks.global, {}, function(Player, args)
    local Target = args[1]
    local Character = Player.Character
    if Target then
        local Closest = Funcs:FilterName(Player, Target)
        if Closest then
            local Char = Closest.Character
            if Char then
                local Root = Funcs:GetRoot(Char)
                Funcs:SetRoot(Character, Root.CFrame)
            end
        end
    else
        local Random = Funcs:RandomButSelected(Player)
        local Char = Random.Character
        if Char then
            local Root = Funcs:GetRoot(Char)
            Funcs:SetRoot(Character, Root.CFrame)
        end
    end
end)

makeCommand_Server("ws", Ranks.global, {"walkspeed","speed"}, function(Player, args)
    local val = args[1]
    local Char = Player.Character
    local Hum = Funcs:GetHumanoid(Char)
    if val and tonumber(val) then
        if Hum then
            Hum.WalkSpeed = val
        end
    else
        if Hum then
            Hum.WalkSpeed = 16
        end
    end
end)

makeCommand_Server("jp", Ranks.global, {"jh","jumppower","jumpheight"}, function(Player, args)
    local val = args[1]
    local Char = Player.Character
    local Hum = Funcs:GetHumanoid(Char)
    if val and tonumber(val) then
        if Hum then
            Hum.JumpPower = val
            Hum.JumpHeight = val
        end
    else
        if Hum then
            Hum.JumpPower = 50
            Hum.JumpHeight = 7.2
        end
    end
end)

makeCommand_Server("gravity", Ranks.global, {}, function()
    workspace.Gravity = 196.2
end)

makeCommand_Server("noob", Ranks.global, {"noobify"}, function(Player)
    local Char = Player.Character
    local Hum = Funcs:GetHumanoid(Char)
    if Hum then
        local Colors = Char:FindFirstChildOfClass("BodyColors")
        if Colors then
            Colors:Destroy()
        end
        local NoobOutfit = Instance.new("BodyColors")
        NoobOutfit.HeadColor3 = Color3.fromRGB(245, 205, 48)
        NoobOutfit.LeftArmColor3 = Color3.fromRGB(245, 205, 48)
        NoobOutfit.LeftLegColor3 = Color3.fromRGB(164, 189, 71)
        NoobOutfit.RightArmColor3 = Color3.fromRGB(245, 205, 48)
        NoobOutfit.RightLegColor3 = Color3.fromRGB(164, 189, 71)
        NoobOutfit.TorsoColor3 = Color3.fromRGB(13, 105, 172)
        NoobOutfit.Parent = Char

        Hum:RemoveAccessories()
        for _,v in next, Char:GetChildren() do
            if IsA(v, "Clothing") then
                v:Destroy()
            end
        end
        local face = Char.Head:FindFirstChild("face")
        if face then
            face.Texture = "rbxasset://textures/face.png"
        end
    end
end)

makeCommand_Server("r6", Ranks.global, {}, function(Player)
    local Character = Player.Character
    if Character then
        local Humanoid = Funcs:GetHumanoid(Character)
        local Root = Funcs:GetRoot(Character)
       
        if Humanoid and Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
            if Root then
                local Old = Root.CFrame
                local Description = Humanoid:GetAppliedDescription() or Funcs:CHMFUI(Player)
                local Model = Funcs:CreatePlayerModel(Description, Enum.HumanoidRigType.R6)

                Character:Destroy()
                Model.Name = Player.Name
                Player.Character = Model
                Model.Parent = workspace

                repeat wait() until Model.PrimaryPart
                Model:SetPrimaryPartCFrame(Old)
            end
        end
    end
end)

makeCommand_Server("r15", Ranks.global, {}, function(Player)
    local Character = Player.Character
    if Character then
        local Humanoid = Funcs:GetHumanoid(Character)
        local Root = Funcs:GetRoot(Character)
       
        if Humanoid and Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
            if Root then
                local Old = Root.CFrame
                local Description = Humanoid:GetAppliedDescription() or Funcs:CHMFUI(Player)
                local Model = Funcs:CreatePlayerModel(Description, Enum.HumanoidRigType.R15)

                Character:Destroy()
                Model.Name = Player.Name
                Player.Character = Model
                Model.Parent = workspace

                repeat wait() until Model.PrimaryPart
                Model:SetPrimaryPartCFrame(Old)
            end
        end
    end
end)

makeCommand_Server("rejoin", Ranks.global, {"rj","rej"}, function(Player)
    if game.PrivateServerId == "" then
        if #Players:GetPlayers() > 1 then
            if #Players:GetPlayers() ~= Players.MaxPlayers then
                TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
            else
                NModule:Notify(Player, "Unable to rejoin a full server.")
            end
        else
            NModule:Notify(Player, "Unable to rejoin the server with only 1 player.")
        end
    else
        NModule:Notify(Player, "Unable to rejoin from a private server.")
    end
end)

makeCommand_Server("vanquish", Ranks.admin, {}, function(Player, args)
    local Target = args[1]
    if game.PlaceId == 7209961548 then --dev game
        if Target then
            local F = Funcs:AdvancedFilterName(Player, Target, true)
            if F then
                for _,v in next, F do
                    TS:Teleport(6883421860, v)
                end
            end
        end
    end
end)

makeCommand_Server("unlockws", Ranks.global, {}, function()
    for _,v in next, workspace:GetDescendants() do
        if IsA(v, "BasePart") then
            v.Locked = false
        end
    end
end)

makeCommand_Server("tag", Ranks.global, {}, function(Player, args)
    local Text = args[1]
    local Color = args[2]
    if MPS:UserHasTagsPass(Player) then
        if Text then
            if Color then
                ChatService:NewCustom_Tag(Player, Text, Color:lower())
            else
                ChatService:NewCustom_Tag(Player, Text, "white")
            end
        else
            ChatService:RemoveData(Player, "Tags")
        end
    else
        MPS:PromptTagsPurchase(Player)
    end
end)

makeCommand_Server("namecolor", Ranks.global, {}, function(Player, args)
    local Color = args[1]
    if MPS:UserHasTagsPass(Player) then
        if Color then
            ChatService:NewCustom_NameColor(Player, Color:lower())
        else
            ChatService:RemoveData(Player, "NameColor")
        end
    else
        MPS:PromptTagsPurchase(Player)
    end
end)

makeCommand_Server("chatcolor", Ranks.global, {}, function(Player, args)
    local Color = args[1]
    if MPS:UserHasTagsPass(Player) then
        if Color then
            ChatService:NewCustom_ChatColor(Player, Color:lower())
        else
            ChatService:RemoveData(Player, "ChatColor")
        end
    else
        MPS:PromptTagsPurchase(Player)
    end
end)

makeCommand_Server("kill_humanoids", Ranks.global, {"k_hs"}, function()
    for _,v in next, workspace:GetDescendants() do
        if IsA(v, "Humanoid") and not Players:GetPlayerFromCharacter(v.Parent) then
            v.Health = 0
        end
    end
end)

makeCommand_Server("remove_humanoids", Ranks.global, {"r_hs"}, function()
    for _,v in next, workspace:GetDescendants() do
        if IsA(v, "Humanoid") and not Players:GetPlayerFromCharacter(v.Parent) then
            v:Destroy()
        end
    end
end)

makeCommand_Server("remove_humanoid_models", Ranks.global, {"r_h_ms"}, function()
    for _,v in next, workspace:GetDescendants() do
        if IsA(v, "Humanoid") and not Players:GetPlayerFromCharacter(v.Parent) then
            v.Parent:Destroy()
        end
    end
end)

makeCommand_Server("shutdown", Ranks.vip, {}, function(Player, args)
    local Message = Funcs:ConString("[Shutdown]", false, args)
    Players.PlayerAdded:Connect(function(v)
        v:Kick(Message)
    end)
    for _,v in next, Players:GetPlayers() do
        v:Kick(Message)
    end
end)

makeCommand_Server("view", Ranks.global, {"spectate"}, function(Player, args)
    local Target = args[1]
    if Target then
        local Closest = Funcs:FilterName(Player, Target)
        if Closest then
            SC:SendClient(Player, "Command", "spectate", Closest)
        end
    else
        local Random = Funcs:RandomButSelected(Player)
        SC:SendClient(Player, "Command", "spectate", Random)
    end
end)

makeCommand_Server("unview", Ranks.global, {"unspectate"}, function(Player)
    SC:SendClient(Player, "Command", "spectate", Player)
end)

makeCommand_Server("afk", Ranks.global, {"void"}, function(Player)
    if not find(AFK, Player) then
        ins(AFK, Player)
        Funcs:SavePos_db(Player)

        local function away()
            pcall(function()
                Player.Character:MoveTo(Vector3.new(9e4, 9e4, 9e4))
                Funcs:GetRoot(Player.Character).Anchored = true
            end)
        end
        away()
        local Connection
        Connection = RunService.Heartbeat:Connect(function()
            if find(AFK, Player) then
                away()
            else
                Connection:Disconnect()
            end
        end)
    end
end)

makeCommand_Server("unafk", Ranks.global, {"unvoid"}, function(Player)
    if find(AFK, Player) then
        remove(AFK, find(AFK, Player))
        resume(create(function()
            Player.CharacterAdded:Wait()

            local pos = Funcs:GetPos_db(Player)
            if pos then
                local Char = Player.Character
                repeat wait() until Char.PrimaryPart
                Char:SetPrimaryPartCFrame(pos)
                Funcs:RemPos_db(Player)
            end
        end))
        RS.Heartbeat:Wait()
        Player:LoadCharacter()
    end
end)

makeCommand_Server("ping", Ranks.global, {}, function(Player)
    SC:SendClient(Player, "Command", "ping")
end)
makeCommand_Client("ping", Ranks.global, {}, "ping")

makeCommand_Server("city", Ranks.global, {"studio_city"}, function()
    local b, Call = pcall(require, Modules.Public.city)
    if b then
        Funcs:WorkspaceCleaner()
        Call()
    else
        warn(Call)
    end
end)

makeCommand_Server("suburban", Ranks.global, {"studio_suburban"}, function()
    local b, Call = pcall(require, Modules.Public.suburban)
    if b then
        Funcs:WorkspaceCleaner()
        Call()
    else
        warn(Call)
    end
end)

makeCommand_Server("clear_globals", Ranks.global, {}, function(Player)
    local c = 0
    for key in next, _G do
        if _G[key] ~= obtain then
            _G[key] = nil
            c += 1
        end
    end
    for key in next, shared do
        shared[key] = nil
        c += 1
    end
    NModule:Notify(Player, "Cleared "..c.." server global(s).")
end)
makeCommand_Client("clear_globals", Ranks.global, {}, "clear_globals")

makeCommand_Server("dump_globals", Ranks.global, {}, function(Player)
    local c = 0
    local fetched = {}
    for key, value in next, _G do
        if _G[key] ~= obtain then
            c += 1
            local isT = (type(value) == "table" and "{"..table.concat(value, ", ").."}("..#value..") ("..tostring(value)..") ["..type(value).."]" or tostring(value).." ["..type(value).."]")
            local Mb = (c..": type: _G | key: "..key.." | value: "..isT)
            table.insert(fetched, Mb)
        end
    end
    for key, value in next, shared do
        c += 1
        local isT = (type(value) == "table" and "{"..table.concat(value, ", ").."}("..#value..") ("..tostring(value)..") ["..type(value).."]" or tostring(value).." ["..type(value).."]")
        local Mb = (c..": type: shared | key: "..key.." | value = "..isT)
        table.insert(fetched, Mb)
    end
    SC:SendClient(Player, "Prompt", table.concat(fetched, "\n"))
end)
makeCommand_Client("dump_globals", Ranks.global, {}, "dump_globals")

makeCommand_Server("support", Ranks.global, {}, function(Player)
    if Player.MembershipType == Enum.MembershipType.Premium then
        NModule:Notify(Player, "You are already supporting the game just by having premium.")
    else
        MarketPS:PromptPremiumPurchase(Player)
        NModule:Notify(Player, "Having premium will not only support the game but will benefit you as well outside of the game.")
    end
end)
makeCommand_Client("support", Ranks.global, {}, "support")

makeCommand_Client("clearlocalscripts", Ranks.global, {"stoplocalscripts", "cls", "sls"}, "cls")

makeCommand_Client("ui", Ranks.global, {}, "ui")

makeCommand_Client("uis", Ranks.global, {"custom_uis"}, "uis")

makeCommand_Client("duis", Ranks.global, {}, "duis")

makeCommand_Client("sb_ui", Ranks.global, {"sbui"}, "sb_ui")

makeCommand_Client("keybind", Ranks.global, {"bind"}, "keybind")

makeCommand_Client("refresh", Ranks.global, {"refresh_sb_ui"}, "refresh")

makeCommand_Client("camera", Ranks.global, {}, "camera")

makeCommand_Client("freecam", Ranks.global, {}, "freecam")

makeCommand_Client("cursor", Ranks.global, {"pointer","mouse"}, "cursor")

makeCommand_Client("exe", Ranks.global, {"executor"}, "executor")

makeCommand_Client("coreguis", Ranks.global, {}, "coreguis")

makeCommand_Client("change_log", Ranks.global, {"change_logs","changes","updates"}, "change_log")

return CMDS