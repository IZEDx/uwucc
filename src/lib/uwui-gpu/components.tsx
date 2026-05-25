import { printValue } from "../chalk";
import { clamp } from "../math";
import { useSignal, useGPU, useTick, useHook, useDerived } from "./hooks";
import { UwUi } from "./runtime";
import { extract, Getters, MaybeGetter } from "./signal";
import { Pos, Pos3D, RGB, Rotation, Section } from "./types";

export type BoxProps = Partial<Section> & {
	bg?: RGB;
	border?: RGB;
	key?: string | number;
	radius?: number;
	filled?: boolean;
	debug?: boolean;
	/** @noSelf */
	onInput?: (e: DirectGPU.InputEvent) => void;
};

export function Box(props: BoxProps, ...children: any[]) {
	const gpu = useGPU({
		...props,
		opaque: !!props.bg && (props.filled ?? true),
	});
	const rect = { x: 0, y: 0, w: gpu.clip.w, h: gpu.clip.h };
	if (props.bg) gpu.drawRoundedRect(rect, props.radius ?? 0, props.bg, true);
	if (props.border) gpu.drawRoundedRect(rect, props.radius ?? 0, props.border, false);

	if (props.debug) {
		const ticks = useTick(false);
		gpu.drawText(tostring(ticks), 0, 0, 255, 255, 255, "Segoue UI", 14, "bold");
	}
	return children;
}

export type TextProps = Partial<Section> & {
	color?: RGB;
	size?: number;
	style?: DirectGPU.FontStyle;
};

export function Text(props: TextProps, ...children: any[]) {
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

export function Key(props: { key: string }, ...children: UwUi.Children) {
	return children;
}

export type LineProps = {
	smoothing?: number;
};

export type LinePoint = Pos & {
	color?: RGB;
};

export function Line(props: LineProps, ...points: LinePoint[]) {
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

export interface ModelProps {
	pos?: Partial<Pos3D>;
	rot?: Partial<Rotation>;
	col?: RGB;
	file: string;
	scale?: number;
	normalize?: boolean;
}

export function Model(props: Getters<ModelProps>) {
	const gpu = useGPU();
	const model = useDerived(() => {
		const model = useGPU().loadObjModel(extract(props.file), extract(props.normalize));
		return model;
	});

	const pos = { x: 0, y: 0, z: 0, ...extract(props.pos) };
	const rot = { pitch: 0, yaw: 0, roll: 0, ...extract(props.rot) };
	const col = { r: 255, g: 255, b: 255, ...extract(props.col) };

	gpu.gpu.draw3DModel(
		gpu.display,
		model.value.id,
		pos.x,
		pos.y,
		pos.z,
		rot.pitch,
		rot.yaw,
		rot.roll,
		extract(props.scale) ?? 1,
		col.r,
		col.g,
		col.b,
	);
}

export function If(props?: any, ...children: any[]) {
	if (props?.condition || props === true) {
		return children;
	} else {
		return [];
	}
}
