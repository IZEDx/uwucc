import { lerp, clamp } from "../math";

const colIdxMap = {} as Record<string, number | undefined>;
let currentColIdx = 0;
let colsDepleted = false;

export class Color {
	static depth = 20;

	private _idx?: number;
	private quantizedR = 0;
	private quantizedG = 0;
	private quantizedB = 0;

	constructor(r: number, g: number, b: number) {
		this.quantizedR = math.floor(clamp(r, 0, 1) * Color.depth);
		this.quantizedG = math.floor(clamp(g, 0, 1) * Color.depth);
		this.quantizedB = math.floor(clamp(b, 0, 1) * Color.depth);
		this.register();
	}

	get value() {
		return {
			r: this.quantizedR / Color.depth,
			g: this.quantizedG / Color.depth,
			b: this.quantizedB / Color.depth,
		};
	}

	get key() {
		return this.quantizedR + ":" + this.quantizedG + ":" + this.quantizedB;
	}

	register() {
		const key = this.key;
		if (this.isRegistered) {
			this._idx = colIdxMap[key];
			return this._idx!;
		}

		currentColIdx = (currentColIdx + 1) % 200;
		if (currentColIdx === 0) colsDepleted = true;
		this._idx = 255 - currentColIdx;
		colIdxMap[key] = this._idx;

		if (colsDepleted) {
			const old = term
				.getPaletteColor(this._idx)
				.map((c) => math.floor(c * Color.depth))
				.join(":");
			colIdxMap[old] = undefined;
		}

		term.setPaletteColor(
			this._idx,
			this.quantizedR / Color.depth,
			this.quantizedG / Color.depth,
			this.quantizedB / Color.depth,
		);
		return this._idx!;
	}

	get isRegistered() {
		return colIdxMap[this.key] !== undefined;
	}

	get idx(): number {
		if (!this.isRegistered) return this.register();
		return this._idx!;
	}

	/** @noSelf */
	static hsl(h: number, s: number, l: number) {
		const { r, g, b } = hslToRgb(h, s, l);
		return new Color(r, g, b);
	}

	/** @noSelf */
	static rgb(r: number, g: number, b: number) {
		return new Color(r, g, b);
	}

	static gradient(resolution: number, ...steps: [Color, Color, ...Color[]]) {
		const gradientColors = [] as number[];
		for (let i = 0; i < steps.length - 1; i++) {
			const from = steps[i].value;
			const to = steps[i + 1].value;
			for (let j = 0; j < resolution; j++) {
				const t = j / resolution;
				gradientColors.push(
					new Color(lerp(from.r, to.r, t), lerp(from.g, to.g, t), lerp(from.b, to.b, t))
						.idx,
				);
			}
		}
		return {
			colors: gradientColors,
			vertical: (x: number, y: number) => {
				return gradientColors[math.floor(y * gradientColors.length)];
			},
			horizontal: (x: number, y: number) => {
				return gradientColors[math.floor(x * gradientColors.length)];
			},
		};
	}
}

/** @noSelf */
export function hslToRgb(h: number, s: number, l: number) {
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

/** @noSelf */
export function hueToRgb(p: number, q: number, t: number) {
	t = t % 1;
	if (t < 0) t += 1;
	if (t > 1) t -= 1;
	if (t < 1 / 6) return p + (q - p) * 6 * t;
	if (t < 1 / 2) return q;
	if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
	return p;
}
