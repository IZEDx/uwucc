import { clamp, round } from "../math";
import { Font } from "./font";
import { pixelBuffer, PixelBuffer } from "./helpers";
import { UwUi } from "./uwui";

/** @noSelf */
export interface DrawTarget {
	getSize(mode?: boolean | number): LuaMultiReturn<[number, number]>;
	clear(): void;
	drawPixels(x: number, y: number, pixels: PixelBuffer): void;
}

type DT = DrawTarget;

export namespace Pixels {
	/** @noSelf */
	export type Renderer = (target: Pixels, dt: number) => void;
	/** @noSelf */
	export type GradientFn = (x: number, y: number) => Color;
}

export class Pixels implements DT {
	/** @noSelf */
	static new(w: number, h: number, base: Color | Pixels.GradientFn = 0) {
		w = math.ceil(w);
		h = math.ceil(h);
		const b = pixelBuffer(w, h, 0);
		return new Pixels(b, 0, 0, w, h, base);
	}

	base: Pixels.GradientFn;
	cache: Map<string, number[][]>;

	constructor(
		public readonly buffer: number[][],
		public readonly x = 0,
		public readonly y = 0,
		public readonly w = 0,
		public readonly h = 0,
		public readonly bg: Color | Pixels.GradientFn = 0,
		public readonly parent?: Pixels,
		public readonly root?: Pixels,
	) {
		this.cache = root?.cache ?? new Map<string, number[][]>();
		this.x = math.floor(x);
		this.y = math.floor(y);
		this.w = math.ceil(w);
		this.h = math.ceil(h);
		if (typeof this.bg === "number") {
			this.bg = clamp(round(this.bg), 0, 255);
			this.base = () => this.bg as number;
		} else {
			this.base = this.bg;
		}
		this.clear();
		//this.buffer = buffer2d(w, h, base);
	}

	getSize(mode?: number | boolean) {
		return [this.w, this.h] as LuaMultiReturn<[number, number]>;
	}

	section(
		offsetX = 0,
		offsetY = 0,
		width = this.w - offsetX,
		height = this.h - offsetY,
		base: Color | Pixels.GradientFn = 0,
	) {
		const minX = this.x;
		const minY = this.y;
		const maxX = this.x + this.w;
		const maxY = this.y + this.h;
		const x = clamp(minX + offsetX, minX, maxX);
		const y = clamp(minY + offsetY, minY, maxY);
		const w = clamp(width, 0, maxX - x);
		const h = clamp(height, 0, maxY - y);
		return new Pixels(this.buffer, x, y, w, h, base, this, this.root ?? this);
	}

	clear(col?: Pixels.GradientFn | number) {
		this.drawGradient(typeof col === "number" ? () => col : col || this.base);
	}

	drawGradient(fn: Pixels.GradientFn) {
		const minX = this.x;
		const minY = this.y;
		const w = this.w;
		const h = this.h;
		const maxX = minX + w;
		const maxY = minY + h;
		const b = this.buffer;
		for (let y = minY; y < maxY; y++) {
			const row = b[y];
			for (let x = minX; x < maxX; x++) {
				const col = fn((x - minX) / w, (y - minY) / h);
				if (col > 0) row[x] = col;
			}
		}
	}

	getBounds() {
		const { x, y, w, h } = this;
		return [x, y, x + w, y + h] as const;
	}

	drawPixels(x: number, y: number, source: number[][]): void {
		const b = this.buffer;
		const minX = this.x;
		const minY = this.y;
		const maxX = this.x + this.w;
		const maxY = this.y + this.h;
		const offsetX = math.floor(x);
		const offsetY = math.floor(y);
		const sourceW = source[0]?.length || 0;
		const sourceH = source.length;
		for (let sourceY = 0; sourceY < sourceH; sourceY++) {
			y = minY + offsetY + sourceY;
			if (y >= minY && y < maxY) {
				const row = b[y];
				const srcRow = source[sourceY] || [];
				for (let sourceX = 0; sourceX < sourceW; sourceX++) {
					x = minX + offsetX + sourceX;
					if (x >= minX && x < maxX) {
						const col = srcRow[sourceX];
						if (col && col > 0 && b[y][x] !== col) {
							row[x] = col;
						}
					}
				}
			}
		}
	}

	/*
	transform(transformer: (x: number, y: number, col: Color) => Color) {
		const b = this.buffer;
		this.forEach((x, y, c) => {
			const c2 = transformer(x, y, c);
			if (c2 >= 0 && b[y][x] !== c2) {
				b[y][x] = c2;
				this.dirty = true;
			}
		});
	}

	forEach(fn: (x: number, y: number, col: Color) => any) {
		const [minX, minY, maxX, maxY] = this.getBounds();
		const b = this.buffer;
		for (let y = minY; y < maxY; y++) {
			for (let x = minX; x < maxX; x++) {
				fn(x, y, b[y][x]);
			}
		}
	}*/

	drawRect(x: number, y: number, w: number, h: number, col: Color) {
		this.drawPixels(x, y, pixelBuffer(w, h, col));
	}

	drawText(x: number, y: number, font: Font, ...args: (string | Color)[]) {
		this.drawPixels(x, y, font.render(...args).pixels);
	}
}

/** @noSelf */
/*
export function verticalGradient(
	w: number,
	h: number,
	colorA: number,
	colorB: number,
): PixelBuffer {
	const stepCount = colorB - colorA;
	const stepSize = round(h / stepCount);
	const pixels = [] as Buffer2D<number>;
	for (let step = 0; step < stepCount; step++) {
		pixels.push(...buffer2d(w, stepSize, colorA + step));
	}
	return pixels;
}

*/
