--[[
    Author: interpreterK (717072114)
    shared.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local Players = S.Players
local Storage = S.ReplicatedStorage
local UIS = S.UserInputService
local SG = S.StarterGui
local MPS = S.MarketplaceService

local Player = Players.LocalPlayer

local UiInit = obtain'UiInit'
local Freecam = obtain'Freecam'

local Shared = {}
local function ShareAction(Name, Function)
    Shared[Name] = Function
end

local function DefineRobloxChat()
    local PlrGui = Player:FindFirstChildOfClass("PlayerGui")
    local Gui
    if PlrGui then
        local Chat = PlrGui:FindFirstChild("Chat")
        local C1 = Chat and Chat:FindFirstChild("ChannelsBarParentFrame", true)
        local C2 = Chat and Chat:FindFirstChild("ChatBarParentFrame", true)
        local C3 = Chat and Chat:FindFirstChild("ChatChannelParentFrame", true)
        Gui = C1 and C2 and C3 and Chat
    end
    return Gui
end

local function DefineSBui()
    return UiInit.Global_IKsb
end

local function Wipe(Class)
    if not Class then return end
    for _,v in next, Class:GetDescendants() do
        if v.ClassName == "LocalScript" then
            v.Disabled = true
            v:Destroy()
        end
    end
end

ShareAction("cls", function()
    Wipe(Player.Character)
    Wipe(Player:FindFirstChildOfClass("Backpack"))
    Wipe(Player:FindFirstChildOfClass("PlayerGui"))
    Wipe(Player:FindFirstChildOfClass("PlayerScripts"))
end)


ShareAction("uis", function()
    local PlrGui = Player:FindFirstChildOfClass("PlayerGui")
    for _,v in next, PlrGui:GetChildren() do
        local sg = v:IsA("ScreenGui") or v:IsA("GuiMain")
        if sg and v and v ~= DefineRobloxChat() then
            v.Enabled = not v.Enabled
        end
    end
end)

ShareAction("ui", function()
    local PlrGui = Player:FindFirstChildOfClass("PlayerGui")
    for _,v in next, PlrGui:GetChildren() do
        if v:IsA("ScreenGui") and v == DefineSBui() then
            v.Enabled = not v.Enabled
        end
    end
end)

ShareAction("duis", function()
    local PlrGui = Player:FindFirstChildOfClass("PlayerGui")
    for _,v in next, PlrGui:GetChildren() do
        local sg = v:IsA("ScreenGui") or v:IsA("GuiMain")
        if sg and v and v ~= DefineRobloxChat() then
            pcall(function()
                v.Enabled = false
                v:Destroy()
            end)
        end
    end
end)

ShareAction("sb_ui", function()
    local PlrGui = Player:FindFirstChildOfClass("PlayerGui")
    local Got
    for _,v in next, PlrGui:GetChildren() do
        if v == DefineSBui() then
            Got = v
        end
    end
    if not Got then
        UiInit:ScriptingUtl()
    end
end)

ShareAction("keybind", function()
    local Keybind = UiInit:GetSetting().Keybind()
    UiInit:ChangeSetting().Keybind(not Keybind)
end)

ShareAction("Commands", function()
    UiInit:CommandsPallet()
end)

ShareAction("refresh", function()
    local PlrGui = Player:FindFirstChildOfClass("PlayerGui")
    for _,v in next, PlrGui:GetChildren() do
        if v == DefineSBui() then
            v:Destroy()
        end
    end
    UiInit:ScriptingUtl()
end)

ShareAction("camera", function()
    local Char = Player.Character
    local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
    if Hum then
        workspace.CurrentCamera:Destroy()

        local Camera = Instance.new("Camera")
        Camera.CameraSubject = Hum
        Camera.CameraType = Enum.CameraType.Custom
        Camera.FieldOfView = 70
        Camera.HeadLocked = true
        Camera.HeadScale = 1
        Camera.Parent = workspace
    end
    Player.CameraMaxZoomDistance = 400
    Player.CameraMinZoomDistance = 0.5
    Player.CameraMode = Enum.CameraMode.Classic
    Player.HealthDisplayDistance = 100
    Player.NameDisplayDistance = 100
end)

ShareAction("freecam", function()
    Freecam()
end)

ShareAction("spectate", function(Player)
    local Char = Player.Character
    if Char then
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if Hum then
            workspace.CurrentCamera.CameraSubject = Hum
        end
    end
end)

ShareAction("ping", function()
    local Shared = Storage:WaitForChild("Shared", 5)
    local Server = Shared and Shared:WaitForChild("Server", 5)
    local Remote = Server and Server:WaitForChild("Return", 5)
    if Remote then
        local time = tick()
        local Pinged = Remote:InvokeServer("Ping")
        if Pinged then
            local estimated = tick() - time
            UiInit:Notify(tostring(estimated).." ms.")
        end
    else
        warn("Couldn't get server requirements for the client.")
    end
end)

ShareAction("cursor", function()
    UIS.MouseIconEnabled = true
end)

ShareAction("clear_globals", function()
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
    UiInit:Notify("Cleared "..c.." client global(s).")
end)

ShareAction("dump_globals", function()
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
    UiInit:Prompt(table.concat(fetched, "\n"))
end)

ShareAction("executor", function()
    UiInit:exe()
end)

ShareAction("coreguis", function()
    --SG:SetCoreGuiEnabled(Enum.CoreGuiType.All, (not SG:GetCoreGuiEnabled(Enum.CoreGuiType.All)))
    SG:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
    SG:SetCore("DevConsoleVisible", true)
end)

ShareAction("change_log", function()
    local setting = UiInit:ChangeSetting()
    setting.ChangeLog_Toggle()
end)

ShareAction("dump_sounds", function()
    local got = 0
    local fetched = {}
    for _,v in next, game:GetDescendants() do
        pcall(function()
            if v:IsA("Sound") then
                got += 1
                table.insert(fetched, got .. ":"..(" ".. v.Name .. " | ".. v.SoundId .. " | ".. v:GetFullName()))
            end
        end)
    end
    UiInit:Prompt(table.concat(fetched, "\n"))
end)

ShareAction("support", function()
    if Player.MembershipType == Enum.MembershipType.Premium then
        UiInit:Notify(Player, "You are already supporting the game just by having premium.")
    else
        MPS:PromptPremiumPurchase(Player)
        UiInit:Notify(Player, "Having premium will not only support the game but will benefit you as well outside of the game.")
    end
end)

return Shared