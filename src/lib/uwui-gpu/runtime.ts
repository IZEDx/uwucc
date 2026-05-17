import { Node } from "./node";
import { GPUView } from "./gpu-view";
import { log } from "../util";

export namespace UwUi {
	export type Child = string | number | Node | undefined | Child[];
	export type Props = Record<string, any> & {
		key?: string;
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

	export function render(
		root: () => Node,
		gpu: DirectGPUPeripheral,
		display = gpu.autoDetectAndCreateDisplay(),
	) {
		if (!display) throw new Error("Display not available");

		gpu.setTransparentBackground(display, true);
		gpu.setTransparencyColor(display, -1, -1, -1);

		const info = gpu.getDisplayInfo(display);
		const tree = root();
		const rootView = new GPUView(gpu, display, {
			x: 0,
			y: 0,
			w: info.pixelWidth,
			h: info.pixelHeight,
		});

		try {
			parallel.waitForAny(
				() => {
					let frame = 0;
					while (true) {
						frame += 1;
						parallel.waitForAll(
							() => {
								tree.render(rootView);
								gpu.updateDisplay(display);
							},
							() => sleep(0.05),
						);
					}
				},
				() => {
					while (true) {
						const e = os.pullEvent();
						if (e[0] === "Terminate") return;
					}
				},
			);
		} catch (e) {
			throw e;
		} finally {
			gpu.removeDisplay(display);
		}
	}
}
