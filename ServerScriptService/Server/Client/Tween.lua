--[[
    Author: interpreterK (717072114)
    Tween.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local TweenS = S.TweenService

local Tween = {}
Tween.__index = Tween

function Tween:CustomTween(Object, Anim, Time, Style, Direction, Repeat, Reverses, Delay)
    local TInf = TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction], Repeat or -1, Reverses or false, Delay or 0)
    local NTween = TweenS:Create(Object, TInf, Anim)
    NTween:Play()
    return NTween
end

function Tween:TS(GuiObject, Size, Direction, Style, Time, Override, Callback)
    GuiObject:TweenSize(Size, Enum.EasingDirection[Direction] or Enum.EasingDirection.Out, Enum.EasingStyle[Style] or Enum.EasingStyle.Quad, Time or 1, Override or false, Callback)
end

function Tween:TP(GuiObject, Position, Direction, Style, Time, Override, Callback)
    GuiObject:TweenPosition(Position, Enum.EasingDirection[Direction] or Enum.EasingDirection.Out, Enum.EasingStyle[Style] or Enum.EasingStyle.Quad, Time or 1, Override or false, Callback)
end

function Tween:TSandPS(GuiObject, Size, Position, Direction, Style, Time, Override, Callback)
    GuiObject:TweenSizeAndPosition(Size, Position, Enum.EasingDirection[Direction] or Enum.EasingDirection.Out, Enum.EasingStyle[Style] or Enum.EasingStyle.Quad, Time or 1, Override or false, Callback)
end

return Tween