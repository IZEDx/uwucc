export type Getter<T> = () => T;
export type MaybeGetter<T> = Getter<T> | T;
export type Setter<T> = (v: T) => void;
export type Unsub = () => void;

export type Getters<T extends Record<string, any>> = {
	[K in keyof T]: T[K] extends (...args: any[]) => any ? T[K] : MaybeGetter<T[K]>;
};

export namespace Signal {
	export type Resolved<T> = T extends Signal<infer R> ? R : T;
	export type ResolvedTuple<T> = T extends readonly [infer Head, ...infer Tail]
		? readonly [Resolved<Head>, ...ResolvedTuple<Tail>]
		: T extends readonly [infer R]
			? readonly [R]
			: readonly [];
	export type Maybe<T> = Signal<Resolved<NonNullable<T>>> | Resolved<T>;

	export type Hook = (signal: Signal<any>) => void;
}

let nextSignalId = 0;
const hookStack: Signal.Hook[] = [];

const collectors = [] as Signal[][];
export class Signal<T = any> {
	static collect(fn: () => any) {
		const signals = [] as Signal[];
		Signal.hook((s) => signals.push(s));
		fn();
		Signal.unhook();
		return signals;
	}

	static hook(hook: Signal.Hook) {
		return hookStack.push(hook);
	}

	static unhook() {
		return hookStack.pop();
	}

	readonly id = ++nextSignalId;
	readonly listeners = new Set<Setter<T>>();

	constructor(private _value: T) {}

	get untracked() {
		return this._value;
	}

	set untracked(v: T) {
		this._value = v;
	}

	get value() {
		hookStack[hookStack.length - 1]?.(this);
		return this._value;
	}

	set value(v: T) {
		//if (v === this._value) return;
		this._value = v;
		for (const listener of this.listeners) listener(v);
	}

	subscribe(cb: Setter<T>, immediate = false): Unsub {
		this.listeners.add(cb);
		if (immediate) cb(this._value);
		return () => this.listeners.delete(cb);
	}

	derive<R>(deriver: (v: T) => R): Signal<R> {
		return derive([this] as const, (...values) => deriver(values[0]));
	}
}

export function signal<T>(value: T): Signal<T> {
	return new Signal(value);
}

export function resolve<T>(value: Signal.Maybe<T> | MaybeGetter<T>): T {
	if (value && value instanceof Signal) return value.value as T;
	return extract(value) as T;
}

export function extractObject<T extends Record<string, any>>(value: Getters<T>): T {
	const extracted = {} as T;
	Object.entries(value).forEach(([k, v]) => {
		extracted[k as keyof T] = extract(v);
	});
	return extracted;
}

export function extract<T>(value: MaybeGetter<T>): T {
	return typeof value === "function" ? (value as Getter<T>)() : value;
}

export function derive<S extends any[], R>(
	signals: S,
	deriver: (...values: Signal.ResolvedTuple<S>) => R,
) {
	const resolve = () =>
		signals.map((item) =>
			item instanceof Signal ? item.value : item,
		) as any as Signal.ResolvedTuple<S>;
	const out = signal(deriver(...resolve()));
	for (const item of signals) {
		if (item instanceof Signal) {
			item.subscribe(() => {
				out.value = deriver(...resolve());
			});
		}
	}
	return out;
}
