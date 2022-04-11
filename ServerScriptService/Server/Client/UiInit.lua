--[[
    Author: interpreterK (717072114)
    UiInit.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local CAS = S.ContextActionService

local Tween = obtain'Tween'
local Ui = obtain'Ui'
local MessageOut = obtain'MessageOut'
local Dragger = obtain'Drag'
local GameInfo = obtain'Info'
local GuiService = obtain'GuiService'
local CmdsList = obtain'CommandsList'
local Syntax = obtain'Syntax'
local SS = obtain'SendServer'

local UiInit = {
    GPCS_Connection = nil,
    GPCS_Connection_2 = nil,
    Global_IKsb = nil,
    Global_Input = nil,
    Global_Console = nil,
    ChangeLog_Button = nil,
    Saves = {},
    Active = {},
    ActiveInfo = false,
    Keybind = true,
    ActiveChangeLog = false,
    Debounce = false,
    S_Debounce = false,
    ChangeLog_toggled = true,
    Global_Cooldown = 30,
    Commits = 0,
    RenameOpened = false
}
UiInit.__index = UiInit

local delay = task.delay
local wait = task.wait
local resume = coroutine.resume
local create = coroutine.create

local function exe_execute(self, Server, Code, Debugging)
    local SRT = obtain'ScriptRuntime' -- Prevent module being required recursively
    local function Debug()
        local ran, error = SRT:UnpackAndLoad_Debug(Code)
        if ran then
            self:Prompt("The script ran successfully without error.")
        else
            self:Prompt(error)
        end
    end
    if Server then
        if Debugging then
            SS:SendServer("Server_Exe", Code)
        else
            SS:SendServer("Server", Code)
        end
    else
        if Debugging then
            Debug()
        else
            SRT:UnpackAndLoad(Code)
        end
    end
end

local function UiFadeIn(GuiObject)
    Tween:CustomTween(GuiObject, {BackgroundTransparency = 0}, 0.2, "Linear", "Out", 0)
end

local function UiFadeOut(GuiObject)
    Tween:CustomTween(GuiObject, {BackgroundTransparency = 0.5}, 0.2, "Linear", "Out", 0)
end

local function Color(Table, Type)
    local Types = {
        Frame = {
            Server = {
                BackgroundColor3 = Color3.fromRGB(72, 145, 218)
            },
            Client = {
                BackgroundColor3 = Color3.fromRGB(200, 107, 1)
            },
            Command = {
                BackgroundColor3 = Color3.fromRGB(0, 210, 95)
            },
            Parallel = {
                BackgroundColor3 = Color3.fromRGB(166, 47, 235)
            },
            Default = {
                BackgroundColor3 = Color3.fromRGB(34, 39, 46)
            }
        },
        TextBox = {
            Server = {
                TextColor3 = Color3.fromRGB(0, 0, 0)
            },
            Client = {
                TextColor3 = Color3.fromRGB(0, 0, 0)
            },
            Command = {
                TextColor3 = Color3.fromRGB(0, 0, 0)
            },
            Parallel = {
                TextColor3 = Color3.fromRGB(0, 0, 0)
            },
            Default = {
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }
        }
    }
    for _,v in next, Table do
        Tween:CustomTween(v, Types[v.ClassName][Type], 0.2, "Linear", "Out", 0)
    end
end

local function TweenSize(Exec, isOpening)
    if isOpening then
        Tween:TSandPS(Exec, UDim2.new(0.300347656, 0, 0.0298273116, 0), UDim2.new(0.152172178, 0, 0.974882245, 0), "In", "Linear", 0.2, true)
    else
        Tween:TSandPS(Exec, UDim2.new(0.168866172, 0, 0.0298273098, 0), UDim2.new(0.0898265019, 0, 0.974882245, 0), "Out", "Sine", 0.7, true)
    end
end

local function enter_leave(GuiObject)
    GuiObject.MouseEnter:Connect(function()
        UiFadeIn(GuiObject)
    end)
    GuiObject.MouseLeave:Connect(function()
        UiFadeOut(GuiObject)
    end)
end

local function enter_drag(GuiObject)
    enter_leave(GuiObject)
    Dragger(GuiObject)
end

local function GPCS_TB(self, TextBox, Func)
    self.GPCS_Connection = TextBox:GetPropertyChangedSignal("Text"):Connect(Func)
    TextBox.FocusLost:Connect(function()
        if self.GPCS_Connection then
            self.GPCS_Connection:Disconnect()
        end
    end)
end

local function GPCS_Colors(self, Exe, TextBox)
    local Insts = {
        Exe = Exe,
        TextBox = TextBox
    }
    self.GPCS_Connection_2 = TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = TextBox.Text:lower()
        local split = text:split("/")
        if split[1] then
            local Type = split[1]
            if Type == "s" or Type == "ser" or Type == "server" then
                if text:sub(1,#Type+1):match("%p") == "/" then
                    Color(Insts, "Server")
                end
            elseif Type == "c" or Type == "cli" or Type == "client" then
                if text:sub(1,#Type+1):match("%p") == "/" then
                    Color(Insts, "Client")
                end
            elseif Type == "p" or Type == "par" or Type == "parallel" then
                if text:sub(1,#Type+1):match("%p") == "/" then
                    Color(Insts, "Parallel")
                end
            elseif Type == "cmd" or Type == "command" then
                if text:sub(1,#split[1]+1):match("%p") == "/" then
                    Color(Insts, "Command")
                end
            else
                if Insts.TextBox.BackgroundColor3 ~= Color3.fromRGB(34, 39, 46) and Insts.TextBox.TextColor3 ~= Color3.fromRGB(255, 255, 255) then
                    Color(Insts, "Default")
                end
            end
        end
    end)
end

local function Upload_Commits(Commits)
    SS:SendServer("Upload_Save", Commits)
end

local function CommitSave(self, Input, SavedScripts)
    if self.Commits < 100 then
        local Code = Input.Text
        self.Commits += 1
        local Name = "Saved Script " .. self.Commits
        self.Saves[Name] = Code
        
        local SaveButton = Ui.CreateExeSave(SavedScripts, Name)
        SaveButton.MouseButton1Click:Connect(function()
            Input.Text = Code
        end)
        SaveButton.MouseButton2Click:Connect(function()
            self:RenameSave(SaveButton)
        end)
        Upload_Commits(self.Saves)
    end
end

function UiInit:RenameSave(SaveButton)
    if self.Global_IKsb and not self.RenameOpened then
        self.RenameOpened = true
        local RenameCommit, CommitName, NameInput, Save, Cancel = Ui.RenamePrompt(self.Global_IKsb)
        CommitName.Text = CommitName.Text .. SaveButton.Text
        
        local function NameExists(CommitingName)
            for Name in next, self.Saves do
                if CommitingName == Name then
                    return true
                end
            end
            return false
        end
        local function Close()
            self.RenameOpened = false
            RenameCommit:Destroy()
        end
        local function Commit()
            local cName = NameInput.Text
            if #NameInput.Text > 30 then
                cName = cName:sub(-30)
            end

            local CommitCode = self.Saves[SaveButton.Text]
            self.Saves[SaveButton.Text] = nil
            self.Saves[cName] = CommitCode
            Upload_Commits(self.Saves)
            SaveButton.Text = cName
            Close()
        end

        Save.MouseButton1Click:Connect(function()
            if NameInput.Text:gsub(" ", "") ~= "" then
                if not NameExists(NameInput.Text) then
                    Save.Text = "..."
                    Commit()
                end
            end
        end)
        Cancel.MouseButton1Click:Connect(Close)

        enter_drag(RenameCommit)
    end
end

function UiInit:Info()
    local iKInfo, Frame, Close, ScrollingFrame = Ui.Info(GameInfo.Info)

    self.ActiveInfo = true
    Close.MouseButton1Click:Connect(function()
        self.ActiveInfo = false
        iKInfo:Destroy()
    end)
    Tween:TP(Frame, UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", 0.2)
    enter_drag(Frame)

    return iKInfo, ScrollingFrame
end

function UiInit:ChangeLog()
    local iKInfo, Frame, Close, ScrollingFrame = Ui.Info(GameInfo.Change_Log)

    self.ActiveChangeLog = true
    Close.MouseButton1Click:Connect(function()
        self.ActiveChangeLog = false
        iKInfo:Destroy()
    end)
    Tween:TP(Frame, UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", 0.2)
    enter_drag(Frame)

    return iKInfo, ScrollingFrame
end

function UiInit:CommandsPallet()
    if self.Global_IKsb then
        local Commands, List, Search_Frame, Search_Box, Close, ServerCmds, ClientCmds = Ui.CommandsPallet(self.Global_IKsb)
        local Viewing_g = true
        local function ServerCommands()
            local c = 0
            for cmd, props in next, CmdsList["g!"] do
                local TextBox = Ui.AddCmd(List, "g!")
                c += 1
                local T = c .. ": " .. cmd
                if #props.Alias ~= 0 then
                    T = T .. " | " .. table.concat(props.Alias, " | ")
                end
                TextBox.Text = T
            end
        end
        local function ClientCommands()
            local c = 0
            for cmd, props in next, CmdsList["c!"] do
                local TextBox = Ui.AddCmd(List, "c!")
                c += 1
                local T = c .. ": " .. cmd
                if #props.Alias ~= 0 then
                    T = T .. " | " .. table.concat(props.Alias, " | ")
                end
                TextBox.Text = T
            end
        end
        local function DefineWhatIsBeingUsed()
            return Viewing_g and ServerCmds.Text or ClientCmds.Text
        end
        local function ClearList()
            for _,v in next, List:GetChildren() do
                if not v:IsA("UIListLayout") then
                    v:Destroy()
                end
            end
        end

        ServerCmds.MouseButton1Click:Connect(function()
            if not Viewing_g then
                ServerCmds.BorderColor3 = Color3.fromRGB(255, 255, 255)
                ClientCmds.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ClearList()
                ServerCommands()
                Viewing_g = true
            end
        end)
        ClientCmds.MouseButton1Click:Connect(function()
            if Viewing_g then
                ServerCmds.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ClientCmds.BorderColor3 = Color3.fromRGB(255, 255, 255)
                ClearList()
                ClientCommands()
                Viewing_g = false
            end
        end)
        Search_Box.Focused:Connect(function()
            for _,v in next, List:GetChildren() do
                if v.Name == DefineWhatIsBeingUsed() then
                    v.Visible = true
                end
            end
            GPCS_TB(self, Search_Box, function()
                for _,v in next, List:GetChildren() do
                    if not v:IsA("UIListLayout") then
                        if v.Text:lower():find(Search_Box.Text:lower()) then
                            v.Visible = true
                        else
                            v.Visible = false
                        end
                    end
                end
            end)
        end)
        Close.MouseButton1Click:Connect(function()
            Commands:Destroy()
        end)
        Dragger(Commands)
        ServerCommands()
    else
        print("no iksb ui, Global_IKsb=",self.Global_IKsb)
    end
end

function UiInit:BindInputFocus()
    local ActionName = "InputField_Focus"
    local function Action(actionName, inputState)
        if actionName == ActionName and inputState == Enum.UserInputState.Begin then
            if self.Global_Input then
                wait()
                self.Global_Input:CaptureFocus()
            end
        end
    end
    CAS:BindAction(ActionName, Action, false, Enum.KeyCode.Semicolon)
end

function UiInit:UnBindInputFocus()
    CAS:UnbindAction("InputField_Focus")
end

function UiInit:ScriptingUtl()
    local iKSB, Exe, InputField, ConsoleWindow, ServerClient, UIGradient, ConsoleFrame, Console, SearchFrame, Search, Clear, Console_2, _Info, Version = Ui.ScriptingContent()
    local Compiler = obtain'Compiler'

    self.Global_IKsb = iKSB
    self.Global_Console = Console
    self.ChangeLog_Button = Version
    self.Global_Input = InputField
    if self.Keybind then
        self:BindInputFocus()
    end

    Search.Focused:Connect(function()
        for _,v in next, Console:GetChildren() do
            if v.Name == ServerClient.Text then
                v.Visible = true
            end
        end
        GPCS_TB(self, Search, function()
            for _,v in next, Console:GetChildren() do
                if v.Name == ServerClient.Text then
                    if v.Text:lower():find(Search.Text:lower()) then
                        v.Visible = true
                    else
                        v.Visible = false
                    end
                end
            end
        end)
    end)
    InputField.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            Compiler(InputField.Text)
            InputField.Text = ""
        end
        if self.GPCS_Connection_2 then
            self.GPCS_Connection_2:Disconnect()
        end
        UiFadeOut(Exe)
        TweenSize(Exe, false)
    end)
    InputField.Focused:Connect(function()
        UiFadeIn(Exe)
        TweenSize(Exe, true)
        GPCS_Colors(self, Exe, InputField)
    end)
    Console_2.MouseButton1Click:Connect(function()
        ConsoleWindow.Visible = not ConsoleWindow.Visible
        if not ConsoleWindow.Visible then
            ConsoleWindow.Position = UDim2.new(0.829389453, 0, 0.815704167, 0)
        end
    end)
    ServerClient.MouseButton1Click:Connect(function()
        if ServerClient.Text == "Server" then
            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 115, 0)), ColorSequenceKeypoint.new(0.46, Color3.fromRGB(255, 157, 112)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
            ServerClient.Text = "Client"
            MessageOut:SwitchClient(Console)
        elseif ServerClient.Text == "Client" then
            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.47, Color3.fromRGB(0, 255, 127)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
            ServerClient.Text = "Game"
            MessageOut:SwitchGame(Console)
        else
            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 170, 255)), ColorSequenceKeypoint.new(0.46, Color3.fromRGB(143, 188, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))} 
            ServerClient.Text = "Server"
            MessageOut:SwitchServer(Console)
        end
    end)
    Clear.MouseButton1Click:Connect(function()
        for _,v in next, Console:GetChildren() do
            if v.Name == ServerClient.Text then
                v:Destroy()
            end
        end
    end)
    _Info.MouseButton1Click:Connect(function()
        if not self.ActiveInfo then
            self:Info()
        end
    end)
    Version.MouseButton1Click:Connect(function()
        if not self.ActiveChangeLog then
            self:ChangeLog()
        end
    end)

    GuiService:MenuOpen(function()
        if Version and self.ChangeLog_toggled then
            Version.Visible = false
        end
    end)
    GuiService:MenuClose(function()
        if Version and self.ChangeLog_toggled then
            Version.Visible = true
        end
    end)

    enter_leave(Exe)
    enter_leave(Console_2)
    enter_leave(_Info)
    enter_leave(ConsoleWindow)
    Dragger(ConsoleWindow)

    return iKSB, Exe, InputField, ConsoleWindow, ServerClient, UIGradient, ConsoleFrame, Console, SearchFrame, Search, Clear, Console_2, _Info
end

function UiInit:Prompt(Text)
    local iKInfo, Frame, Close, TextLabel, ScrollingFrame, TextBox = Ui.Prompt(Text)
    self.Global_Prompt = iKInfo
    
    Close.MouseButton1Click:Connect(function()
        iKInfo:Destroy()
    end)
    Tween:TP(Frame, UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", 0.2)
    enter_drag(Frame)

    return iKInfo, Frame, Close, TextLabel, ScrollingFrame, TextBox
end

function UiInit:Notify(_Text)
    if not self.Debounce then
        self.Debounce = true
        local iKNotify, Frame, Close, Text = Ui.Notify(_Text)

        for _, v in next, self.Active do
            Tween:TP(v, UDim2.new(v.Position.X.Scale, 0, v.Position.Y.Scale - 0.12, 0), "Out", "Quad", 0.2)
        end
        table.insert(self.Active, Frame)
    
        Close.MouseButton1Click:Connect(function()
            table.remove(self.Active, table.find(self.Active, Frame))
            iKNotify:Destroy()
        end)
        delay(self.Global_Cooldown, function()
            table.remove(self.Active, table.find(self.Active, Frame))
            iKNotify:Destroy()
        end)
        delay(1, function()
            self.Debounce = false
        end)
        
        Tween:TP(Frame, UDim2.new(0.916, 0, 0.936, 0), "Out", "Quad", 0.2)
        enter_leave(Frame)
    
        return iKNotify, Frame, Close, Text
    end
end

function UiInit:Notify_SpammingRemotes()
    if not self.S_Debounce then
        self.S_Debounce = true
        local iKNotify, Frame, Close, Text = Ui.Notify("Your client appears to be spamming remote events. (Roblox Warning/Unexpected behaviour)")

        for _, v in next, self.Active do
            Tween:TP(v, UDim2.new(v.Position.X.Scale, 0, v.Position.Y.Scale - 0.12, 0), "Out", "Quad", 0.2)
        end
        table.insert(self.Active, Frame)

        Close.MouseButton1Click:Connect(function()
            table.remove(self.Active, table.find(self.Active, Frame))
            iKNotify:Destroy()
        end)
        delay(self.Global_Cooldown, function()
            table.remove(self.Active, table.find(self.Active, Frame))
            iKNotify:Destroy()
        end)
        delay(self.Global_Cooldown, function()
            self.S_Debounce = false
        end)
        
        Tween:TP(Frame, UDim2.new(0.916, 0, 0.936, 0), "Out", "Quad", 0.2)
        enter_leave(Frame)

        return iKNotify, Frame, Close, Text
    end
end

function UiInit:exe()
    if self.Global_IKsb then
        local Exe, Lines, InputField_Scroll, Input, SavedScripts, ServerClient, UIGradient, Run, Save, Close, Debug, Clear = Ui.exe(self.Global_IKsb)
        local Debugging = false
        local Server = true
        local Clearing = false
        local Connections = {}
        local Cancel_Tween
        local function ClearingEffect(obj)
            Cancel_Tween = Tween:CustomTween(obj, {BackgroundColor3 = Color3.fromRGB(200, 0, 0), BackgroundTransparency = 0}, 0.2, "Linear", "Out", 0)
        end

        local function clearSaves()
            for _,v in next, SavedScripts:GetChildren() do
                if not v:IsA("UIListLayout") then
                    v:Destroy()
                end
            end
            self.Commits = 0
        end
        
        resume(create(function()
            local old = self.Saves
            self.Saves = SS:RequestServer("Retrieve_Save") or old
            for Name, Commit in next, self.Saves do
                local SaveButton = Ui.CreateExeSave(SavedScripts, Name)
                SaveButton.MouseButton1Click:Connect(function()
                    Input.Text = Commit
                end)
                SaveButton.MouseButton2Click:Connect(function()
                    self:RenameSave(SaveButton)
                end)
            end
        end))
        Close.MouseButton1Click:Connect(function()
            for _,v in next, Connections do
                v:Disconnect() -- Idk if modular code destroying an instance with connected events will disconnect them???
            end
            Exe:Destroy()
        end)
        Debug.MouseButton1Click:Connect(function()
            if not Debugging then
                Debugging = true
                Debug.Text = "Debug Mode: " .. Syntax:FormatColor("0,255,0", "ON")
            else
                Debugging = false
                Debug.Text = "Debug Mode: " .. Syntax:FormatColor("255,0,0", "OFF")
            end
        end)
        Save.MouseButton1Click:Connect(function()
            CommitSave(self, Input, SavedScripts)
        end)
        ServerClient.MouseButton1Click:Connect(function()
            if Server then
                Server = false
                UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 115, 0)), ColorSequenceKeypoint.new(0.46, Color3.fromRGB(255, 157, 112)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
                ServerClient.Text = "Client"
            else
                Server = true
                UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 170, 255)), ColorSequenceKeypoint.new(0.46, Color3.fromRGB(143, 188, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
                ServerClient.Text = "Server"
            end
        end)
        Run.MouseButton1Click:Connect(function()
            exe_execute(self, Server, Input.Text, Debugging)
        end)
        Clear.MouseButton1Click:Connect(function()
            if Cancel_Tween then
                Cancel_Tween:Cancel()
                Clear.BackgroundTransparency = 0.5
                Clear.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
            if not Clearing then
                Clearing = true
                delay(5, function()
                    Clearing = false
                    Clear.BackgroundTransparency = 0.5
                    Clear.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                end)
                ClearingEffect(Clear)
            else
                Clearing = false
                Upload_Commits({})
                self.Saves = {}
                clearSaves()
                Clear.BackgroundTransparency = 0.5
                Clear.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
        end)
        --[[
        table.insert(Connections, Input:GetPropertyChangedSignal("Text"):Connect(function()
            for _,v in next, Lines:GetChildren() do
                if v.ClassName ~= "UIListLayout" then
                    v:Destroy()
                end
            end
            for i = 1, #Input.Text:split("\n") do
                Ui.NewExeLine(Lines, i)
            end
        end))
        ]]

        Tween:TP(Exe, UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", 0.2)
        enter_drag(Exe)
        
        return Exe, Lines, InputField_Scroll, Input, SavedScripts, ServerClient, UIGradient, Run, Save, Close, Debug, Clear
    end
end

function UiInit:ChangeSetting()
    return {
        Keybind = function(newValue)
            self.Keybind = newValue
            if newValue then
                UiInit:BindInputFocus()
            else
                UiInit:UnBindInputFocus()
            end
        end,
        ChangeLog_Toggle = function()
            if self.ChangeLog_Button then
                self.ChangeLog_Button.Visible = not self.ChangeLog_Button.Visible
                self.ChangeLog_toggled = self.ChangeLog_Button.Visible
            end
        end
    }
end

function UiInit:GetSetting()
    return {
        Global_Console = function()
            return self.Global_Console
        end,
        Keybind = function()
            return self.Keybind
        end
    }
end

return UiInit