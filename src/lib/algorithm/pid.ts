import { Config } from "../config";
import { History } from "../history";
import { clamp } from "../math";

type ZNConstants = {
	kp: number;
	ti: number;
	td: number;
};

export const ZN = {
	basic: {
		kp: 0.6,
		ti: 0.5,
		td: 0.125,
	},
	lessOvershoot: {
		kp: 0.33,
		ti: 0.5,
		td: 0.33,
	},
	noOvershoot: {
		kp: 0.2,
		ti: 0.5,
		td: 0.33,
	},
} satisfies Record<string, ZNConstants>;

export namespace PID {
	export type Mode = keyof typeof ZN;

	export interface Options {
		name?: string;
		color?: number;
	}

	export type Config = {
		zn: Mode;
		ku: number;
		tu: number;
		ti: number;
	};

	export type Tuning = {
		kp: number;
		ki: number;
		kd: number;
		iMax: number;
	};

	export type State = {
		current: number;
		target: number;
		error: number;
		integral: number;
		cmd: number;
	};
}

export class PID {
	static config = new Config("pids", {} as Record<string, PID.Config>);

	private _tuned = false;
	private _tuning: PID.Tuning = {
		kp: 0,
		ki: 0,
		kd: 0,
		iMax: 1,
	};

	state: PID.State = {
		current: 0,
		target: 0,
		error: 0,
		integral: 0,
		cmd: 0,
	};

	name = "default_pid";
	color = colors.lightGray;
	errorHistory = new History<number>();

	constructor(cfg: PID.Options & Partial<PID.Config> = {}) {
		Object.assign(this, cfg);

		PID.config.load();
		this.config = {
			ku: this.config?.ku || cfg.ku || 0,
			ti: this.config?.ti || cfg.ti || 0,
			tu: this.config?.tu || cfg.tu || 0,
			zn: this.config?.zn || cfg.zn || "basic",
		};
		PID.config.save();
	}

	set tuning(tuning: Partial<PID.Tuning>) {
		if (Object.keys(tuning).length === 0) {
			const zn = ZN[this.config.zn];
			const { ku, tu, ti } = this.config;
			const kp = zn.kp * ku;
			const ki = (kp / (zn.ti * tu)) * ti;
			const kd = (zn.td * kp * tu) / ti;
			this._tuning = {
				kp: !isNaN(kp) && isFinite(kp) ? kp : 0,
				ki: !isNaN(ki) && isFinite(ki) ? ki : 0,
				kd: !isNaN(kd) && isFinite(kd) ? kd : 0,
				iMax: 1,
			};
			this._tuned = false;
		} else {
			Object.assign(this._tuning, tuning);
			this._tuned = true;
		}
	}

	get tuning(): PID.Tuning {
		return this._tuning;
	}

	set config(cfg: Partial<PID.Config>) {
		Object.assign(this.config, cfg);
		this.reset();
	}

	get config(): PID.Config {
		const cfg = PID.config.data[this.name as keyof typeof PID.config] || {};
		PID.config.data[this.name as keyof typeof PID.config] = cfg;
		return cfg;
	}

	compute(current: number, target: number, dt: number = 1): number {
		if (!this._tuned) this.tuning = {}; // recalculate pid values in case config changed

		this.state.current = current;
		this.state.target = target;
		const error = target - current;
		this.errorHistory.add(error);

		this.state.integral = clamp(
			this.state.integral + error * dt,
			-this.tuning.iMax,
			this.tuning.iMax,
		);

		const derivative = (error - this.state.error) / dt;
		this.state.error = error;

		this.state.cmd =
			this.tuning.kp * error +
			this.tuning.ki * this.state.integral +
			this.tuning.kd * derivative;

		return this.state.cmd;
	}

	reset(): void {
		this.tuning = {};
		this.state = {
			current: 0,
			target: 0,
			integral: 0,
			error: 0,
			cmd: 0,
		};
		//this.errorHistory.clear();
	}
}
