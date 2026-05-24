import { Node } from "./node";
import { GPUView } from "./gpu-view";
import { log } from "../util";
import { printValue } from "../chalk";

let renderFns: (() => any)[] = [];
let inputFns: (() => any)[] = [];

export namespace UwUi {
	export const gpu = peripheral.find("directgpu")[0] as DirectGPUPeripheral;
	export const monitors = gpu.autoDetectMonitors().monitors;
	sleep(0);

	export type Child = string | number | Node | undefined | Child[];
	export type Props = Record<string, any> & {
		key?: string;
		/** @noSelf */
		onInput?: (event: DirectGPU.InputEvent) => void;
	};
	export type Children = Child[];

	export type Component<P extends Props = Props, C extends Children = Children> = (
		props: P,
		...children: C
	) => Node[] | Node;

	/** @noSelf */
	export function node<P extends Props, C extends Children>(
		component: Component<P, C>,
		props: P & { key?: string | number },
		...children: C
	): Node<P, C> {
		return new Node<P, C>(component, props ?? ({} as P), children as C, props?.key);
	}

	export function clear() {
		renderFns = [];
		inputFns = [];
		gpu.clearAll3DModels();
		gpu.clearAllDisplays();
		for (const display of gpu.listDisplays()) {
			gpu.removeDisplay(display);
		}
	}

	export function mount(
		root: () => Node,
		gpu: DirectGPUPeripheral,
		display = gpu.autoDetectAndCreateDisplay(),
	) {
		if (!display) throw new Error("Display not available");

		let frame = 0;
		const info = gpu.getDisplayInfo(display);
		const tree = root();
		const rootView = new GPUView(gpu, display, {
			x: 0,
			y: 0,
			w: info.pixelWidth,
			h: info.pixelHeight,
		});

		renderFns.push(() => {});

		inputFns.push(() => {
			if (gpu.hasEvents(display)) {
				const event = gpu.pollEvent(display);
				if (event && event.type && event.x && event.y) {
					tree.input(event);
				}
			}
		});
	}

	export function render(root: () => Node, monitor = monitors[0], resolution = 1) {
		const display = gpu.createDisplay(
			monitor.x,
			monitor.y,
			monitor.z,
			monitor.facing,
			monitor.width,
			monitor.height,
		);
		if (!display) throw new Error("Display not available");

		let frame = 0;
		const info = gpu.getDisplayInfo(display);
		const tree = root();
		const rootView = new GPUView(gpu, display, {
			x: 0,
			y: 0,
			w: info.pixelWidth,
			h: info.pixelHeight,
		});

		parallel.waitForAny(
			() => {
				let lastTime = os.clock() - 0.05;
				while (true) {
					const now = os.clock();
					const dt = now - lastTime;
					lastTime = now;

					parallel.waitForAll(
						() => sleep(0),
						() => {
							tree.render(rootView, frame, dt);
							gpu.updateDisplay(display);
							frame += 1;
						},
					);
				}
			},
			() => {
				while (true) {
					if (gpu.hasEvents(display)) {
						const event = gpu.pollEvent(display);
						if (event && event.type && event.x && event.y) {
							tree.input(event);
						}
					}
					sleep(0.05);
				}
			},
			() => {
				while (true) {
					const e = os.pullEvent();
					if (e[0] === "Terminate") return;
				}
			},
		);
	}
}
