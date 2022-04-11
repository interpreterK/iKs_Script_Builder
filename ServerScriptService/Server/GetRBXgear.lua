--[[
    Author: interpreterK (717072114)
    GetRBXgear.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local IS = S.InsertService

local function GetRBXgear(Player, Id)
    local Exist, Info = pcall(IS.LoadAsset, IS, Id)
    if Exist then
        local Tool = Info:FindFirstChildOfClass("Tool")
        if Tool then
            local SG = Player:FindFirstChildOfClass("StarterGear")
            local BP = Player:FindFirstChildOfClass("Backpack")
            if SG then
                Tool:Clone().Parent = SG
            end
            if BP then
                Tool.Parent = BP
            end
        else
            warn(Id, "Is not a tool/gear.")
        end
    else
        warn(Info)
    end
end

return GetRBXgear