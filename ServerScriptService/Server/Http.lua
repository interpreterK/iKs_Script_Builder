--[[
    Author: interpreterK (717072114)
    Http.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local Http = S.HttpService

local function GetAsync(Url)
    local fetch, HttpInfo = pcall(Http.GetAsync, Http, Url)
    if not fetch then
        warn(HttpInfo)
    end
    return fetch, HttpInfo
end

return GetAsync