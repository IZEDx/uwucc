-- lib/config.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/config.ts"] = _G.__tracetrace["lib/config.ts"] or {}
package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__StringSlice = ____lualib.__TS__StringSlice
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local __TS__ArrayToSorted = ____lualib.__TS__ArrayToSorted
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["16"] = 11,["17"] = 11,["18"] = 11,["19"] = 17,["20"] = 17,["21"] = 18,["22"] = 12,["23"] = 13,["24"] = 14,["25"] = 20,["26"] = 21,["28"] = 23,["29"] = 16,["30"] = 26,["31"] = 27,["32"] = 28,["33"] = 29,["34"] = 30,["36"] = 26,["37"] = 34,["38"] = 35,["39"] = 36,["40"] = 37,["41"] = 34,["42"] = 40,["43"] = 41,["44"] = 41,["45"] = 40,["46"] = 44,["47"] = 45,["48"] = 46,["49"] = 47,["51"] = 50,["52"] = 51,["54"] = 54,["55"] = 56,["56"] = 57,["59"] = 59,["60"] = 60,["61"] = 60,["62"] = 60,["63"] = 60,["64"] = 60,["65"] = 60,["66"] = 60,["67"] = 60,["68"] = 60,["69"] = 60,["70"] = 66,["71"] = 67,["72"] = 68,["74"] = 70,["75"] = 70,["76"] = 70,["77"] = 71,["78"] = 72,["79"] = 73,["80"] = 74,["81"] = 75,["82"] = 76,["83"] = 77,["84"] = 78,["85"] = 79,["86"] = 80,["87"] = 81,["88"] = 81,["89"] = 81,["90"] = 81,["91"] = 81,["94"] = 85,["97"] = 89,["98"] = 90,["99"] = 44,["100"] = 93,["101"] = 94,["102"] = 95,["105"] = 97,["106"] = 99,["107"] = 100,["108"] = 101,["110"] = 104,["111"] = 105,["112"] = 106,["113"] = 107,["114"] = 108,["115"] = 109,["116"] = 110,["117"] = 111,["119"] = 113,["121"] = 116,["123"] = 119,["125"] = 122,["126"] = 93,["127"] = 125,["128"] = 126,["129"] = 127,["130"] = 128,["131"] = 129,["132"] = 130,["133"] = 130,["134"] = 130,["136"] = 130,["137"] = 131,["140"] = 134,["141"] = 135,["142"] = 125});
local ____exports = {}
____exports.Config = __TS__Class()
local Config = ____exports.Config
Config.name = "Config"
function Config.prototype.____constructor(self, file, data)
    self.file = file
    self.data = data
    self.loadCooldown = 3
    self._lastLoad = -math.huge
    self._order = {}
    for section in pairs(data) do
        self._order[section] = __TS__ObjectKeys(data[section])
    end
    self:load()
end
function Config.prototype.define(self, section, key, value)
    self:load()
    if not self:get(section, key) then
        self:set(section, key, value)
        self:save()
    end
end
function Config.prototype.set(self, section, key, value)
    local s = self.data[section] or ({})
    self.data[section] = s
    s[key] = value
end
function Config.prototype.get(self, section, key)
    local ____opt_0 = self.data[section]
    return ____opt_0 and ____opt_0[key]
end
function Config.prototype.load(self)
    if not fs.exists(self.file) then
        self:save()
        return self.data
    end
    if os.clock() < self._lastLoad + self.loadCooldown then
        return self.data
    end
    self._lastLoad = os.clock()
    local file = fs.open(self.file, "r")
    if not file then
        return
    end
    local currentSection = "default"
    local lines = __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(
                file.readAll(),
                "\n"
            ),
            function(____, line) return __TS__StringTrim(line) end
        ),
        function(____, line) return line ~= "" and not __TS__StringStartsWith(line, ";") and not __TS__StringStartsWith(line, "#") end
    )
    for ____, line in ipairs(lines) do
        if __TS__StringStartsWith(line, "[") then
            currentSection = __TS__StringSlice(line, 1, #line - 1)
        else
            local ____TS__StringSplit_result_2 = __TS__StringSplit(line, "=")
            local head = ____TS__StringSplit_result_2[1]
            local tail = __TS__ArraySlice(____TS__StringSplit_result_2, 1)
            local k = __TS__StringTrim(head)
            local v = __TS__StringTrim(table.concat(tail, "="))
            local parsed = v
            if v == "true" then
                parsed = true
            elseif v == "false" then
                parsed = false
            elseif tonumber(v) ~= nil then
                parsed = tonumber(v)
            elseif __TS__StringStartsWith(v, "\"") then
                parsed = __TS__StringSlice(
                    v,
                    1,
                    __TS__StringEndsWith(v, "\"") and -1 or 0
                )
            else
            end
            self:set(currentSection, k, parsed)
        end
    end
    file.close()
    return self.data
end
function Config.prototype.save(self)
    local file = fs.open(self.file, "w")
    if not file then
        return
    end
    local sections = __TS__ArrayToSorted(__TS__ObjectKeys(self.data))
    for ____, sectionName in ipairs(sections) do
        if sectionName ~= "default" then
            file.writeLine(("[" .. sectionName) .. "]")
        end
        for key in pairs(self.data[sectionName]) do
            local value = self:get(sectionName, key)
            if type(value) == "boolean" then
                value = value and "true" or "false"
            elseif type(value) == "number" then
                value = tostring(value)
            elseif type(value) == "string" then
                value = ("\"" .. value) .. "\""
            else
                value = ""
            end
            file.writeLine((key .. " = ") .. tostring(value))
        end
        file.writeLine("")
    end
    file.close()
end
function Config.prototype.extend(self, newData)
    local cfg = self
    cfg:load()
    for ____, section in ipairs(__TS__ObjectKeys(newData)) do
        for ____, key in ipairs(__TS__ObjectKeys(newData[section])) do
            local ____temp_3 = cfg:get(section, key)
            if ____temp_3 == nil then
                ____temp_3 = newData[section][key]
            end
            local value = ____temp_3
            cfg:set(section, key, value)
        end
    end
    cfg:save()
    return cfg
end
return ____exports
