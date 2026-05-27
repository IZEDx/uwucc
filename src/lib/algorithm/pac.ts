import { Config } from "../config";
import { History } from "../history";
import { clamp } from "../math";
import { Algorithm } from "./abstract";

const defaultParameters = {
	kp: 0.005, //2.0, // Nominal gain (like Kp in PID)
	kd: 0.05, // Derivative gain
	ki: 0.05,
	km: 10,

	iMax: 1,
	attack: 1, // Attack rate (how fast gain increases)
	decay: 2, // Decay rate (how fast gain returns to nominal)
	deadband: 0.5, // Error threshold for mode switching
	hysteresis: 0.1, // Prevents chattering

	smoothing: 0,
};

const defaultState = {
	mode: "attack" as PAC.Mode,
	lk: 0,
	fErr: 0,
	pErr: 0,
	integral: 0,
};

export namespace PAC {
	export type Mode = "attack" | "decay";
	export type Params = typeof defaultParameters;
	export type State = typeof defaultState;
}

export class PAC extends Algorithm<PAC.Params, PAC.State> {
	modeHistory = new History<string>();

	constructor(name: string, config: Config<Record<string, PAC.Params>>) {
		super(name, config, defaultParameters, defaultState);
	}

	onCompute(error: number, dt: number) {
		const alpha = dt / (0.05 + dt);
		const params = this.parameters;
		const state = this.state;

		// 1. Filter error (noise rejection)
		state.fErr = (1 - alpha) * state.fErr + alpha * error;
		const absfErr = math.abs(state.fErr);

		// 2. Mode switching with hysteresis (chatter-free)
		if (state.mode === "decay" && absfErr >= params.deadband + params.hysteresis) {
			state.mode = "attack";
		}
		if (state.mode === "attack" && absfErr <= params.deadband - params.hysteresis) {
			state.mode = "decay";
		}

		this.modeHistory.add(state.mode);

		// 3. Log-domain gain adaptation (THE KEY PART)
		if (state.mode === "attack") {
			state.lk += params.attack * absfErr * dt;
		} else {
			// Gain increases
			state.lk += params.decay * (math.log(params.kp) - state.lk) * dt;
		}
		// Decay to nominal

		// 4. Recover gain (guaranteed positive: K = e^L_K > 0)
		const K = clamp(math.exp(state.lk), params.kp, params.kp * params.km);

		state.integral = clamp(state.integral + error * dt, -params.iMax, params.iMax);

		// 5. PD control output
		const derivative = (error - state.pErr) / dt;
		state.pErr = error;

		return K * error + params.ki * state.integral + params.kd * derivative;
	}
}
