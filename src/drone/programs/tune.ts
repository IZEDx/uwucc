import { anyKey, showHeader } from "../../lib/chalk";
import { Controller } from "../controller";
import { KeyEvent, pullEventAs } from "../../lib/events";
import { History } from "../../lib/history";
import { stopRotors } from "../peripherals";
import { PID } from "../../lib/algorithm/pid";
import { program } from "../../lib/program";

stopRotors();

// Ziegler-Nichols tuning constants
/*
const ZN = {
	P_GAIN: 0.6, // Kp = 0.6 * Ku (critical gain)
	I_GAIN: 1.2, // Ki = 1.2 * Kp / Pu (critical period)
	D_GAIN: 0.075, // Kd = 0.075 * Kp * Pu
};
*/
/*

type ZNConstants = {
	kp: number;
	ti: number;
	td: number;
};

const ZN = {
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

const CONFIG = {
	OSCILLATION_THRESHOLD: 1, // Min amplitude for oscillation detection
	STEP_TIME: 30, // Seconds to observe for oscillations
	SETTLE_TIME: 3, // Seconds to wait before startingg
	CROSSINGS: 5, // How many crossings to check for
	KP_STEPS: 20,
};

const controller = new Controller();
controller.inputs.alt = controller.inputs.alt + 30;

const pidNames = ["alt", "pitch", "roll", "velF", "velR"] satisfies Controller.Part[];
const defaultKps: Record<string, number> = {
	alt: 0.03,
	pitch: 0.003,
	roll: 0.003,
	velF: 0.05,
	velR: 0.05,
};

const targetOffsets: Record<Controller.Part, number> = {
	alt: 10,
	velF: 0,
	velR: 0,
	pitch: 0,
	roll: 0,
};

const targetRanges: Record<Controller.Part, number> = {
	alt: 0, // Target altitude increase
	velF: 10, // Target forward velocity
	velR: 10, // Target rightward velocity
	pitch: 10, // Target pitch angle
	roll: 10, // Target roll angle
};

function detectOscillation(errorHistory: History<number>) {
	const elapsed = errorHistory.timespan();
	if (elapsed < CONFIG.STEP_TIME / 2) {
		return { isOscillating: false, amplitude: 0, frequency: 0, period: 0, crossings: 0 };
	}

	// Count zero crossings to estimate frequency
	let firstCrossing = 0;
	let crossings = 0;

	let minVal = Infinity;
	let maxVal = -Infinity;
	const amplitudes = [] as number[];

	for (let i = 1; i < errorHistory.size(); i++) {
		const prev = errorHistory.get(i - 1) || 0;
		const curr = errorHistory.get(i) || 0;
		if (curr < minVal) minVal = curr;
		if (curr > maxVal) maxVal = curr;

		if (prev * curr < 0) {
			crossings++;
			if (firstCrossing == 0) {
				firstCrossing = i - 1;
				minVal = curr;
				maxVal = -curr;
			} else if ((crossings - 1) % 2 === 0) {
				const amplitude = math.abs(maxVal - minVal) / 2;
				amplitudes.push(amplitude);
				minVal = curr;
				maxVal = curr;
			}
		}
	}

	for (let i = 2; i < firstCrossing; i++) {
		errorHistory.shift();
	}

	const amplitude = amplitudes.reduce((a, b) => a + b, 0) / math.max(amplitudes.length, 1);

	// Frequency and period from zero crossings
	let period = 0;
	if (crossings > 0) {
		period = (2 * elapsed) / crossings;
	}
	const frequency = 1 / math.max(0.001, period);

	// Consider it oscillating if amplitude > threshold and has crossings
	const isOscillating = amplitude > CONFIG.OSCILLATION_THRESHOLD && crossings > CONFIG.CROSSINGS;

	return { isOscillating, amplitude, frequency, period, crossings };
}

function tuneWithZN(name: Controller.Part) {
	controller.reset();

	for (const n of Object.keys(controller.algos)) {
		const pid = controller.algos[n as Controller.Part];
		pid.reset();
		pid.errorHistory.clear();
	}

	if (!name.startsWith("vel")) {
		controller.algos.velF.tuning = {
			kp: 0,
			ki: 0,
			kd: 0,
		};
		controller.algos.velR.tuning = {
			kp: 0,
			ki: 0,
			kd: 0,
		};
	}

	const pid = controller.algos[name] as PID;
	pid.errorHistory._timespan = CONFIG.STEP_TIME;

	const oldKp = pid.tuning.kp > 0 ? pid.tuning.kp : defaultKps[name];
	const stepToKp = (step: number) => {
		const v = ((step + 1) / CONFIG.KP_STEPS - 0.5) * 2;
		if (v < 0) {
			return oldKp - oldKp * v * v;
		} else {
			return oldKp + oldKp * v * v;
		}
	};
	const maxKp = stepToKp(CONFIG.KP_STEPS);
	const minKp = stepToKp(0);
	//const stepSize = (maxKp - minKp) / CONFIG.KP_STEPS;

	const originTarget = controller.inputs[name];
	const startTime = os.clock();

	let step = 0;
	let criticalKp = 0;
	let criticalPeriod = 0;
	let crossingss = 0;

	while (step < CONFIG.KP_STEPS && criticalKp === 0) {
		pid.reset();
		pid.tuning = {
			kp: stepToKp(step),
			ki: 0,
			kd: 0,
			iMax: 1,
		};

		if (step % 2 === 0) {
			controller.inputs[name] =
				originTarget + targetOffsets[name] + targetRanges[name] * 2 * (math.random() - 0.5);
		}

		step = step + 1;
		let stepTime = 0;

		while (stepTime < CONFIG.STEP_TIME && criticalKp === 0) {
			const elapsed = os.clock() - startTime;

			controller.tick();
			stepTime = stepTime + controller.status.dt;

			// Check for oscillation
			const { isOscillating, amplitude, frequency, period, crossings } = detectOscillation(
				pid.errorHistory,
			);
			crossingss = crossings;

			showHeader("Tuning " + name + "...");
			print("");

			term.setTextColor(colors.lightBlue);
			print(string.format("Step: %d / %d     ", step, CONFIG.KP_STEPS));
			print(string.format("Elapsed: %ds", elapsed));
			term.setTextColor(colors.blue);
			print(string.format("Sampled: %.2fs", pid.errorHistory.timespan()));
			term.setTextColor(colors.purple);
			print(string.format("Kp: %.5f < %.5f < %.5f     ", minKp, pid.tuning.kp, maxKp));
			term.setTextColor(colors.pink);
			print(string.format("Amp: %.5f    ", amplitude));
			print(string.format("Crossings: %d / %d    ", crossings, CONFIG.CROSSINGS));
			print(string.format("Period: %.2f   ", period));
			print("");
			term.setTextColor(colors.lightGray);
			print("Press Q to cancel");
			term.setTextColor(colors.white);

			if (isOscillating) {
				criticalKp = pid.tuning.kp;
				criticalPeriod = period;
			}
		}

		if (crossingss < 2) {
			//step = step + 1; // skip a step if 0-1 crossings
			//stopRotors();
			//sleep(0.5);
		}
	}

	pid.errorHistory._timespan = 10;

	if (criticalKp === 0) {
		controller.reset();
		print("ERROR: Could not find critical gain!");
		anyKey();
		return false;
	}

	showHeader(name + " tuned! :3");
	print("");
	term.setTextColor(colors.lightBlue);
	print(string.format("Critical Kp: %.2f | Period: %.2f sec", criticalKp, criticalPeriod));
	print("");

	// Phase 2: Calculate Ziegler-Nichols tunings
	//const kp = ZN.P_GAIN * criticalKp;
	//const ki = (ZN.I_GAIN * kp) / math.max(0.1, criticalPeriod);
	//const kd = ZN.D_GAIN * kp * math.max(0.1, criticalPeriod);

	const zn = ZN[pid.config.zn];
	const ku = criticalKp;
	const tu = criticalPeriod;
	const ti = controller.status.avgDt;

	const kp = zn.kp * ku;
	const ki = (kp / (zn.ti * tu)) * ti;
	const kd = (zn.td * kp * tu) / ti;

	term.setTextColor(colors.blue);
	print("Calculated tunings:");
	print(string.format("  Zn: %s", pid.config.zn));
	print(string.format("  Ku: %.10f", ku));
	print(string.format("  Tu: %.10f", tu));
	print(string.format("  Ti: %.10f", ti));
	print(string.format("  Kp: %.10f", kp));
	print(string.format("  Ki: %.10f", ki));
	print(string.format("  Kd: %.10f", kd));
	print("");

	controller.reset();

	// Save tunings
	term.setTextColor(colors.purple);
	print("Saving tunings...");
	pid.config = {
		ku,
		ti,
		tu,
	};
	PID.config.save();
	print("");
	term.setTextColor(colors.white);

	anyKey();
	return true;
}

function tune(pidName: Controller.Part) {
	const originalTargets = {} as Controller.Inputs;
	for (const [name, target] of Object.entries(controller.inputs)) {
		originalTargets[name as Controller.Part] = target;
	}

	tuneWithZN(pidName);

	for (const [name, target] of Object.entries(originalTargets)) {
		controller.inputs[name as Controller.Part] = target;
	}
}

function tuningMenu(): void {
	controller.reset();

	showHeader("PID Auto-Tuner :3");
	print("");
	print("Available PIDs:");
	for (let i = 0; i < pidNames.length; i++) {
		print(`  ${i + 1}. ${pidNames[i]}`);
	}
	print("  0. Exit");
	print("");
	print("Select PID to tune (1-" + pidNames.length + "): ");

	const choice = pullEventAs(KeyEvent, "key");
	const idx = (choice && tonumber(string.char(choice.key))) || 0;

	if (idx > 0 && idx <= pidNames.length) {
		tune(pidNames[idx - 1]);
		tuningMenu();
	}
}

program(
	tuningMenu,
	controller.run({
		display: true,
		load: false,
		tick: false,
		quit: true,
	}),
);
/*



local function menuLoop()
    while true do
        util.clearShell("PID Auto-Tuner :3")

        print("Select PID to tune:")

        for n, pidName in ipairs(pidNames) do
            print(string.format("%d) %s", n, pidName))
        end

        print("")
        print(string.format("%d) all", #pidNames + 1))
        print("0) exit")
        print("")
        write("Choice: ")

        local choice = read()
        local n = tonumber(choice)

        if controller.pids[choice] or (n and n > 0 and n <= #pidNames) then
            local pidName = n and pidNames[n] or choice
            tune(pidName)
            util.anyKey()
        elseif choice == "all" or n == #pidNames + 1 then
            -- Tune all PIDs sequentially
            for i, pidName in ipairs(pidNames) do
                tune(pidName)
                sleep(5)
            end

            util.anyKey()
        elseif choice == "exit" or n == 0 then
            break
        end
    end
end

-- Main loop
program(
    controller:loop(
        {
            tick = false,
            load = false
        }
    ),
    menuLoop
)
P.stop()

*/
