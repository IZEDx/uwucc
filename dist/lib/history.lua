-- lib/history.ts
_G.__tracetrace = _G.__tracetrace or {}
_G.__tracetrace["lib/history.ts"] = _G.__tracetrace["lib/history.ts"] or {}
package.path = package.path .. ";../?.lua"
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["6"] = 5,["7"] = 5,["8"] = 5,["9"] = 9,["10"] = 9,["11"] = 9,["13"] = 9,["14"] = 6,["15"] = 7,["16"] = 9,["17"] = 11,["18"] = 12,["19"] = 13,["20"] = 13,["21"] = 14,["22"] = 14,["23"] = 11,["24"] = 17,["25"] = 18,["26"] = 19,["27"] = 17,["28"] = 22,["29"] = 23,["30"] = 24,["32"] = 22,["33"] = 28,["34"] = 29,["35"] = 30,["36"] = 28,["37"] = 33,["38"] = 34,["39"] = 33,["40"] = 37,["41"] = 38,["42"] = 37,["43"] = 41,["44"] = 42,["45"] = 43,["46"] = 44,["48"] = 46,["49"] = 41,["50"] = 49,["51"] = 50,["52"] = 51,["53"] = 52,["55"] = 54,["56"] = 49,["57"] = 57,["58"] = 58,["59"] = 59,["60"] = 60,["61"] = 61,["63"] = 63,["64"] = 57});
local ____exports = {}
____exports.History = __TS__Class()
local History = ____exports.History
History.name = "History"
function History.prototype.____constructor(self, _timespan)
    if _timespan == nil then
        _timespan = 10
    end
    self._timespan = _timespan
    self._times = {}
    self.items = {}
end
function History.prototype.add(self, value)
    self:chop()
    local ____self__times_0 = self._times
    ____self__times_0[#____self__times_0 + 1] = os.clock()
    local ____self_items_1 = self.items
    ____self_items_1[#____self_items_1 + 1] = value
end
function History.prototype.shift(self)
    table.remove(self.items, 1)
    table.remove(self._times, 1)
end
function History.prototype.chop(self)
    while #self._times > 0 and self._times[1] < os.clock() - self._timespan do
        self:shift()
    end
end
function History.prototype.clear(self)
    self.items = {}
    self._times = {}
end
function History.prototype.size(self)
    return #self._times
end
function History.prototype.get(self, i)
    return self.items[i + 1]
end
function History.prototype.oldest(self)
    self:chop()
    if self:size() == 0 then
        return nil
    end
    return self:get(0)
end
function History.prototype.youngest(self)
    self:chop()
    if self:size() == 0 then
        return nil
    end
    return self:get(self:size() - 1)
end
function History.prototype.timespan(self)
    self:chop()
    local oldest = self._times[1]
    if not oldest then
        return 0
    end
    return os.clock() - oldest
end
return ____exports
