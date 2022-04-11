--[[
    Author: interpreterK (717072114)
    TextService.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local obtain = _G.obtain

local S = obtain'S'
local Players = S.Players

local SS = obtain'SendServer'
local UiInit = obtain'UiInit'

local wait = task.wait -- Basically Heartbeat:Wait()
local resume = coroutine.resume
local create = coroutine.create
local Player = Players.LocalPlayer

local TS = {
    Requests = 0,
    TextOriented = {"Message", "Hint", "TextBox", "TextButton", "TextLabel"},
    Dialogs = {"Dialog", "DialogChoice", "ProximityPrompt"}
}
TS.__index = TS

local function DefineRobloxChat() -- Taken from shared.lua
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

function TS:GetFiltered(String)
    if self.Requests > 1 then
        repeat
            wait()
        until self.Requests < 1
    end
    self.Requests += 1
    local Filtered = SS:RequestServer("FilterString", String)
    self.Requests -= 1
    return Filtered or ('_'):rep(#String)
end

function TS:EmptyField(String)
    return String:gsub(' ', '') == ''
end

local function AllUndercases(Str) -- Determine if the string failed to filter
	for _,v in next, Str:split('') do
		--v:match('^(%p+)$')
		if v ~= '_' then
			return false
		end
	end
	return Str
end
function TS:ContainsFiltered(String)
    return String:find('#') or AllUndercases(String)
end

function TS:HandleProp(Inst, PropName)
    local Text = Inst[PropName]
    while Inst[PropName] == Inst.ClassName or self:EmptyField(Text) do
        Inst:GetPropertyChangedSignal(PropName):Wait()
        Text = Inst[PropName]
    end
    if Inst and Text == Inst[PropName] then
        local Filtered = self:GetFiltered(Text)
        if self:ContainsFiltered(Filtered) then
            Inst[PropName] = Filtered
        end
    end
end

local function HumanoidFilter(self, Hum)
    local DisplayName = Hum.DisplayName
    while Hum.DisplayName == Hum.ClassName or self:EmptyField(Hum.DisplayName) do
        Hum:GetPropertyChangedSignal("DisplayName"):Wait()
        DisplayName = Hum.DisplayName
    end
    if Hum and Hum.DisplayName == DisplayName then
        local Filtered = self:GetFiltered(DisplayName)
        if self:ContainsFiltered(Filtered) then
            Hum.DisplayName = Filtered
        end
    end
end

function TS:HandleDisplayName(Model, Humanoid)
    if Model and Humanoid then
        if self:EmptyField(Humanoid.DisplayName) then
            local Name = Model.Name
            while Model.Name == Model.ClassName or self:EmptyField(Model.Name) do
                Model:GetPropertyChangedSignal("Name"):Wait()
                Name = Model.Name
            end
            local Filtered = self:GetFiltered(Name)
            if self:ContainsFiltered(Filtered) then
                Humanoid.DisplayName = Filtered
            else
                -- Check the humanoid displayname incase the model name isnt tagged, blank, or equals its classname
                HumanoidFilter(self, Humanoid)
            end
        else
            HumanoidFilter(self, Humanoid)
        end
    end
end

-- Dialogs are very antiquated its not gonna work or change most of the time :/
function TS:Dialog(Inst)
    wait()
    if Inst then
        resume(create(function()
            self:HandleProp(Inst, "GoodbyeDialog")
        end))
        resume(create(function()
            self:HandleProp(Inst, "InitialPrompt")
        end))
    end
end
function TS:DialogChoice(Inst)
    wait()
    if Inst then
        resume(create(function()
            self:HandleProp(Inst, "GoodbyeDialog")
        end))
        resume(create(function()
            self:HandleProp(Inst, "ResponseDialog")
        end))
        resume(create(function()
            self:HandleProp(Inst, "UserDialog")
        end))
    end
end
--

function TS:ProximityPrompt(Inst)
    wait()
    if Inst then
        resume(create(function()
            self:HandleProp(Inst, "ActionText")
        end))
        resume(create(function()
            self:HandleProp(Inst, "ObjectText")
        end))
    end
end

function TS:HandleHumanoid(Inst)
    wait()
    if Inst then
        local Model = Inst.Parent:IsA("Model") and Inst.Parent
        if Model and not Players:GetPlayerFromCharacter(Model) then
            if Model:FindFirstChild("Head") then
                resume(create(function()
                    self:HandleDisplayName(Model, Inst)
                end))
            end
        end
    end
end

function TS:HandleDialogs(Inst)
    wait()
    if Inst then
        if self[Inst.ClassName] then
            self[Inst.ClassName](Inst)
        end
    end
end

-- There is no consistent way of filtering the console as much as possible without holding back TextService.
function TS:HandleTextOriented(Inst, IsATextBox)
    wait()
    if Inst then
        local IsD_Con = Inst:IsDescendantOf(UiInit.Global_Console)
        local IsD_iK = Inst:IsDescendantOf(UiInit.Global_IKsb)
        local IsD_Chat = Inst:IsDescendantOf(DefineRobloxChat())

        local function iK_Ui(Ui)
            return Ui.Name == "iK Prompt" or Ui.Name == "iK Notify" or Ui.Name == "iK Info"
        end

        local function FilterIncoming()
            resume(create(function()
                self:HandleProp(Inst, "Text")
            end))
            if IsATextBox then
                resume(create(function()
                    self:HandleProp(Inst, "PlaceholderText")
                end))
            end
        end
        resume(create(function()
            local Ui = Inst:FindFirstAncestorOfClass("ScreenGui")
            if not Inst:IsDescendantOf(workspace) and not Ui then
                return
            end
            if not IsD_Con and not IsD_iK and not IsD_Chat then
                if Ui then
                    if not iK_Ui(Ui) then
                        FilterIncoming()
                    end
                else
                    FilterIncoming()
                end
            end
        end))
    end
end

function TS:HandleTeam(Inst)
    wait()
    resume(create(function()
        self:HandleProp(Inst, "Name")
    end))
end

function TS:HandleTool(Inst, IsHopperBin)
    wait()
    if not IsHopperBin then
        resume(create(function()
            self:HandleProp(Inst, "Name")
        end))
        resume(create(function()
            self:HandleProp(Inst, "ToolTip")
        end))
    else
        resume(create(function()
            self:HandleProp(Inst, "Name")
        end))
    end
end

function TS:ScanInst(Inst) -- Built for pure & fastest speed.
    pcall(function()
        for i = 1, #self.TextOriented do
            if Inst.ClassName == self.TextOriented[i] then
                self:HandleTextOriented(Inst, Inst.ClassName == "TextBox")
                break
            end
        end
        for i = 1, #self.Dialogs do
            if Inst.ClassName == self.Dialogs[i] then
                self:HandleDialogs(Inst)
                break
            end
        end
        if Inst.ClassName == "Humanoid" then
            self:HandleHumanoid(Inst)
        end
    end)
end

function TS:ScanTeam(Inst)
    pcall(function()
        if Inst.ClassName == "Team" then
            self:HandleTeam(Inst)
        end
    end)
end

function TS:ScanTool(Inst)
    pcall(function()
        if Inst.ClassName == "Tool" then
            self:HandleTool(Inst, false)
        elseif Inst.ClassName == "HopperBin" then
            self:HandleTool(Inst, true)
        end
    end)
end

return TS