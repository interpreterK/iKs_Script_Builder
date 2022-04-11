--[[
    Author: interpreterK (717072114)
    LocalTime.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local Time = {}
Time.__index = Time

function Time:GetTime()
    local date = os.date("*t")
    return string.format("%02d:%02d", ((date.hour % 24) - 1) % 12 + 1, date.min)
end

function Time:FormattedTime()
    local date = os.date("*t")
    return date.hour >= 12 and ("["..self:GetTime().." PM]: ") or date.hour <= 12 and ("["..self:GetTime().." AM]: ") or ("[???]: ")
end

function Time:Unix()
    return ("["..os.date("%X", os.time()).."]: ")
end

return Time