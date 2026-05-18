local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayForEach = ____lualib.__TS__ArrayForEach
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["11"] = 5,["12"] = 5,["13"] = 5,["14"] = 5,["15"] = 5,["16"] = 6,["17"] = 6,["18"] = 1,["19"] = 2,["20"] = 8,["21"] = 14,["22"] = 16,["23"] = 18,["24"] = 19,["25"] = 21,["26"] = 21,["27"] = 21,["28"] = 21,["29"] = 21,["30"] = 21,["31"] = 21,["32"] = 25,["33"] = 25,["34"] = 25,["35"] = 26,["36"] = 25,["37"] = 25,["38"] = 28,["39"] = 28,["40"] = 28,["41"] = 28,["42"] = 28,["43"] = 28,["44"] = 28,["45"] = 28,["46"] = 28,["47"] = 28,["48"] = 30,["49"] = 31,["50"] = 32,["51"] = 33,["52"] = 34,["53"] = 34,["54"] = 34,["55"] = 34,["56"] = 34,["57"] = 34,["58"] = 34,["59"] = 38,["60"] = 38,["61"] = 38,["62"] = 39,["63"] = 38,["64"] = 38,["65"] = 41,["66"] = 41,["67"] = 41,["68"] = 41,["69"] = 45,["70"] = 45,["71"] = 45,["72"] = 45,["73"] = 45,["74"] = 45,["75"] = 41,["76"] = 41,["79"] = 49,["80"] = 50});
local ____exports = {}
local ____chalk = require("lib.chalk")
local showHeader = ____chalk.showHeader
local ____print = ____chalk.print
local chalk = ____chalk.chalk
local printCentered = ____chalk.printCentered
local ____config = require("lib.config")
local Config = ____config.Config
term.clear()
term.setCursorPos(1, 1)
local config = __TS__New(Config, ".owo", {default = {gui = true}})
showHeader(":3")
printCentered(chalk.bgBlack.lightBlue, "Available programs:")
local root = "disk"
____print("")
local programs = __TS__ArrayMap(
    __TS__ArrayFilter(
        fs.list(root .. "/programs"),
        function(____, f) return __TS__StringEndsWith(f, ".lua") end
    ),
    function(____, f) return string.sub(f, 1, -5) end
)
__TS__ArrayForEach(
    programs,
    function(____, f)
        shell.setAlias(f, ((root .. "/programs/") .. f) .. ".lua")
    end
)
printCentered(
    chalk.bgBlack,
    table.concat(
        __TS__ArrayMap(
            programs,
            function(____, f) return chalk.pink(f) end
        ),
        chalk.lightGray(", ") or ","
    )
)
____print("")
for ____, file in ipairs(fs.list(root)) do
    local dir = ((root .. "/") .. file) .. "/programs/"
    if fs.isDir(dir) then
        local programs = __TS__ArrayMap(
            __TS__ArrayFilter(
                fs.list(dir),
                function(____, f) return __TS__StringEndsWith(f, ".lua") end
            ),
            function(____, f) return string.sub(f, 1, -5) end
        )
        __TS__ArrayForEach(
            programs,
            function(____, f)
                shell.setAlias((file .. "_") .. f, (dir .. f) .. ".lua")
            end
        )
        ____print(
            chalk.lightGray(" - "),
            __TS__StringTrim(chalk.black.bgPink(file)),
            chalk.lightGray.bgBlack(": "),
            table.concat(
                __TS__ArrayMap(
                    programs,
                    function(____, f) return chalk.white(f) end
                ),
                chalk.lightGray(", ") or ","
            )
        )
    end
end
____print("")
if config.data.default.gui then
end
return ____exports
