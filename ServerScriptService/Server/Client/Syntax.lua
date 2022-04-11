local Syntax = {
	Highlights = {
		-- lua keywords
		['nil'] = "49, 137, 221",
		['true'] = "49, 137, 221",
		['false'] = "49, 137, 221",
		['self'] = "49, 137, 221",
		['local'] = "197, 134, 192",
		['function'] = "197, 134, 192",
		['if'] = "49, 137, 221",
		['do'] = "49, 137, 221",
		['next'] = "49, 137, 221",
		['and'] = "49, 137, 221",
		['while'] = "49, 137, 221",
		['not'] = "49, 137, 221",
		['or'] = "49, 137, 221",
		['else'] = "49, 137, 221",
		['elseif'] = "49, 137, 221",
		['break'] = "49, 137, 221",
		['repeat'] = "49, 137, 221",
		['wait'] = "49, 137, 221",
		['--'] = "106, 153, 85",
		['[['] = "106, 153, 85",
		["]]"] = "106, 153, 85",
		["[=[["] = "106, 153, 85",
		["]=]]"] = "106, 153, 85",
		-- math symbols
		["+"] = "220, 220, 170",
		["-"] = "220, 220, 170",
		["/"] = "220, 220, 170",
		["^"] = "220, 220, 170",
		["%"] = "220, 220, 170",
		-- compound assignments
		["+="] = "220, 220, 170",
		["-="] = "220, 220, 170",
		["*="] = "220, 220, 170",
		["^="] = "220, 220, 170",
		["/="] = "220, 220, 170",
		["%="] = "220, 220, 170",
		["..="] = "220, 220, 170",
        -- numbers
        ["%d+"] = "",
		-- luau keywords
		['game'] = "86, 156, 214",
		[''] = {}
    }
}
Syntax.__index = Syntax

function Syntax:FormatColor(Color, String)
    return "<font color=\"rgb(".. Color .. ")\">".. String .."</font>"
end

function Syntax:FormatFont(Font, String)
    local Rich = Font:sub(1,1):lower()
    return "<\"".. Rich .."\">".. String .."</\"".. Rich .."\">"
end

function Syntax:Highlight(Code_String)
    local c_s = Code_String
    for Str, RGB in next, self.Highlights do
        c_s = c_s:gsub('%A'.. Str, function(k)
            return k:gsub(Str, function(x)
                return self:FormatColor(RGB, x)
            end)
        end)
    end
end

function Syntax:RemoveHighlightingComponents(Code_String)
    local Rem = Code_String:gsub('<[^>]+>', "")
    return Rem
end

function Syntax:CreateHighlight()
    
end

return Syntax