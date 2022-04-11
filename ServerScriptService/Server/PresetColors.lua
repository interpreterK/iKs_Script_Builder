--[[
    Author: interpreterK (717072114)
    PresetColors.lua

    Generated in Visual Studio Cod e 2021
    Made for: iK's Script Builder (6883421860)
]]

return setmetatable({
    ["red"] = Color3.fromRGB(255, 0, 0),
    ["dark_red"] = Color3.fromRGB(150, 0, 0),
    ["green"] = Color3.fromRGB(0, 255, 0),
    ["dark_green"] = Color3.fromRGB(0, 150, 0),
    ["shrek_green"] = Color3.fromRGB(170, 255, 0),
    ["blue"] = Color3.fromRGB(0, 0, 255),
    ["dark_blue"] = Color3.fromRGB(0, 0, 150),
    ["purple"] = Color3.fromRGB(132, 0, 255),
    ["dark_purple"] = Color3.fromRGB(100, 0, 194),
    ["orange"] = Color3.fromRGB(255, 115, 0),
    ["dark_orange"] = Color3.fromRGB(200, 90, 0),
    ["yellow"] = Color3.fromRGB(255, 255, 0),
    ["dark_yellow"] = Color3.fromRGB(200, 200, 0),
    ["gold"] = Color3.fromRGB(255, 170, 0),
    ["pink"] = Color3.fromRGB(255, 105, 180),
    ["white"] = Color3.fromRGB(255, 255, 255),
    ["grey"] = Color3.fromRGB(150, 150, 150),
    ["gray"] = Color3.fromRGB(150, 150, 150),
    ["black"] = Color3.fromRGB(0, 0, 0),
    ["rainbow"] = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.24, Color3.fromRGB(255, 248, 37)), ColorSequenceKeypoint.new(0.48, Color3.fromRGB(39, 255, 1)), ColorSequenceKeypoint.new(0.68, Color3.fromRGB(92, 38, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(167, 7, 188))},
    ["black&white"] = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
    ["black_and_white"] = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))},
},{
    __index = function(t,v)
        return rawget(t,v) or Color3.fromRGB(255, 255, 255)
    end
})