import { clamp, round } from "../math";
import { Pixels } from "./pixi";
import { normalizeChildren } from "./helpers";
import { MouseEvent, pullEvent, pullEventAs } from "../events";
import { printError, printValue, showHeader } from "../chalk";
import { Font } from "./font";
import { runSafe } from "../program";

const fpsFont = new Font({
	file: "disk/static/sigi-pixel-font-master/Sigi-5px-Condensed-Regular.json",
});

type ITerm = ITerminal & {
	/** @noSelf */
	getSize: (this: void, n?: number) => LuaMultiReturn<[number, number]>;
	/** @noSelf */
	drawPixels: (this: void, x: number, y: number, buf: number[][] | string[]) => any;
	/** @noSelf */
	setGraphicsMode: (this: void, n: number) => any;
};

export namespace UwUi {
	export type Props = Record<string, any> & {
		onClick?: () => void;
		stale?: string;
	};
	export type Children = any[];
	export type Factory = (target: Pixels) => ClassComponent;

	export type FunctionComponent<P extends Props = Props, C extends Children = Children> = (
		props: P,
		...children: C
	) => Factory | Factory[];

	export type Component<P extends Props = Props, C extends Children = Children> =
		| FunctionComponent<P, C>
		| typeof ClassComponent<P, C>;

	export type InferProps<C extends Component<any, any>> =
		C extends Component<infer P, any> ? P : never;

	export type InferChildren<C extends Component<any, any>> =
		C extends Component<any, infer C> ? [...C] : never;

	export type Options = {
		term: ITerm;
		x: number;
		y: number;
		w: number;
		h: number;
		bg: number;
		showFps?: boolean;
	};
}

export class UwUi {
	public readonly options: UwUi.Options;
	public readonly target: Pixels;
	public colorDepth = 20;
	stopped = true;
	paused = false;

	constructor(options: Partial<UwUi.Options>) {
		this.options = {
			term: term,
			x: 0,
			y: 0,
			w: 0,
			h: 0,
			bg: 15,
			...options,
		};

		// clear screen buffer and switch mode
		this.options.term.setGraphicsMode(2);
		this.options.term.clear();

		const [W, H] = this.options.term.getSize(2);

		// clamp x,y to W,H
		this.options.x = clamp(this.options.x, 0, W);
		this.options.y = clamp(this.options.y, 0, H);

		// clamp w,h between x,y and W,H
		this.options.w = clamp(this.options.w, 0, W - this.options.x);
		this.options.h = clamp(this.options.h, 0, H - this.options.y);

		// full size on w,h being 0
		if (this.options.w === 0) this.options.w = W - this.options.x;
		if (this.options.h === 0) this.options.h = H - this.options.y;

		this.target = Pixels.new(this.options.w, this.options.h, this.options.bg);
	}

	private _lastFps = 0;
	render(root: UwUi.Factory, dt = 0) {
		const { x, y, term, showFps } = this.options;
		const node = root(this.target);
		node.render(dt);
		if (showFps && dt > 0) {
			const fps = this._lastFps + (1 / dt - this._lastFps) * 0.9;
			this._lastFps = fps;
			this.target.drawText(x + 5, y + 5, fpsFont, 10, string.format("FPS: %.1f", fps));
		}
		term.drawPixels(x, y, this.target.buffer);
	}

	click(root: UwUi.Factory, x: number, y: number) {
		root(this.target).click(x, y);
	}

	stop() {
		this.stopped = true;
	}

	defer(fn: () => any) {
		this.paused = true;
		this.options.term.setGraphicsMode(false);
		term.clear();
		term.setCursorPos(1, 1);
		showHeader(":3");
		fn();
		this.options.term.setGraphicsMode(2);
		this.paused = false;
	}

	run(root: () => UwUi.Factory) {
		if (!this.stopped) throw new Error("already running :3");
		this.stopped = false;

		let last = os.clock();
		const render = () => {
			if (this.paused) {
				sleep(0.1);
			} else {
				const now = os.clock();
				const dt = math.min(now - last, 1);
				last = now;
				parallel.waitForAll(
					() => this.render(root(), dt),
					() => sleep(0),
				);
			}
		};

		parallel.waitForAny(
			() => {
				while (!this.stopped) {
					runSafe(render);
				}
			},
			() => {
				while (!this.stopped) {
					runSafe(() => {
						const event = pullEventAs(MouseEvent, "mouse_click");
						if (this.stopped) return;
						if (event?.button === 1 && !this.paused) {
							this.click(root(), event.x, event.y);
						}
					});
				}
			},
		);
	}
}

export namespace UwUi {
	/** @noSelf */
	export function node<
		Comp extends UwUi.Component,
		P extends UwUi.InferProps<Comp>,
		C extends UwUi.InferChildren<Comp>,
	>(component: Comp, props: P, ...children: C): Factory[] | Factory {
		props = { ...props };
		children = normalizeChildren(children) as C;
		if (typeof component === "function") {
			const funComp = component as UwUi.FunctionComponent<P, C>;
			return funComp(props, ...children);
		} else {
			const ClassComp = component as typeof UwUi.ClassComponent<P, C>;
			const comp = new ClassComp(props, ...children);
			return (target) => {
				comp.target = comp.translate(target);
				return comp;
			};
		}
	}

	export class ClassComponent<P extends Props = Props, C extends Children = Children> {
		type = "Component";
		target!: Pixels;
		props: P;
		children: C;

		constructor(props: P, ...children: C) {
			this.props = props;
			this.children = children;
		}

		translate(target: Pixels): Pixels {
			return target;
		}

		render(dt: number) {
			if (!this.props.stale) {
				this.forEachChild((child) => child(this.target).render(dt));
				return;
			}
			if (!this.target.cache.has(this.props.stale)) {
				const buf = Pixels.new(this.target.w, this.target.h, this.target.base);
				this.forEachChild((child) => child(buf).render(dt));
				this.target.cache.set(this.props.stale, buf.buffer);
			}
			this.target.drawPixels(0, 0, this.target.cache.get(this.props.stale)!);
		}

		click(x: number, y: number) {
			const [minX, minY, maxX, maxY] = this.target.getBounds();
			if (x > minX && x < maxX && y > minY && y < maxY) {
				let wasHandled = false;
				this.forEachChild((c) => {
					if (c(this.target).click(x, y)) {
						wasHandled = true;
					}
				});
				if (!wasHandled && this.props.onClick) {
					this.props.onClick();
					return true;
				}
				return wasHandled;
			}
			return false;
		}

		forEachChild(fn: (c: UwUi.Factory) => any) {
			parallel.waitForAll(
				...this.children
					.filter((c) => typeof c === "function")
					.map((c: UwUi.Factory) => () => fn(c)),
			);
			/*
			for (const node of this.children) {
				if (typeof node === "function") {
					fn(node as UwUi.Factory);
				}
			}
				*/
		}
	}
}
