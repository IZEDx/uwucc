/*
(_G as any).__error = _G.error;
_G.error = (message: string, level?: number | undefined) => {
	printError(message);
	return (_G as any).__error(message, level) as never;
};
*/

export function pairs<T extends Record<any, any>>(obj: T): [keyof T, T[keyof T]][] {
	return Object.entries(obj);
}

export function memoize<F extends (...args: any[]) => any>(fn: F): F {
	const cache = {} as Record<string, [ReturnType<F>]>;
	return ((...args: Parameters<F>) => {
		const key = args.map((a) => tostring(a)).join(";");
		let entry = cache[key];
		if (!entry) {
			entry = [fn(...args)];
			cache[key] = entry;
		}
		return entry[0];
	}) as F;
}

export type Thrusts = {
	fl: number;
	fr: number;
	bl: number;
	br: number;
};

export function clamp(v: number, lo: number, hi: number): number {
	return math.max(lo, math.min(hi, v));
}

export function round(v: number): number {
	return math.floor(v + 0.5);
}

export function clampThrusts(thrusts: Thrusts, min: number = -1, max: number = 1): Thrusts {
	for (const [name, value] of Object.entries(thrusts)) {
		thrusts[name as keyof Thrusts] = clamp(value, min, max);
	}
	return thrusts;
}

export function centerValues(thrusts: Thrusts): Thrusts {
	// Center trim values around their average (removes global offset)
	let sum = 0;
	let count = 0;
	for (const value of Object.values(thrusts)) {
		sum += value;
		count++;
	}
	const avg = sum / count;
	for (const name in thrusts) {
		thrusts[name as keyof Thrusts] -= avg;
	}
	return thrusts;
}

export function normalizeThrusts(thrusts: Thrusts): Thrusts {
	let highest = 1;
	for (const v of Object.values(thrusts)) {
		highest = math.max(highest, math.abs(v));
	}
	for (const name in thrusts) {
		thrusts[name as keyof Thrusts] /= highest;
	}
	return thrusts;
}

export function computeRotorThrusts(
	base: number,
	pitchCmd: number,
	rollCmd: number,
	trim?: Thrusts,
): Thrusts {
	// X-frame mixer (top view):
	// FL: base + roll + pitch   FR: base - roll + pitch
	// BL: base + roll - pitch   BR: base - roll - pitch
	return {
		fl: base + rollCmd + pitchCmd + (trim?.fl || 0),
		fr: base - rollCmd + pitchCmd + (trim?.fr || 0),
		bl: base + rollCmd - pitchCmd + (trim?.bl || 0),
		br: base - rollCmd - pitchCmd + (trim?.br || 0),
	};
}

/*
export function map<T, U>(t: T[], fn: (v: T, i: number, t: T[]) => U): U[] {
	const result: U[] = [];
	for (let i = 0; i < t.length; i++) {
		result[i] = fn(t[i], i, t);
	}
	return result;
}
*/

const logFile = "disk/log";
const [file] = fs.open(logFile, "w");
file?.write("");
file?.close();

export function log(...args: any[]) {
	//const [file] = fs.open(logFile, "a");
	//if (!file) return;
	//file.writeLine(args.map((s) => tostring(s)).join(" "));
	//file.close();
}

export function getLuaFunctionLabel(fn: (...args: any[]) => any): string {
	const info = debug.getinfo(fn, "Sn");
	const name = info?.name;
	if (name && name.length > 0) return name;
	const src = info?.short_src ?? info?.source ?? "<fn>";
	const line = info?.linedefined ?? -1;
	return `${src}:${line}`;
}
