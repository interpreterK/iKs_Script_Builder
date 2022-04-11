--[[
    Author: interpreterK (717072114)
    Connections.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local LogService = S.LogService
local Players = S.Players
local Teams = S.Teams

-- The Ui --
local MessageOut = obtain'MessageOut'
local UiInit = obtain'UiInit'
local ClientS = obtain'ClientS'
local Shared = obtain'shared'
local SRT = obtain'ScriptRuntime'
--

local resume = coroutine.resume
local create = coroutine.create

local function WaitForChildOfClass(Par, Class)
    local Inst = Par:FindFirstChildOfClass(Class)
    while not Inst do
        Inst = Par.ChildAdded:Wait()
    end
    return Inst
end

-- Connect The Client For The Server --
ClientS:ConnectRef("MessageOut", function(...)
    local Console = UiInit:GetSetting().Global_Console()
    if Console then
        MessageOut:Server(Console, ...)
    end
end)
ClientS:ConnectRef("GameLog", function(String, Type)
    local Console = UiInit:GetSetting().Global_Console()
    if Console then
        MessageOut:Game(Console, String, Type or "Game_Server")
    end
end)
ClientS:ConnectRef("Command", function(Command, ...)
    if Shared[Command] then
        Shared[Command](...)
    else
        warn("Unknown client command:", Command)
    end
end)
ClientS:ConnectRef("Notify", function(Text)
    UiInit:Notify(Text)
end)
ClientS:ConnectRef("Notify_SpammingRemotes", function()
    UiInit:Notify_SpammingRemotes()
end)
ClientS:ConnectRef("Prompt", function(Text)
    UiInit:Prompt(Text)
end)
ClientS:ConnectRef("Executor", function(ran, error)
    if ran then
        UiInit:Prompt("The script ran successfully without error.")
    else
        UiInit:Prompt(error)
    end
end)
ClientS:ConnectRef("Client", function(s, p)
    SRT:UnpackAndLoad(s, p)
end)

-- Initializing --
UiInit:ScriptingUtl()
ClientS:Initialize()
--

-- LogService --
LogService.MessageOut:Connect(function(...)
    local Console = UiInit:GetSetting().Global_Console()
    if Console then
        MessageOut:Client(Console, ...)
    end
end)
--

-- TextService For Filtering --
resume(create(function()
    local TS = obtain'TextService'
    local Player = Players.LocalPlayer
    local UiInterface = WaitForChildOfClass(Player, "PlayerGui")
    local Backpack = WaitForChildOfClass(Player, "Backpack")
    local BackpackInsts = Backpack:GetChildren()
    local Guis = UiInterface:GetDescendants()
    local WorkspaceInsts = workspace:GetDescendants()
    local TeamInsts = Teams:GetChildren()
    
    for i = 1, #Guis do
        TS:ScanInst(Guis[i])
    end
    UiInterface.DescendantAdded:Connect(function(Inst)
        TS:ScanInst(Inst)
    end)
    for i = 1, #BackpackInsts do
        TS:ScanTool(BackpackInsts[i])
    end
    Backpack.ChildAdded:Connect(function(Inst)
        TS:ScanTool(Inst)
    end)
    for i = 1, #TeamInsts do
        TS:ScanTeam(TeamInsts[i])
    end
    Teams.ChildAdded:Connect(function(Inst)
        TS:ScanTeam(Inst)
    end)
    for i = 1, #WorkspaceInsts do
        TS:ScanInst(WorkspaceInsts[i])
    end
    workspace.DescendantAdded:Connect(function(Inst)
        TS:ScanInst(Inst)
    end)
end))
--

return true