import { Config } from "../config";
import { History } from "../history";
import { pairs } from "../util";
import { signal } from "../uwui-gpu/signal";

export namespace Algorithm {
	export type State = {
		current: number;
		target: number;
		error: number;
		output: number;
	};

	export type Config = {
		smoothing: number;
	};
}

export abstract class Algorithm<
	P extends Algorithm.Config = Algorithm.Config,
	S extends Record<string, any> = Record<string, any>,
> {
	disabled = signal(false);
	sensorHistory = new History<number>();
	targetHistory = new History<number>();
	errorHistory = new History<number>();

	state!: S & Algorithm.State;

	constructor(
		public name: string,
		public config: Config<Record<string, P>>,
		public defaultParameters: P,
		public defaultState: S,
	) {
		for (const [k, v] of pairs(defaultParameters)) {
			this.config.define(name, k, v);
		}
		this.reset();
	}

	compute(current: number, target: number, dt: number): number {
		this.state.current = current;
		this.sensorHistory.add(current);
		this.state.target = target;
		this.targetHistory.add(target);
		this.state.error = target - current;
		this.errorHistory.add(this.state.error);
		if (this.disabled.value) {
			this.state.output = 0;
		} else {
			this.state.output = this.onCompute(this.state.error, dt);
		}
		return this.state.output;
	}
	abstract onCompute(error: number, dt: number): number;

	set parameters(cfg: Partial<P>) {
		Object.assign(this.parameters, cfg);
		this.reset();
	}

	get parameters(): P {
		const data = this.config.data;
		const name = this.name;
		data[name] = data[name] || {};
		return data[name];
	}

	reset() {
		this.state = { ...this.defaultState, current: 0, target: 0, error: 0, output: 0 };
	}
}
