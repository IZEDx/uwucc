import { clamp } from "../lib/math";

export type Thrusts = {
	fl: number;
	fr: number;
	bl: number;
	br: number;
};

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
