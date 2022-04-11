--[[
    Author: interpreterK (717072114)
    MPS.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local obtain = _G.obtain

local S = obtain'S'
local MPS = S.MarketplaceService

local MPS_M = {
    Page = {}
}
MPS_M.__index = MPS_M

function MPS_M:GetInfo(Id, Type)
    local fetch, pInfo = pcall(MPS.GetProductInfo, MPS, Id, Type)
    if not fetch then
        warn(pInfo)
    end
    return fetch, pInfo
end

function MPS_M:GetPinfo(Id, Type)
    self.Page = {}
    local fetch, Info = self:GetInfo(Id, Type)
    if fetch then
        for Data, Value in next, Info do
            if type(Value) == "table" then
                for t_Data, t_Value in next, Value do
                    table.insert(self.Page, "[\""..tostring(Data).."\"][\""..tostring(t_Data).."\"] = \""..tostring(t_Value).."\". \n")
                end
            else
                table.insert(self.Page, "[\""..tostring(Data).."\"] = \""..tostring(Value).."\". \n")
            end
        end
        return table.concat(self.Page)
    end
    return nil
end

return MPS_M