--[[
    Author: interpreterK (717072114)
    GuiService.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local GuiService = S.GuiService

local GUIs = {
    Open = {},
    Closed = {}
}
GUIs.__index = GUIs

function GUIs:MenuOpen(Func)
    table.insert(self.Open, Func)
end

function GUIs:MenuClose(Func)
    table.insert(self.Closed, Func)
end

GuiService.MenuOpened:Connect(function()
    for _, Func in next, GUIs.Open do
        Func()
    end
end)

GuiService.MenuClosed:Connect(function()
    for _, Func in next, GUIs.Closed do
        Func()
    end
end)

return GUIs