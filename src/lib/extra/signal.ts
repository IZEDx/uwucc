export type Getter<T> = () => T;
export type MaybeGetter<T> = Getter<T> | T;
export type Setter<T> = (v: T) => void;
export type Subscriber<T> = (cb: Setter<T>) => Unsub;
export type Unsub = () => void;

/** @noSelf */
export function isGetter<T>(getter: MaybeGetter<T>): getter is Getter<T> {
	return typeof getter === "function";
}

/** @noSelf */
export function extract<T>(getter: MaybeGetter<T>): T {
	return isGetter(getter) ? getter() : getter;
}

export namespace Signal {
	export type Maybe<T> = Signal<Resolved<NonNullable<T>>> | Resolved<T>;
	export type MaybeArray<T extends any[]> = Maybe<T[number]>[];
	export type MaybeFields<T> = { [K in keyof T]: Maybe<T[K]> };

	export type Resolved<T> = T extends Signal<infer R> ? R : T;
	export type ResolvedArray<T extends any[]> = Resolved<T[number]>[];
	export type ResolvedTuple<T> = T extends readonly [infer Head, ...infer Tail]
		? readonly [Resolved<Head>, ...ResolvedTuple<Tail>]
		: T extends readonly [infer R]
			? readonly [R]
			: readonly [];
	export type ResolvedFields<T> = { [K in keyof T]: Resolved<Maybe<T[K]>> };
}

let _signalId = 0;
export class Signal<T> {
	static touched = new Set<Signal<any>>();
	readonly id = ++_signalId;
	readonly listeners = new Set<Setter<T | undefined>>();

	constructor(private _value: T) {}

	set value(v: T) {
		Signal.touched.add(this);
		this._value = v;
		this.listeners.forEach((set) => set(v));
	}

	get value() {
		Signal.touched.add(this);
		return this._value;
	}

	subscribe(cb: Setter<T>, noImmediate = false) {
		Signal.touched.add(this);
		this.listeners.add(cb as any);
		if (!noImmediate) cb(this.value);
		return () => {
			this.listeners.delete(cb as any);
		};
	}

	derive<R>(deriver: (v: T) => R): Signal<R> {
		Signal.touched.add(this);
		return Signal.derive([this] as const, deriver);
	}

	/** @noSelf */
	static resolveFields<T extends Record<string, any>>(obj: T) {
		const newObj = {} as Signal.ResolvedFields<T>;
		for (const [key, value] of Object.entries(obj)) {
			newObj[key as keyof T] = Signal.resolve(value);
		}
		return newObj;
	}

	/** @noSelf */
	static resolveArray<T extends any[]>(arr: T): Signal.ResolvedArray<T> {
		return arr.map((item) => Signal.resolve(item));
	}

	/** @noSelf */
	static resolve<T>(v: T): Signal.Resolved<T> {
		if (v instanceof Signal) {
			return v.value;
		}
		return v as Signal.Resolved<T>;
	}

	/** @noSelf */
	static derive<S extends any[], R>(
		signals: S,
		deriver: (...args: Signal.ResolvedTuple<S>) => R,
	) {
		const values = () => Signal.resolveArray(signals) as unknown as Signal.ResolvedTuple<S>;
		const derived = signal(deriver(...values()));
		for (const s of signals) {
			if (s instanceof Signal) {
				s.subscribe(() => {
					derived.value = deriver(...values());
				}, true);
			}
		}
		return derived;
	}

	/** @noSelf */
	static subscribe<S extends any[]>(
		signals: S,
		subscriber: (...args: Signal.ResolvedTuple<S>) => any,
	) {
		const values = () => Signal.resolveArray(signals) as unknown as Signal.ResolvedTuple<S>;
		subscriber(...values());
		const unsubs = signals
			.filter((s) => s instanceof Signal)
			.map((s) =>
				s.subscribe(() => {
					subscriber(...values());
				}, true),
			);
		return () => unsubs.forEach((u) => u());
	}
}

/** @noSelf */
export function signal<T>(value: T): Signal<T> {
	return new Signal(value);
}

/*
let _recentlyAccessed = new Set<Signal<any>>();
let _signals = {} as Record<number, Signal<any>>;

export namespace signals {

	export function pull() {
		const signals = [..._recentlyAccessed.values()];
		_recentlyAccessed.clear();
		return signals;
	}
}
*/
