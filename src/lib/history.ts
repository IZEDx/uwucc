export interface HistoryOptions {
	timespan?: number;
}

export class History<T> {
	private _times: number[] = [];
	public items: T[] = [];

	constructor(public _timespan = 10) {}

	add(value: T) {
		this.chop();
		this._times.push(os.clock());
		this.items.push(value);
	}

	shift() {
		this.items.shift();
		this._times.shift();
	}

	chop() {
		while (this._times.length > 0 && this._times[0] < os.clock() - this._timespan) {
			this.shift();
		}
	}

	clear() {
		this.items = [];
		this._times = [];
	}

	size() {
		return this._times.length;
	}

	get(i: number): T | undefined {
		return this.items[i];
	}

	oldest() {
		this.chop();
		if (this.size() === 0) {
			return undefined;
		}
		return this.get(0);
	}

	youngest() {
		this.chop();
		if (this.size() === 0) {
			return undefined;
		}
		return this.get(this.size() - 1);
	}

	timespan(): number {
		this.chop();
		const oldest = this._times[0];
		if (!oldest) {
			return 0;
		}
		return os.clock() - oldest;
	}
}

/*
local util = require "lib.util"

---@class History
local History = {}

---@param options? {timespan: number|nil}
function History:new(options)
    options = options or {}
    self._timespan = options.timespan or 10
    self._times = {}
    self.items = {}
end

function History:add(value)
    self:chop()
    table.insert(self._times, os.clock())
    table.insert(self.items, value)
end

function History:shift()
    table.remove(self.items, 1)
    table.remove(self._times, 1)
end

function History:chop()
    while self._times[1] and self._times[1] < os.clock() - self._timespan do
        self:shift()
    end
end

function History:clear()
    self.items = {}
    self._times = {}
end

function History:size()
    return #self._times
end

function History:get(i)
    return self.items[i]
end

function History:oldest()
    self:chop()
    if self:size() == 0 then
        return nil
    end
    return self:get(1)
end

function History:youngest()
    self:chop()
    if self:size() == 0 then
        return nil
    end
    return self:get(self:size())
end

function History:timespan()
    self:chop()
    local oldest = self._times[1]
    if not oldest then
        return 0
    end
    return os.clock() - oldest
end

return util.class(History)
*/
