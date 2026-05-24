import { anyKey, showHeader } from "../lib/chalk";
import { Config } from "../lib/config";
import { clamp, round, Thrusts } from "../lib/util";
import { Signal, signal } from "../lib/uwui-gpu/signal";

export interface SensorState {
	alt: number;
	airP: number;
	velF: number;
	velR: number;
	pitch: number;
	roll: number;
	input: { x: number; y: number; z: number };
	cruise: boolean;
}

export namespace Peripherals {
	export type Sensors = {
		//altitude: any;
		gimbal: any;
		vel_fwd: any;
		vel_sides: any;
	};

	export type Rotors = {
		fl: any;
		fr: any;
		bl: any;
		br: any;
	};

	export type Monitors = {
		status: any;
	};

	export type Inputs = {
		analog_xyz: any;
		cruise_lever: string;
	};
}

export const cfg = new Config("connectors", {
	sensors: {
		//altitude: "altitude_sensor_0",
		//gimbal: "gimbal_sensor_0",
		//vel_fwd: "velocity_sensor_0",
		//vel_right: "velocity_sensor_1",
	},
	rotors: {
		fl: "electric_motor_0",
		fr: "electric_motor_1",
		bl: "electric_motor_2",
		br: "electric_motor_3",
	},
	propellers: {
		fl: "gyroscopic_propeller_bearing_0",
		fr: "gyroscopic_propeller_bearing_1",
		bl: "gyroscopic_propeller_bearing_2",
		br: "gyroscopic_propeller_bearing_3",
	},
	monitors: {
		status: "monitor_0",
	},
	inputs: {
		xyz: "redstone_relay_0",
		cruise: "left",
	},
});

type SectionNames = keyof typeof cfg.data;
type PeripheralNames<Section extends SectionNames> = keyof (typeof cfg.data)[Section];

type T = PeripheralNames<"inputs">;

type Peripherals = {
	[Section in SectionNames]: {
		[K in PeripheralNames<Section>]: IPeripheral;
	};
};

export const peripherals = {
	sensors: {
		//altitude: peripheral.wrap(cfg.data.sensors.altitude) as AltitudeSensorPeripheral,
		//gimbal: peripheral.wrap(cfg.data.sensors.gimbal) as GimbalSensorPeripheral,
		//vel_fwd: peripheral.wrap(cfg.data.sensors.vel_fwd) as VelocitySensorPeripheral,
		//vel_right: peripheral.wrap(cfg.data.sensors.vel_right) as VelocitySensorPeripheral,
	},
	rotors: {
		fl: peripheral.wrap(cfg.data.rotors.fl) as ElectricMotorPeripheral,
		fr: peripheral.wrap(cfg.data.rotors.fr) as ElectricMotorPeripheral,
		bl: peripheral.wrap(cfg.data.rotors.bl) as ElectricMotorPeripheral,
		br: peripheral.wrap(cfg.data.rotors.br) as ElectricMotorPeripheral,
	},
	propellers: {
		fl: peripheral.wrap(cfg.data.propellers.fl) as GyroscopicPropellerPeripheral,
		fr: peripheral.wrap(cfg.data.propellers.fr) as GyroscopicPropellerPeripheral,
		bl: peripheral.wrap(cfg.data.propellers.bl) as GyroscopicPropellerPeripheral,
		br: peripheral.wrap(cfg.data.propellers.br) as GyroscopicPropellerPeripheral,
	},

	monitors: {
		status: peripheral.wrap(cfg.data.monitors.status) as MonitorPeripheral,
	},

	inputs: {
		xyz: peripheral.wrap(cfg.data.inputs.xyz) as RedstoneRelayPeripheral,
		cruise: {
			isOn: () => redstone.getInput(cfg.data.inputs.cruise),
		} satisfies IPeripheral,
	},
} satisfies Peripherals;

export const state = signal({
	alt: 0,
	airP: 0,
	velU: 0,
	velF: 0,
	velR: 0,
	pitch: 0,
	roll: 0,
	orientation: undefined as any as Quaternion, //new Quaternion(new Vector(0, 0, 0), 0),
	input: { x: 0, y: 0, z: 0 },
	cruise: false,
});

const speeds: Record<string, number> = {};

export function pullState() {
	const p = peripherals;
	const pose = sublevel.getLogicalPose();
	state.value.alt = pose.position.y;
	state.value.airP = aero.getAirPressure(new Vector(0, state.value.alt, 0)); // p.sensors.altitude.getAirPressure();

	const vel = sublevel.getLinearVelocity();
	state.value.velF = vel.x;
	state.value.velU = vel.y;
	state.value.velR = vel.z;

	state.value.orientation = pose.orientation;
	const [pitch, yaw, roll] = pose.orientation.toEuler();
	//const angles = p.sensors.gimbal.getAngles();
	state.value.pitch = math.deg(roll); // -angles[1];
	state.value.roll = math.deg(pitch); // angles[0];

	const leftInput = p.inputs.xyz.getAnalogInput("left");
	const rightInput = p.inputs.xyz.getAnalogInput("right");
	const topInput = p.inputs.xyz.getAnalogInput("top");
	const bottomInput = p.inputs.xyz.getAnalogInput("bottom");
	const frontInput = p.inputs.xyz.getAnalogInput("front");
	const backInput = p.inputs.xyz.getAnalogInput("back");

	state.value.input = {
		x: rightInput / 15 - leftInput / 15,
		y: topInput / 15 - bottomInput / 15,
		z: frontInput / 15 - backInput / 15,
	};
	state.value.cruise = p.inputs.cruise.isOn();
	return state.value;
}

export function peripheralsSetup() {
	showHeader("Peripheral Setup");
	for (const [_s, _p] of Object.entries(cfg.data)) {
		const section = _s as SectionNames;
		for (let [_k, side] of Object.entries(_p)) {
			const key = _k as PeripheralNames<SectionNames>;
			let p = peripherals[section][key] as IPeripheral;
			while (!p) {
				print("");
				print(`${section}.${key} (${side}):`);
				term.write("> ");
				side = read(
					undefined,
					[side],
					(p) => {
						return peripheral
							.getNames()
							.filter((pp) => pp.startsWith(p))
							.map((pp) => pp.slice(p.length));
					},
					"",
				);
				print("");
				p = peripheral.wrap(side) as IPeripheral;
			}
			cfg.set(section, key, side as never);
			(peripherals[section][key] as any) = p;
			cfg.save();
		}
	}
}

try {
	pullState();
	stopRotors();
} catch (e) {
	printError(e);
	peripheralsSetup();
	pullState();
	anyKey();
}

export function stateLoop(): void {
	while (true) {
		parallel.waitForAll(pullState, () => sleep(0));
	}
}

export function stopRotors(): void {
	for (const r of Object.values(peripherals.rotors)) {
		r.stop();
	}
}

export function applyThrusts(thrusts: Thrusts): void {
	// Apply a table of thrust values (0-1 range) to rotors
	parallel.waitForAll(
		...Object.entries(thrusts).map(([name, thrust]) => () => {
			const rotor = peripherals.rotors[name as keyof Peripherals.Rotors];
			if (rotor !== undefined) {
				const invert = name === "fl" || name === "br" ? -1 : 1;
				const oldSpeed = speeds[name] || invert * rotor.getSpeed();
				const newSpeed = clamp(round(thrust * 256), -256, 256);
				if (newSpeed !== oldSpeed) {
					const s = invert * newSpeed;
					if (isNaN(s)) {
						rotor.stop();
						printError("Tried setting rotor " + name + " to NaN");
					} else {
						rotor.setSpeed(s);
						speeds[name] = newSpeed;
					}
				}
			}
		}),
	);
}

stopRotors();

const angle = 2;
for (const k of Object.keys(peripherals.propellers)) {
	const key = k as keyof typeof peripherals.propellers;
	const p = peripherals.propellers[key];
	let [x, y, z] = p.getBlockNormal();
	z += key.endsWith("l") ? angle : -angle;
	//x += key.startsWith("b") ? angle : -angle;
	p.setManualTarget([x, y, z]);
	print("lock propeller", p);
}
