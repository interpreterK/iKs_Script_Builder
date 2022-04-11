--[[
		vLua 5.1 - Lua written in Lua Virtual Machine
		---------------
		vLua is a virtual machine and compiler for dynamically compiling and executing Lua.
		It'll work on both client and server, regardless of LoadStringEnabled. This module is
		designed to be a drop in replacement for loadstring, meaning you can do the following:
		
		Example:
			local loadstring = require(workspace.Loadstring)
			local executable, compileFailReason = loadstring("print('hello from vLua!')")
			executable()
		
		Please note, vLua IS SLOWER COMPARED TO vanilla Lua, although Luau does improve performance.
		Do not attemptp to run performance intensive tasks without testing first, otherwise you
		may have a bad time.
		
		Interested in improving yourself as a programmer? Consider joining Bleu Pigs - Scripters, a community
		focused on self improving and showing off creations. Visit the link below to learn more
		https://devforum.roblox.com/u/bleupigs
		
		Changelog:
			[6142021]
				- updated FiOne to latest release https://github.com/Rerumu/FiOne/commit/5623a14a67750f00c56544e195f5a736b030b666
			[632021]
				- actually fixed loadstring second argument not setting environment
			[5312021]
				- fixed loadstring func not setting environment of compiled function
			[3222021]
				- fixed module erroring due to missing script variable
				- removed types until TypedLua is more stable/adopted
				- added an how to use example
		
			[372021]
				- updated  FiOne to latest release
				- migrated Yeuliang to improved version from Moonshine
		
		Credits:
			- FiOne LBI (created by same author as Rerubi) - https://github.com/Rerumu/FiOne
			- Yueliang 5 (Lua compiler in Lua) - http://yueliang.luaforge.net/
			- Moonshine (improved version of Yeuliang) - https://github.com/gamesys/moonshine
]]
local compile = require(script:WaitForChild("Yueliang"))
local createExecutable = require(script:WaitForChild("FiOne"))
getfenv().script = nil

return function(source, env)
	local executable
	local env = env or getfenv(2)
	local name = (env.script and env.script:GetFullName())
	local ran, failureReason = pcall(function()
		local compiledBytecode = compile(source, name)
		executable = createExecutable(compiledBytecode, env)
	end)
	
	if ran then
		return executable
	end
	return nil, failureReason
end