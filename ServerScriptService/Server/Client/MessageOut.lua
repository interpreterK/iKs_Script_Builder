--[[
    Author: interpreterK (717072114)
    MessageOut.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local Ui = obtain'Ui'
local Time = obtain'LocalTime'

local Logs = {
    ClientLog = {},
    ServerLog = {},
    GameLog = {},
    ClientCon = false,
    GameCon = false
}
Logs.__index = Logs

local Syntax = setmetatable({
    ["MessageOutput"] = Color3.fromRGB(255, 255, 255), --204, 204, 204
    ["MessageWarning"] = Color3.fromRGB(255, 142, 60),
    ["MessageError"] = Color3.fromRGB(255, 68, 68),
    ["MessageInfo"] = Color3.fromRGB(89, 189, 223),
    ["Game_Server"] = Color3.fromRGB(122, 255, 122),
    ["Game_Client"] = Color3.fromRGB(89, 223, 89),
    ["Game_Error"] = Color3.fromRGB(69, 170, 69),
    ["Game_Command"] = Color3.fromRGB(0, 219, 110),
    ["Game_Player"] = Color3.fromRGB(0, 255, 0)
}, {
    __index = function(t, v)
        return rawget(t, v) or rawget(t, "MessageOutput")
    end
})

function Logs:Client(Parent, Message, Type)
    local osTime = Time:Unix()
    if #self.ClientLog > 100 then
        self.ClientLog[1]:Destroy()
        table.remove(self.ClientLog, 1)
    end
    table.insert(self.ClientLog, Ui.CreateLog(Parent, tostring(osTime..Message), Syntax[Type.Name], "Client", self.ClientCon and not self.GameCon))
end

function Logs:Server(Parent, Message, Type)
    local osTime = Time:Unix()
    if #self.ServerLog > 100 then
        self.ServerLog[1]:Destroy()
        table.remove(self.ServerLog, 1)
    end
    table.insert(self.ServerLog, Ui.CreateLog(Parent, tostring(osTime..Message), Syntax[Type.Name], "Server", not self.ClientCon and not self.GameCon))
end

function Logs:Game(Parent, Message, Type)
    local osTime = Time:FormattedTime()
    if #self.GameLog > 100 then
        self.GameLog[1]:Destroy()
        table.remove(self.GameLog, 1)
    end
    table.insert(self.GameLog, Ui.CreateLog(Parent, tostring(osTime..Message), Syntax[Type], "Game", not self.ClientCon and self.GameCon))
end

function Logs:SwitchClient(Console)
    self.ClientCon = true
    self.GameCon = false
    for _, Content in next, Console:GetChildren() do
        if not Content:IsA("UIListLayout") then
            if Content.Name == "Client" then
                Content.Visible = true
            else
                Content.Visible = false
            end
        end
    end
    Console.CanvasPosition = Vector2.new(0, 0)
end

function Logs:SwitchServer(Console)
    self.ClientCon = false
    self.GameCon = false
    for _, Content in next, Console:GetChildren() do
        if not Content:IsA("UIListLayout") then
            if Content.Name == "Server" then
                Content.Visible = true
            else
                Content.Visible = false
            end
        end
    end
    Console.CanvasPosition = Vector2.new(0, 0)
end

function Logs:SwitchGame(Console)
    self.ClientCon = false
    self.GameCon = true
    for _, Content in next, Console:GetChildren() do
        if not Content:IsA("UIListLayout") then
            if Content.Name == "Game" then
                Content.Visible = true
            else
                Content.Visible = false
            end
        end
    end
    Console.CanvasPosition = Vector2.new(0, 0)
end

return Logs