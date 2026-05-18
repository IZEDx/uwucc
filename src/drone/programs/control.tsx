import { program } from "../../lib/program";
import { Controller } from "../controller";
import { clamp } from "../../lib/util";
import { state, stopRotors } from "../peripherals";
import { showHeader } from "../../lib/chalk";
import { UwUi } from "../../lib/uwui-gpu/runtime";
import { Dashboard } from "../uwui/dashboard";

interface Velocity {
	x: number;
	y: number;
	z: number;
}

/*
const args = { ...arg };
const hasTabFlag = Object.values(args).includes("--tab");

// Fork to new tab if not already in one
function fork(): void {
	const argList = Object.values(args).join(" ");
	const newTab = shell.openTab(shell.getRunningProgram(), argList, "--tab");
	multishell.setTitle(newTab, "Controller");
	shell.switchTab(newTab);
}
*/

const controller = new Controller();
controller.inputs.alt = controller.inputs.alt;
const cfg = controller.cfg.extend({
	controller: {
		min_alt: 50,
		max_alt: 250,
		max_vel_x: 30,
		max_vel_y: 30,
		max_vel_z: 30,
		acceleration: 5,
		drag: 0.95,
	},
}).data;

showHeader(":3");
print("huh");
const vel: Velocity = { x: 0, y: 0, z: 0 };

function inputLoop(): void {
	let lastTime = os.clock();
	sleep(0.5);

	while (true) {
		const now = os.clock();
		const dt = now - lastTime;
		lastTime = now;

		const accel = cfg.controller.acceleration;

		const maxVelY = cfg.controller.max_vel_y;
		vel.y =
			state.input.y !== 0 ? clamp(vel.y + state.input.y * accel * dt, -maxVelY, maxVelY) : 0;
		controller.inputs.alt = clamp(
			controller.inputs.alt + vel.y * dt,
			cfg.controller.min_alt,
			cfg.controller.max_alt,
		);

		const maxVelX = cfg.controller.max_vel_x;
		const maxVelZ = cfg.controller.max_vel_z;
		if (!state.cruise) {
			vel.x = state.input.x * maxVelX;
			vel.z = state.input.z * maxVelZ;
		} else {
			vel.x = clamp(vel.x + state.input.x * accel * dt, -maxVelX, maxVelX);
			vel.z = clamp(vel.z + state.input.z * accel * dt, -maxVelZ, maxVelZ);
		}
		controller.inputs.velR = vel.x;
		controller.inputs.velF = vel.z;

		//print(state.cruise, vel.x, vel.y, vel.z);
		sleep(0.05);
	}
}

const gpu = peripheral.find("directgpu")[0] as DirectGPUPeripheral;
const display = gpu.autoDetectAndCreateDisplay()!;
program(controller.loop(), inputLoop, () =>
	UwUi.render(() => <Dashboard controller={controller} />, gpu, display),
);
gpu.removeDisplay(display);
stopRotors();
