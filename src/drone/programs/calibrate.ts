import { program } from "../../lib/program";
import { Controller } from "../controller";
import { state as sensors, stopRotors } from "../peripherals";
import { centerValues } from "../utils";
import { anyKey, showHeader } from "../../lib/chalk";
import { clamp } from "../../lib/math";

const TRIM_STEP = 0.00005;
const MAX_TRIM = 1;

let ANGLE_THRESHOLD = 1.5;
let SETTLE_TIME = 1;
let TARGET_HEIGHT = 3;

const controller = new Controller({
	load: false,
	tick: false,
});
controller.inputs = {
	alt: controller.inputs.alt,
	velF: 0,
	velR: 0,
	velU: 0,
	pitch: 0,
	roll: 0,
};

function calibrationLoop(): void {
	stopRotors();
	const cfg = controller.cfg.data;
	let success = false;
	let settleTime = 0;
	let base = cfg.base.hover * 0.6;
	let trimDelta = 0;
	let trims = {
		fl: base,
		fr: base,
		bl: base,
		br: base,
	};

	// Disable PID tuning for calibration
	for (const pid of Object.values(controller.algos)) {
		pid.disabled.value = true;
		pid.reset();
	}

	showHeader("Trim Calibrator :3");
	print("");
	print("This will calibrate the base hover and rotor trims.");
	print("Make sure the aircraft is still and level before starting.");
	print("");
	anyKey();

	const settledPitch = sensors.value.pitch;
	const settledRoll = sensors.value.roll;
	const originAlt = sensors.value.alt;
	const startTime = os.clock();

	while (true) {
		const minTrim = math.min(Infinity, ...Object.values(trims));
		const maxTrim = math.max(-Infinity, ...Object.values(trims));
		trimDelta = maxTrim - minTrim;
		base = minTrim + trimDelta / 2;
		const settled = clamp((settleTime * 100) / SETTLE_TIME, 0, 100);

		cfg.base.hover = 0;
		cfg.trims = {
			fl: trims.fl * (settled / 100),
			fr: trims.fr * (settled / 100),
			bl: trims.bl * (settled / 100),
			br: trims.br * (settled / 100),
		};

		controller.tick();

		const pitchError = sensors.value.pitch - settledPitch;
		const rollError = sensors.value.roll - settledRoll;

		showHeader("Calibrating Trims...");
		print("");
		term.setTextColor(colors.lightBlue);
		print(string.format("Elapsed: %ds", os.clock() - startTime));
		term.setTextColor(colors.blue);
		print(string.format("Settled: %d%%", settled));
		print(
			string.format(
				"Height: %d%%",
				clamp(((sensors.value.alt - originAlt) * 100) / TARGET_HEIGHT, 0, 100),
			),
		);
		print("");
		term.setTextColor(colors.purple);
		print(string.format("Base Hover: %.3f", base));
		print(string.format("Deviation: %.3f", trimDelta));
		print(string.format("Pitch Error: %.3f", pitchError));
		print(string.format("Roll Error: %.3f", rollError));
		print("");
		term.setTextColor(colors.pink);
		textutils.tabulate(
			["Trims", "Left", "Right"],
			["Front", string.format("%.3f", trims.fl), string.format("%.3f", trims.fr)],
			["Back", string.format("%.3f", trims.bl), string.format("%.3f", trims.br)],
		);
		print("");
		term.setTextColor(colors.lightGray);
		print("Press Q to cancel");
		term.setTextColor(colors.white);

		const pitchFront =
			pitchError > ANGLE_THRESHOLD
				? -TRIM_STEP * 10
				: pitchError < -ANGLE_THRESHOLD
					? -TRIM_STEP
					: 0;
		const pitchBack =
			pitchError > ANGLE_THRESHOLD
				? -TRIM_STEP
				: pitchError < -ANGLE_THRESHOLD
					? -TRIM_STEP * 10
					: 0;
		const rollLeft =
			rollError > ANGLE_THRESHOLD
				? -TRIM_STEP * 10
				: rollError < -ANGLE_THRESHOLD
					? -TRIM_STEP
					: 0;
		const rollRight =
			rollError > ANGLE_THRESHOLD
				? -TRIM_STEP
				: rollError < -ANGLE_THRESHOLD
					? -TRIM_STEP * 10
					: 0;

		if (pitchFront !== 0 || pitchBack !== 0 || rollLeft !== 0 || rollRight !== 0) {
			trims.fl += pitchFront + rollLeft;
			trims.fr += pitchFront + rollRight;
			trims.bl += pitchBack + rollLeft;
			trims.br += pitchBack + rollRight;
			settleTime = 0;
		} else {
			settleTime += controller.status.value.dt;
		}

		for (const key of ["fl", "fr", "bl", "br"] as const) {
			trims[key] = clamp(trims[key], -MAX_TRIM, MAX_TRIM);
		}

		if (sensors.value.alt - originAlt > 0.5) {
			trims.fl -= TRIM_STEP * 2;
			trims.fr -= TRIM_STEP * 2;
			trims.bl -= TRIM_STEP * 2;
			trims.br -= TRIM_STEP * 2;
		}

		if (settleTime > SETTLE_TIME) {
			trims.fl += TRIM_STEP * 3;
			trims.fr += TRIM_STEP * 3;
			trims.bl += TRIM_STEP * 3;
			trims.br += TRIM_STEP * 3;
			if (sensors.value.alt - originAlt > TARGET_HEIGHT) {
				success = true;
				break;
			}
		}
	}

	stopRotors();

	if (success) {
		centerValues(trims);

		showHeader("Calibrated! :3");
		print(string.format("Hover base: %.3f", base));
		print("");
		print("Normalized Trims:");
		textutils.tabulate(
			["", "Left", "Right"],
			["Front", string.format("%.5f", trims.fl), string.format("%.5f", trims.fr)],
			["Back", string.format("%.5f", trims.bl), string.format("%.5f", trims.br)],
		);

		cfg.base.hover = base;
		cfg.trims = trims;
		controller.cfg.save();

		print("");
		print("Saved!");
		anyKey();
	}
}

program(controller.run(), calibrationLoop);
