import { program } from "../../lib/program";
import { Controller } from "../controller";
import { state, stopRotors } from "../peripherals";
import { showHeader } from "../../lib/chalk";
import { UwUi } from "../../lib/uwui-gpu/runtime";
import { Dashboard } from "../uwui/dashboard";
import { HUD } from "../uwui/hud";
import { clamp } from "../../lib/math";

showHeader(":3");

const controller = new Controller();

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

function inputLoop(): void {
	const vel = { x: 0, y: 0, z: 0 };
	let lastTime = os.clock();
	sleep(0.5);

	while (true) {
		const now = os.clock();
		const dt = now - lastTime;
		lastTime = now;

		const accel = cfg.controller.acceleration;

		const maxVelY = cfg.controller.max_vel_y;
		vel.y =
			state.value.input.y !== 0
				? clamp(vel.y + state.value.input.y * accel * dt, -maxVelY, maxVelY)
				: 0;

		if (controller.algos.velU.disabled.value) {
			controller.inputs.alt = clamp(
				controller.inputs.alt + vel.y * dt,
				cfg.controller.min_alt,
				cfg.controller.max_alt,
			);
		} else {
			controller.inputs.velU = vel.y;
		}
		/*
		 */

		const maxVelX = cfg.controller.max_vel_x;
		const maxVelZ = cfg.controller.max_vel_z;
		if (!state.value.cruise) {
			vel.x = state.value.input.x * maxVelX;
			vel.z = state.value.input.z * maxVelZ;
		} else {
			vel.x = clamp(vel.x + state.value.input.x * accel * dt, -maxVelX, maxVelX);
			vel.z = clamp(vel.z + state.value.input.z * accel * dt, -maxVelZ, maxVelZ);
		}
		controller.inputs.velR = vel.x;
		controller.inputs.velF = vel.z;

		//print(state.cruise, vel.x, vel.y, vel.z);
		sleep(0.05);
	}
}

program(
	controller.run(),
	inputLoop,
	() => UwUi.render(() => <Dashboard controller={controller} />, UwUi.monitors[0], 0),
	() => {
		const mon = UwUi.monitors[1];
		UwUi.render(
			() => <HUD controller={controller} />,
			{
				...mon,
				x: mon.x + 3,
				z: mon.z - 2,
				facing: "cc:west:south:up",
				width: 5,
				height: 4,
			},
			2,
		);
	},
);

UwUi.clear();
stopRotors();
