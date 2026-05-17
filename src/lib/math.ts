/** @noSelf */
export function lerp(a: number, b: number, amt: number) {
	return a + (b - a) * amt;
}

/** @noSelf */
export function clamp(v: number, lo: number, hi: number): number {
	return math.max(lo, math.min(hi, v));
}

/** @noSelf */
export function round(v: number): number {
	return math.floor(v + 0.5);
}

export function range(n: number) {
	const arr = [] as number[];
	for (let i = 0; i < n; i++) {
		arr.push(i);
	}
	return arr;
}

export function sum(ns: number[]) {
	let sum = 0;
	for (const n of ns) {
		sum += n;
	}
	return sum;
}

export function niceStep(value: number) {
	const exponent = math.floor(math.log10(value));
	const base = math.pow(10, exponent);
	const normalized = value / base;
	if (normalized <= 1) return base;
	if (normalized <= 2) return 2 * base;
	if (normalized <= 5) return 5 * base;
	return 10 * base;
}

export function formatValue(value: number) {
	const absValue = math.abs(value);
	if (absValue < 0.01) return value.toFixed(3);
	if (absValue < 0.1) return value.toFixed(2);
	return value.toFixed(1);
}
