import { GPUView } from "./gpu-view";
import { Node } from "./node";
import { Signal, signal } from "./signal";
import { Rect, Section } from "./types";

export function useHook<T>(create: (node: Node) => T): T {
	const node = Node.current;
	if (!node) throw new Error("hooks are only available from within UwUi.render()");
	const index = node.hookIndex++;
	const existing = node.hooks[index] as T | undefined;
	if (existing) return existing;
	const created = create(node);
	node.hooks[index] = created ?? {};
	return created;
}

export function useSignal<T>(initial: T): Signal<T> {
	return useHook(() => signal(initial));
}

export function useDerived<R>(fn: () => R) {
	return useHook(() => {
		let initial!: R;
		const signals = Signal.collect(() => {
			initial = fn();
		});
		const derived = signal(initial);
		for (const item of signals) {
			if (item instanceof Signal) {
				item.subscribe(() => {
					derived.value = fn();
				});
			}
		}
		return derived;
	});
}

export function useTick(forceTick = true) {
	const state = useHook((node) => {
		node.forceRender = forceTick;
		return { tickCount: 0 };
	});
	return state.tickCount++;
}

export function useEffect(effect: () => void | (() => void), deps: Signal<any>[]) {
	let cleanup: void | (() => void);
	const run = () => {
		if (cleanup) cleanup();
		cleanup = effect();
		return undefined;
	};
	const derived = useDerived(run);
	void derived;
}

export function useGPU(
	_options?: Partial<Section> | ((gpu: GPUView) => Partial<Section>),
): GPUView {
	const node = Node.current;
	if (!node || !node.gpu) throw new Error("useGPU is only available from within UwUi.render()");
	if (!_options) return node.gpu;
	const options = typeof _options === "function" ? _options(node.gpu) : _options;
	const clip = node.gpu.clip;

	let x = options.x ?? 0;
	let y = options.y ?? 0;
	let w = options.w ?? clip.w - x;
	let h = options.h ?? clip.h - y;

	if (w === 0) w = clip.w - x;
	if (h === 0) h = clip.h - y;

	if (options.mode !== "absolute") {
		if (math.abs(x) <= 1) x = x * clip.w;
		if (math.abs(y) <= 1) y = y * clip.h;
		if (math.abs(w) <= 1) w = w * clip.w;
		if (math.abs(h) <= 1) h = h * clip.h;
	}

	if (x < 0) x = clip.w + x;
	if (y < 0) y = clip.h + y;
	if (w < 0) w = clip.w - x + w;
	if (h < 0) h = clip.h - y + h;

	if (options.justify === "center") {
		x -= w / 2;
	} else if (options.justify === "right") {
		x -= w;
	}

	if (options.align === "middle") {
		y -= h / 2;
	} else if (options.align === "bottom") {
		y -= h;
	}

	node.gpu = node.gpu.createView({
		x,
		y,
		w,
		h,
	});
	node.opaque = options.opaque ?? node.opaque;
	return node.gpu;
}

export function use3D() {
	useHook((node) => {
		const display = node.gpu!.display;
		const gpu = node.gpu!.gpu;

		gpu.enableDeltaMode(display);

		gpu.setBackgroundOpacity(display, 0);
		gpu.setOpacity(display, 80);

		gpu.setupCamera(display, 50, 0.05, 100);
		gpu.setCameraPosition(display, 0, 0, -10);
		gpu.lookAt(display, 0, 0, 0);

		gpu.setBackfaceCulling(display, false);
		gpu.setPhongShading(display, true);

		gpu.clearLights(display);
		gpu.addAmbientLight(display, 255, 255, 255, 0.95);
		gpu.addDirectionalLight(display, -0.45, -0.85, -0.35, 255, 255, 255, 0.65);
		gpu.addDirectionalLight(display, 0.5, 0.25, -0.7, 120, 180, 255, 0.25);
	});
}

export function each<T, R>(items: T[] | Signal<T[]>, fn: (item: T, index: number) => R): R[] {
	const list = items instanceof Signal ? items.value : items;
	return list.map((v, i) => {
		const r = fn(v, i);
		if (r instanceof Node) {
			r.key = r.key ?? i;
		}
		return r;
	});
}
