import { clamp, round } from "../math";
import { Pixels } from "./pixi";
import { normalizeChildren } from "./helpers";
import { MouseEvent, pullEvent, pullEventAs } from "../events";
import { printValue } from "../chalk";

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
	};
	export type Children = any[];
	export type Factory = (target: Pixels) => ClassComponent | ClassComponent[];

	export type FunctionComponent<P extends Props = Props, C extends Children = Children> = (
		props: P,
		...children: C
	) => Factory;

	export type Component<P extends Props = Props, C extends Children = Children> =
		| FunctionComponent<P, C>
		| typeof ClassComponent<P, C>;

	export type InferProps<C extends Component<any, any>> =
		C extends Component<infer P, any> ? P : never;

	export type InferChildren<C extends Component<any, any>> =
		C extends Component<any, infer C> ? [...C] : never;
}

export class UwUi {
	public readonly term: ITerm;
	public readonly target: Pixels;
	public colorDepth = 20;

	constructor(
		_term: ITerm = term,
		public readonly x = 0,
		public readonly y = 0,
		public readonly w = 0,
		public readonly h = 0,
		public readonly bg = 16,
	) {
		this.term = _term;
		this.term.setGraphicsMode(2);
		const [W, H] = this.term.getSize(2);
		this.x = clamp(x, 0, W);
		this.y = clamp(y, 0, H);
		this.w = clamp(w, 0, W - this.x);
		this.h = clamp(h, 0, H - this.y);
		if (this.w === 0) this.w = W - this.x;
		if (this.h === 0) this.h = H - this.y;
		this.target = Pixels.new(this.w, this.h, bg);
	}

	/*
	renderLoad(root: UwUi.Component<{}, []>, speed = 1) {
		//this.target.clear();
		root({}).render(this.target, 0);
		let y = this.y;
		for (const row of this.target.buffer) {
			this.term.drawPixels(this.x, y++, [row]);

			if (y % round(speed) === 0) {
				sleep(0);
				speed += 0.9;
			}
		}
	}
	*/

	render(root: UwUi.Factory, dt = 0) {
		//this.target.clear();
		const nodes = root(this.target);
		if (Array.isArray(nodes)) {
			for (const node of nodes) {
				node.render(dt);
			}
		} else {
			nodes.render(dt);
		}

		this.term.drawPixels(this.x, this.y, this.target.buffer);
	}

	run(root: () => UwUi.Factory) {
		parallel.waitForAny(
			() => {
				let last = os.clock();
				while (true) {
					const now = os.clock();
					const dt = now - last;
					parallel.waitForAll(
						() => this.render(root(), dt),
						() => sleep(0),
					);
				}
			},
			() => {
				while (true) {
					const event = pullEventAs(MouseEvent, "mouse_click");
					if (event?.button === 1) {
						const nodes = root()(this.target);
						if (Array.isArray(nodes)) {
							for (const node of nodes) {
								node.click(event.x, event.y);
							}
						} else {
							nodes.click(event.x, event.y);
						}
					}
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
	>(component: Comp, props: P, ...children: C): Factory {
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
			this.forEachChild((c) => {
				const _nodes = c(this.target);
				const nodes = Array.isArray(_nodes) ? _nodes : [_nodes];
				for (const node of nodes) {
					node.render(dt);
				}
			});
		}

		click(x: number, y: number) {
			const [minX, minY, maxX, maxY] = this.target.getBounds();
			if (x > minX && x < maxX && y > minY && y < maxY) {
				let wasHandled = false;
				this.forEachChild((c) => {
					const _nodes = c(this.target);
					const nodes = Array.isArray(_nodes) ? _nodes : [_nodes];
					for (const node of nodes) {
						if (node.click(x, y)) {
							wasHandled = true;
						}
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
