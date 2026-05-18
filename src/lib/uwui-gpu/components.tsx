import { clamp } from "../math";
import { useSignal, useGPU, useTick, useHook } from "./hooks";
import { UwUi } from "./runtime";
import { extract, MaybeGetter } from "./signal";
import { Pos, RGB, Section } from "./types";

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

export function Scene(props: any, ...children: any[]) {
	useTick();
	const _gpu = useGPU();
	useHook(() => {
		const gpu = _gpu.gpu;
		const display = _gpu.display;
		gpu.setupCamera(display, 50, 0.05, 100);
		gpu.setCameraPosition(display, 10, 0, -30);
		gpu.lookAt(display, 20, 0, 10);

		gpu.setBackfaceCulling?.(display, false);
		gpu.setPhongShading?.(display, true);

		gpu.clearLights(display);
		gpu.addAmbientLight(display, 255, 255, 255, 0.95);
		gpu.addDirectionalLight(display, -0.45, -0.85, -0.35, 255, 255, 255, 0.65);
		gpu.addDirectionalLight(display, 0.5, 0.25, -0.7, 120, 180, 255, 0.25);
	});

	return children;
}

export interface ModelProps {
	pos?: MaybeGetter<{ x: number; y: number; z: number }>;
	rot?: MaybeGetter<{ pitch: number; yaw: number; roll: number }>;
	file: string;
}

export function Model(props: ModelProps) {
	const _gpu = useGPU();
	const gpu = _gpu.gpu;
	let modelId = -1;
	useHook(() => {
		const file = fs.open(props.file, "r")[0];
		const objData = file?.readAll()!;
		modelId = gpu.load3DModel(objData);
		file?.close();
	});

	if (modelId <= 0) return;

	const pos = extract(props.pos);
	const rot = extract(props.rot);
	gpu.draw3DModel(
		_gpu.display,
		modelId,
		pos?.x ?? 0,
		pos?.y ?? 0,
		pos?.z ?? 0,
		rot?.pitch ?? 0, //math.deg(-pitch),
		rot?.yaw ?? 0,
		rot?.roll ?? 0, //math.deg(-roll),
		0.15, //MODEL_SCALE,
		255, //MODEL_R,
		255, //MODEL_G,
		255, //MODEL_B,
	);
}
