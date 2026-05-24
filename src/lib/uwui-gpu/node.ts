import { Signal, Unsub } from "./signal";
import { GPUView } from "./gpu-view";
import { printError } from "../chalk";
import { type UwUi } from "./uwui";

function flatten(children: any): Node[] {
	const out: Node[] = [];
	if (Array.isArray(children)) {
		for (const child of children) {
			out.push(...flatten(child));
		}
	} else if (children && children instanceof Node) {
		out.push(children);
	}
	return out;
}

export class Node<P extends UwUi.Props = any, C extends UwUi.Children = any> {
	static current?: Node;

	parent?: Node;
	inputChildren: C;
	children = [] as Node[];

	deps = new Set<Signal>();
	hooks = [] as any[];
	hookIndex = 0;
	tickSignal!: Signal<number>;

	dirty = true;
	gpu?: GPUView;
	opaque = false;
	dt = 0;
	frame = 0;

	private _forceRender = false;
	private disposers = [] as Unsub[];

	constructor(
		public component: UwUi.Component<P, C>,
		public props: P,
		children: C,
		public key?: string | number,
	) {
		this.inputChildren = children;
		this.children = flatten(children);
		for (const child of this.children) child.parent = this;
	}

	get forceRender() {
		return this._forceRender;
	}

	set forceRender(v: boolean) {
		if (v && this.parent && !this.opaque) {
			this.parent.forceRender = true;
		}
		this._forceRender = v;
	}

	keyOf(): string | number | undefined {
		return this.props?.key ?? this.key;
	}

	invalidate = () => {
		if (this.dirty) return;
		if (this.parent && !this.opaque) {
			this.parent.invalidate();
		} else {
			this.dirty = true;
		}
	};

	input(event: DirectGPU.InputEvent): boolean {
		if (!this.gpu) return false;
		const { x, y } = event;
		const { x: minX, y: minY, w, h } = this.gpu?.clip!;
		const maxX = minX + w;
		const maxY = minY + h;
		if (x > minX && x < maxX && y > minY && y < maxY) {
			let wasHandled = false;
			for (const child of this.children) {
				if (child.input(event)) {
					wasHandled = true;
				}
			}
			if (!wasHandled && this.props.onInput) {
				this.props.onInput(event);
				return true;
			}
			return wasHandled;
		}
		return false;
	}

	render(gpu: GPUView, frame: number, dt: number) {
		this.frame = frame;
		this.dt = dt;
		const prevNode = Node.current;
		Node.current = this;
		Signal.hook((signal) => {
			if (this.deps.has(signal)) return;
			this.deps.add(signal);
			this.disposers.push(signal.subscribe(() => this.invalidate()));
		});
		try {
			if (this.dirty || this.forceRender) {
				this.gpu = gpu;
				this.hookIndex = 0;
				const output = this.component(this.props, ...this.inputChildren);
				this.reconcile(output);
			}
			if (!this.gpu) throw new Error("Uh oh gpu is gone");
			for (const child of this.children) {
				if (this.dirty || this.forceRender) child.dirty = true;
				child.render(this.gpu, frame, dt);
			}
			this.dirty = false;
		} catch (e) {
			printError(e);
		} finally {
			Node.current = prevNode;
			Signal.unhook();
		}
	}

	private reconcile(output: Node[] | Node) {
		const nextChildren = flatten(output);
		const prevByKey = new Map<string | number, Node>();
		const prevUnkeyed: Node[] = [];
		for (const child of this.children) {
			const key = child.keyOf();
			if (key === undefined) prevUnkeyed.push(child);
			else prevByKey.set(key, child);
		}

		let unkeyedIndex = 0;
		const merged: Node[] = [];
		for (const next of nextChildren) {
			const nextKey = next.keyOf();
			let prev: Node | undefined;

			if (nextKey !== undefined) {
				prev = prevByKey.get(nextKey);
				if (prev) prevByKey.delete(nextKey);
			} else {
				prev = prevUnkeyed[unkeyedIndex++];
			}

			if (prev && prev.component === next.component) {
				prev.props = next.props;
				prev.key = next.key;
				prev.inputChildren = next.inputChildren;
				prev.dirty = true;
				prev.reconcile(next.children);
				merged.push(prev);
			} else {
				next.parent = this;
				merged.push(next);
			}
		}
		for (const orphan of prevByKey.values()) orphan.dispose();
		for (let i = unkeyedIndex; i < prevUnkeyed.length; i++) prevUnkeyed[i].dispose();
		for (const child of merged) child.parent = this;
		this.children = merged;
	}

	dispose() {
		//print("dispose");
		for (const dispose of this.disposers) dispose();
		this.disposers = [];
		this.deps.clear();
		for (const child of this.children) child.dispose();
		this.children = [];
	}
}
