export type EventMap = {
	[K in string]: any[];
};

type Listener<E extends EventMap, K extends keyof E = keyof E> = (
	...args: E[K]
) => boolean | void | undefined;
type Listeners<E extends EventMap> = {
	[K in keyof E]: Set<Listener<E, K>>;
};

export class EventEmitter<E extends EventMap> {
	private _listeners = {} as Listeners<E>;
	private _forwards = new Set<EventEmitter<E>>();

	forwardEvents(target: EventEmitter<E>) {
		this._forwards.add(target);
		return () => this._forwards.delete(target);
	}

	on<K extends keyof E>(key: K, cb: Listener<E, K>) {
		if (!this._listeners[key]) this._listeners[key] = new Set();
		this._listeners[key].add(cb);
		return () => {
			this._listeners[key].delete(cb);
		};
	}

	once<K extends keyof E>(key: K, cb: Listener<E, K>) {
		const unsub = this.on(key, (...args: E[K]) => {
			unsub();
			return cb(...args);
		});
		return unsub;
	}

	pull<K extends keyof E>(key: K, timeout = 0, stopPropagation = false) {
		let result: E[K] | undefined;
		this.once(key, (...args) => {
			result = args;
			return stopPropagation;
		});
		let startTime = os.clock();
		while (!result) {
			if (timeout > 0 && os.clock() - startTime > timeout) {
				throw new Error("Timeout");
			}
			sleep(0.05);
		}
		return result;
	}

	emit<K extends keyof E>(key: K, ...args: E[K]) {
		let forward = true;
		this._listeners[key]?.forEach((listener) => {
			if (listener(...args)) {
				forward = false;
			}
		});
		if (forward) {
			this._forwards.forEach((f) => f.emit(key, ...args));
		}
	}
}
