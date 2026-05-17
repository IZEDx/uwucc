import { round } from "../math";
import { pixelBuffer } from "./helpers";

export type FontFile = {
	name: string; // name of font
	height: number; // height in "pixels"
	glyphs: {
		// list of glyphs
		name: string; // descriptive name
		width: number; // width in "pixels"
		codepoint: number; // Unicode codepoint i.e. 74 = U+004A
		coords: [number, number][]; // list of pixels (X,Y coordinates)
	}[];
};

export type FontOptions = {
	file: string | FontFile;
	spacing: {
		x: number;
		y: number;
	};
};

const placeholderCol = string.char(1);

export class Font {
	options: FontOptions;
	data: FontFile;

	constructor(options?: Partial<FontOptions>) {
		this.options = {
			spacing: {
				x: 2,
				y: 2,
			},
			file: "disk/static/sigi-pixel-font-master/Sigi-7px-Regular.json",
			...options,
		};
		if (typeof this.options.file === "string") {
			const [fontFile] = fs.open(this.options.file, "r");
			this.data = textutils.unserialiseJSON(fontFile?.readAll() ?? "") as FontFile;
			fontFile?.close();
		} else {
			this.data = this.options.file;
		}
	}

	getGlyphs(s: string) {
		const e = string.byte("#");
		const emptyGlyph = this.data.glyphs.find((g) => g.codepoint === e)!;
		return s.split("").map((c) => {
			const b = string.byte(c);
			return this.data.glyphs.find((g) => g.codepoint === b) || emptyGlyph;
		});
	}

	getSize(...args: (string | number)[]) {
		const text = args.filter((s) => typeof s === "string").join("");
		let w = 0;
		let h = 0;
		for (const line of text.split("\n")) {
			const glyphs = this.getGlyphs(line.toUpperCase());
			let lineWidth = 0;
			for (const g of glyphs) {
				lineWidth += g.width + this.options.spacing.x;
			}
			w = math.max(w, lineWidth);
			h += this.data.height + this.options.spacing.y;
		}
		return [w, h];
	}

	render(...args: (string | number)[]) {
		const text = args.filter((s) => typeof s === "string").join("");
		const [w, h] = this.getSize(text);
		const pixels = pixelBuffer(w, h, 0);
		const glyphHeight = this.data.height;

		let color = 1;
		let offsetX = this.options.spacing.x / 2;
		let offsetY = this.options.spacing.y / 2;
		for (let i = 0; i < args.length; i++) {
			let part = args[i];
			if (typeof part === "number") {
				color = part;
			} else {
				const glyphs = this.getGlyphs(part.toUpperCase());
				for (let pos = 0; pos < part.length; pos++) {
					const char = part[pos];
					if (char === "\n") {
						offsetX = 0;
						offsetY += this.data.height + this.options.spacing.y;
					} else {
						const glyph = glyphs[pos];
						for (const [x, y] of glyph.coords) {
							pixels[round(y + offsetY)][round(x + offsetX)] = color;
						}
						offsetX += glyph.width + this.options.spacing.x;
					}
				}
			}
		}

		return { pixels, w, h, text };
	}
}
