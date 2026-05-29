import { clamp } from "../../math";
import { RGB } from "../colors";
import { useGPU, useTick } from "../hooks";
import { UwUi } from "../runtime";
import { extract, extractObject, Getters } from "../signal";
import { Pos, Section } from "../types";

export function Key(props: { key: string }, ...children: UwUi.Children) {
	return children;
}

export function If(props?: any, ...children: any[]) {
	if (props?.condition || props === true) {
		return children;
	} else {
		return [];
	}
}

export namespace Box {
	export type Props = Partial<Section> & {
		bg?: RGB;
		border?: RGB;
		key?: string | number;
		radius?: number;
		filled?: boolean;
		/** @noSelf */
		onInput?: (e: DirectGPU.InputEvent) => void;
	};
}

export function Box(_props: Getters<Box.Props>, ...children: any[]) {
	const props = extractObject(_props);
	const gpu = useGPU({
		...props,
		opaque: !!props.bg && (props.filled ?? true),
	});
	const rect = { x: 0, y: 0, w: gpu.clip.w, h: gpu.clip.h };
	if (props.bg) gpu.drawRoundedRect(rect, props.radius ?? 0, props.bg, true);
	if (props.border) gpu.drawRoundedRect(rect, props.radius ?? 0, props.border, false);

	return children;
}

export namespace Text {
	export type Props = Partial<Section> & {
		color?: RGB;
		size?: number;
		style?: DirectGPU.FontStyle;
	};
}

export function Text(_props: Getters<Text.Props>, ...children: any[]) {
	const props = extractObject(_props);
	const text = children.map((s) => tostring(s)).join(" ");
	const color = props.color ?? { r: 255, g: 255, b: 255 };
	const size = props.size ?? 10;
	const font = "Segoue UI";
	const style = props.style ?? "bold";
	const gpu = useGPU((gpu) => {
		const metrics = gpu.gpu.measureText(text, "Segoue UI", size, style);
		return { ...props, w: props.w ?? metrics.width, h: props.h ?? metrics.height };
	});
	gpu.drawTextWrapped(text, { x: 0, y: 0 }, color, gpu.clip.w, size / 2, font, size, style);
	//gpu.drawRoundedRect({ x: 0, y: 0, w: gpu.clip.w, h: gpu.clip.h }, 10, color, false);
	return [];
}

export namespace Line {
	export type Props = {
		smoothing?: number;
	};

	export type Point = Pos & {
		color?: RGB;
	};
}

export function Line(props: Line.Props, ...points: Line.Point[]) {
	const gpu = useGPU();
	let y = points[0].y;
	const smoothing = 1 - clamp(props.smoothing ?? 0.5, 0, 1);
	for (let i = 0; i < points.length - 1; i++) {
		const p = points[i];
		const n = points[i + 1];
		const ny = y + (n.y - y) * smoothing;
		gpu.drawLine(p.x, y, n.x, ny, p.color?.r ?? 255, p.color?.g ?? 255, p.color?.b ?? 255);
		y = ny;
	}
}
