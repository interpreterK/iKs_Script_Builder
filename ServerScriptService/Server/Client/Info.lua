--[[
    Author: interpreterK (717072114)
    Info.lua

    Generated in Visual Studio Code 2021
    Made for: iK's Script Builder (6883421860)
]]

local Version = "r1.3-5"
local Change_Log = [==[
[+] = Added
[-] = Removed
[*] = Changed
[!] = Info
[?] = Questionable
[X] = Scratched

-- == [GitHub Public Release Build] == --
! Play the real/rolling release game here: https://www.roblox.com/games/6883421860/iKs-Script-Builder

--
]==]

local Info = [==[
- Recommend copying and pasting this into notepad to read better (CTRL + A, CTRL + C, CTRL + V). -

------------= Script Console =------------

---- [ Game Acquires ] ----
1: "help" | "h"  - Shows the info/help panel.
2: "server/" | "ser/" | "s/" - Acquires server script usage.
3: "client/" | "cli/" | "c/" - Acquires client script usage.
4: "parallel/" | "par/" | "p/" - Acquires parallel script usage.
5: "cmd/" | "command/" - Acquires game command usage.
* Require only executions are possible after the server acquire (server/require(0)).

---- [ Server Combos ] ----
1: "raw/" | "r/"   - Sets the server script usage to raw format.
2: "paste/" | "p/" - Gets a server script source by a paste URL.
3: "gear/" | "g/"  - Loads a gear from the roblox catalog.

---- [ Client Combos ] ----
1: "raw/" | "r/"   - Sets the client script usage to raw format.
2: "paste/" | "p/" - Gets a client script source by a paste URL.
3: "info/" | "i/"  - Shows a models info via ID.

---- [ Argument Combos ] ----
1: "-c" | "-convert" | "-s" | "-server" - Gives a client like environment to a server environment. (This will cover variables such as "LocalPlayer", "RenderStepped", "GetMouse", "UserInputService", and "PlaybackLoudness".)

---- [ Scripting Environment ] ----
1: "owner" - Returns the executors Player instance.
2: "NLS(Source, Parent)" - Creates and runs a new localscript with a optional parent.
3: "NS(Source, Parent)" - Creates and runs a new script with a optional parent.
]==]

return {
    Version = Version,
    Change_Log = Change_Log,
    Info = Info
}