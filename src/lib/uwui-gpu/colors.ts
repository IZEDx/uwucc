import { clamp, round } from "../math";

export type RGB = { r: number; g: number; b: number };

export function rgb(r: number, g: number, b: number): RGB {
	return { r: clamp(round(r), 0, 255), g: clamp(round(g), 0, 255), b: clamp(round(b), 0, 255) };
}

export function hsl(h: number, s: number, l: number): RGB {
	if (s === 0) {
		return { r: l, g: l, b: l };
	} else {
		const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
		const p = 2 * l - q;
		return {
			r: hueToRgb(p, q, h + 1 / 3),
			g: hueToRgb(p, q, h),
			b: hueToRgb(p, q, h - 1 / 3),
		};
	}
}

function hueToRgb(p: number, q: number, t: number) {
	t = t % 1;
	if (t < 0) t += 1;
	if (t > 1) t -= 1;
	if (t < 1 / 6) return p + (q - p) * 6 * t;
	if (t < 1 / 2) return q;
	if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
	return p;
}
