import { base64Encode, readFile } from "../../util";
import { rgb, RGB } from "../colors";
import { useDerived, useGPU, useTick } from "../hooks";
import { extract, Getters } from "../signal";
import { Rect } from "../types";

export namespace Img {
	export type Props = Partial<Rect> & {
		file: string;
	};
}

export function Img(props?: Getters<Img.Props>) {
	const gpu = useGPU();
	const data = useDerived(() => {
		const file = extract(props?.file);
		if (!file) return;
		const data = base64Encode(readFile(file) ?? "");
		return data; //gpu.gpu.decodePNG(data); //, extract(props?.w) ?? 0, extract(props?.h) ?? 0);
		//return svg ? extractSvgPaths(svg) : [];
	});

	const x = extract(props?.x) ?? 0;
	const y = extract(props?.y) ?? 0;
	const w = extract(props?.w) ?? 0;
	const h = extract(props?.h) ?? 0;

	if (data.value) gpu.gpu.loadPNGRegionBytes(gpu.display, data.value, x, y, w, h);
	//gpu.drawSVGPath;
}

export namespace Svg {
	export interface Props {
		file: string;
		x?: number;
		y?: number;
		col?: RGB;
		scale?: number;
	}
}

export function Svg(props?: Getters<Svg.Props>) {
	const gpu = useGPU();
	const paths = useDerived(() => {
		const file = extract(props?.file);
		if (!file) return [];
		const svg = readFile(file);
		return svg ? extractSvgPaths(svg) : [];
	});

	const x = extract(props?.x) ?? 0;
	const y = extract(props?.y) ?? 0;
	const scale = extract(props?.scale) ?? 1;
	const col = extract(props?.col) ?? rgb(255, 255, 255);
	for (const p of paths.value) {
		gpu.drawSVGPath(p, x, y, scale, col.r, col.g, col.b);
	}
}

function extractSvgPaths(svg: string): string[] {
	const paths: string[] = [];

	// Iterate over all <path ...> or <path .../> elements
	// Lua: for block in string.gmatch(svg, "<path%s(.-)/>") do ... end
	// We need two passes: self-closing and non-self-closing paths

	// Pass 1: self-closing  <path ... />
	let pos = 0;
	while (pos < svg.length) {
		const tagStart = svg.indexOf("<path", pos);
		if (tagStart === -1) break;

		// Find the end of this tag (either /> or >)
		const selfClose = svg.indexOf("/>", tagStart);
		const normalClose = svg.indexOf(">", tagStart);

		if (selfClose === -1 && normalClose === -1) break;

		// Pick the closer end
		let tagEnd: number;
		if (selfClose === -1) tagEnd = normalClose;
		else if (normalClose === -1) tagEnd = selfClose;
		else tagEnd = Math.min(selfClose, normalClose);

		const tagContent = svg.slice(tagStart, tagEnd + 2);

		const d = extractDAttribute(tagContent);
		if (d !== null) paths.push(d);

		pos = tagEnd + 1;
	}

	return paths;
}

function extractDAttribute(tag: string): string | null {
	// Find  d="..."  or  d='...'
	// Lua equivalent:
	//   string.match(tag, ' d="([^"]*)"') or string.match(tag, " d='([^']*)'")

	// Try double-quoted first
	const dqKey = ' d="';
	let attrStart = tag.indexOf(dqKey);
	if (attrStart !== -1) {
		const valueStart = attrStart + dqKey.length;
		const valueEnd = tag.indexOf('"', valueStart);
		if (valueEnd !== -1) {
			return tag.slice(valueStart, valueEnd);
		}
	}

	// Try single-quoted
	const sqKey = " d='";
	attrStart = tag.indexOf(sqKey);
	if (attrStart !== -1) {
		const valueStart = attrStart + sqKey.length;
		const valueEnd = tag.indexOf("'", valueStart);
		if (valueEnd !== -1) {
			return tag.slice(valueStart, valueEnd);
		}
	}

	// Try d= without leading space (start of attributes or after newline)
	// handles edge case: <path\nd="..."
	const fallbackDq = 'd="';
	attrStart = tag.indexOf(fallbackDq);
	if (attrStart !== -1) {
		// Make sure it's an attribute boundary (preceded by whitespace or is at start)
		const charBefore = attrStart > 0 ? tag[attrStart - 1] : " ";
		if (charBefore === " " || charBefore === "\n" || charBefore === "\t") {
			const valueStart = attrStart + fallbackDq.length;
			const valueEnd = tag.indexOf('"', valueStart);
			if (valueEnd !== -1) {
				return tag.slice(valueStart, valueEnd);
			}
		}
	}

	return null;
}
