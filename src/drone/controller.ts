import { PID } from "../lib/algorithm/pid";
import { Config } from "../lib/config";
import { clamp, computeRotorThrusts, normalizeThrusts, Thrusts } from "../lib/util";
import { applyThrusts, peripherals, state as sensors, stateLoop, stopRotors } from "./peripherals";
import { KeyEvent, pullEventAs } from "../lib/events";
import { Algorithm } from "../lib/algorithm/abstract";
import { LAC } from "../lib/algorithm/lac";
import { signal } from "../lib/uwui-gpu/signal";
import { lerp } from "../lib/math";

export const parts = ["alt", "velF", "velR", "pitch", "roll"] as const;

const defaultConfig = () =>
	new Config("config", {
		controller: {
			max_pitch: 20,
			max_roll: 20,
		},
		base: {
			hover: 0.5,
			min: 0,
			max: 1,
		},
		trims: {
			fl: 0,
			fr: 0,
			bl: 0,
			br: 0,
		},
	});

export namespace Controller {
	export type Part = (typeof parts)[number];
	export type Algorithms = Record<Part, Algorithm>;

	export type Status = {
		lastTick: number;
		tickCount: number;
		dt: number;
		avgDt: number;
		upTime: number;
		base: number;
		thrusts: Thrusts;
	};

	export interface Options {
		display?: boolean;
		tick?: boolean;
		load?: boolean;
		quit?: boolean;
		tunings?: Config<Record<Controller.Part, any>>;
		cfg?: ReturnType<typeof defaultConfig>;
	}
}

export class Controller {
	tunings: Config<Record<Controller.Part, any>>;
	cfg: ReturnType<typeof defaultConfig>;

	inputs: Record<Controller.Part, number>;
	algos: Controller.Algorithms;
	status = signal({} as Controller.Status);
	private _lastDts: number[] = [];

	constructor(public options: Controller.Options = {}) {
		this.cfg = options.cfg ?? defaultConfig();
		this.tunings = options.tunings ?? new Config("tunings", {} as Record<Controller.Part, any>);

		this.inputs = {
			alt: sensors.alt,
			velF: 0,
			velR: 0,
			pitch: 0,
			roll: 0,
		};

		this.algos = {
			alt: new LAC("alt", this.tunings),
			velF: new LAC("velF", this.tunings),
			velR: new LAC("velR", this.tunings),
			pitch: new LAC("pitch", this.tunings),
			roll: new LAC("roll", this.tunings),
		};
		this.reset();
	}

	load(): void {
		this.cfg.load();
		this.tunings.load();
	}

	reset() {
		this.load();
		for (const algo of Object.values(this.algos)) {
			algo.reset();
		}
		stopRotors();
		this.status.value = {
			lastTick: os.clock(),
			tickCount: 0,
			dt: 0,
			avgDt: 0,
			upTime: 0,
			base: 0,
			thrusts: { fl: 0, fr: 0, br: 0, bl: 0 },
		};
	}

	setInputs(inputs: Partial<Record<Controller.Part, number>>) {
		for (const name of parts) {
			this.inputs[name] = inputs[name] ?? this.inputs[name];
		}
	}

	tick(noApply: boolean = false): void {
		const cfg = this.cfg.data;
		const status = this.status.value;
		const targets = this.inputs;

		status.tickCount++;
		const now = os.clock();
		status.dt = math.max(0.05, now - status.lastTick);
		status.lastTick = now;
		status.upTime += status.dt;

		// Maintain rolling average of delta times
		if (this._lastDts.length >= 4) {
			this._lastDts.shift();
		}
		this._lastDts.push(status.dt);

		let dtSum = 0;
		for (const dt of this._lastDts) {
			dtSum += dt;
		}
		status.avgDt = dtSum / 4; //this._lastDts.length;

		// Altitude control
		let altCmd = this.algos.alt.compute(sensors.alt, targets.alt, status.avgDt);
		//altCmd = altCmd > 0 ? altCmd / sensors.airP : altCmd * sensors.airP;

		status.base = clamp(
			(cfg.base.hover + altCmd) * (1 - sensors.airP / 2),
			cfg.base.min,
			cfg.base.max,
		);

		// Velocity to pitch/roll control
		const prevVelF = this.algos.velF.sensorHistory.youngest() || 0;
		const velFCmd = this.algos.velF.compute(
			lerp(prevVelF, sensors.velF, 0.2),
			targets.velF,
			status.dt,
		);
		const maxPitch = this.cfg.data.controller.max_pitch;
		const pitchTarget = clamp(targets.pitch - velFCmd * maxPitch, -maxPitch, maxPitch);
		const pitchCmd = this.algos.pitch.compute(sensors.pitch, pitchTarget, status.dt);

		const velRCmd = this.algos.velR.compute(sensors.velR, targets.velR, status.dt);
		const maxRoll = this.cfg.data.controller.max_roll;
		const rollTarget = clamp(targets.roll + velRCmd * maxRoll, -maxRoll, maxRoll);
		const rollCmd = this.algos.roll.compute(sensors.roll, rollTarget, status.dt);

		// Compute rotor thrusts using X-frame mixer
		status.thrusts = computeRotorThrusts(status.base, pitchCmd, rollCmd, cfg.trims);
		normalizeThrusts(status.thrusts);

		this.status.value = status;

		parallel.waitForAll(
			() => {
				if (!noApply) {
					applyThrusts(status.thrusts);
				}
			},
			() => sleep(0),
		);
	}

	loop() {
		return () => {
			const opts = this.options || {};
			opts.display = opts.display !== false;
			opts.tick = opts.tick !== false;
			opts.load = opts.load !== false;
			opts.quit = opts.quit !== false;

			parallel.waitForAny(
				stateLoop,
				() => {
					while (true) {
						if (opts.load) {
							this.load();
						}
						sleep(3);
					}
				},
				() => {
					while (true) {
						sleep(10);
						const e = pullEventAs(KeyEvent, "key");

						if (e?.key === keys.q) {
							return;
						}
					}
				},
				() => {
					while (true) {
						if (opts.tick) {
							this.tick();
						} else {
							sleep(1);
						}
					}
				},
				() => {
					while (true) {
						if (peripherals.monitors.status && opts.display) {
							this.printStatus(peripherals.monitors.status);
							sleep(0.5);
						} else {
							sleep(3);
						}
					}
				},
			);
		};
	}

	printStatus(target?: any): void {
		const oldTerm = term.redirect(target || term.current());
		(target as MonitorPeripheral).setTextScale(1);
		term.clear();
		term.setCursorPos(1, 1);
		const s = this.status.value;
		term.setTextColor(colors.lightGray);
		print(string.format("DT: %.2f", s.avgDt));

		const pidsRow = (fmt: string, pid: Algorithm) => [
			10,
			[
				pid.name,
				string.format("%s" + fmt, pid.state.current >= 0 ? " " : "", pid.state.current),
				string.format("%s" + fmt, pid.state.target >= 0 ? " " : "", pid.state.target),
				string.format("%s" + fmt, pid.state.error >= 0 ? " " : "", pid.state.error),
				string.format("%s%.3f", pid.state.output >= 0 ? " " : "", pid.state.output),
				pid.state.mode === "attack" ? "ATK" : "DEC",
			],
		];

		textutils.tabulate(
			["PIDs", "Current", "Target", "Error", "Cmd", "Mode"],
			...pidsRow("%.1f", this.algos.alt),
			...pidsRow("%.2f", this.algos.velF),
			...pidsRow("%.2f", this.algos.velR),
			...pidsRow("%.2f", this.algos.pitch),
			...pidsRow("%.2f", this.algos.roll),
		);
		print("");
		textutils.tabulate(
			["Thrusts", "Left", "Right"],
			["Front", string.format("%.3f", s.thrusts.fl), string.format("%.3f", s.thrusts.fr)],
			["Back", string.format("%.3f", s.thrusts.bl), string.format("%.3f", s.thrusts.br)],
		);

		term.redirect(oldTerm);
	}
}
