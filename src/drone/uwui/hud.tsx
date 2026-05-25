import { LAC } from "../../lib/algorithm/lac";
import { printValue } from "../../lib/chalk";
import { clamp, round } from "../../lib/math";
import { Model } from "../../lib/uwui-gpu/components";
import { use3D, useHook, useTick } from "../../lib/uwui-gpu/hooks";
import { Box, each, Signal, Text, useGPU, useSignal, UwUi } from "../../lib/uwui-gpu/uwui";
import { Controller } from "../controller";
import { peripherals, state } from "../peripherals";
import { AltitudeGraph } from "./altitudeGraph";
import { palette } from "./palette";

export function HUD(props: { controller: Controller }) {
	useTick();
	use3D();
	const gpu = useGPU();
	gpu.clear();

	const bearing = peripherals.sensors.nav_table.getBearing() - 90;
	const algo = props.controller.algos.alt as LAC;
	return [
		<Model
			file="disk/static/Drone_Icon_UI_MC2.obj"
			pos={{ y: clamp(algo.state.error / 10, -0.5, 0.5) }}
			rot={{ pitch: state.value.pitch, yaw: bearing / 2, roll: -state.value.roll }}
			scale={0.07}
		/>,
		<Text x={0.5} y={0.8} justify="center" size={20} color={palette.text(1)}>
			{bearing.toFixed(2)}
		</Text>,
		<Box x={0.25} y={0.5} h={50} w={0.5} align="middle" justify="center">
			<Text x={0.5} y={0} justify="center" size={20} color={palette.text(1)}>
				fwd {state.value.velF.toFixed(1)} b/s {"\n"}
			</Text>
			<Text x={0.5} y={30} justify="center" size={20} color={palette.text(1)}>
				side {state.value.velR.toFixed(1)} b/s
			</Text>
		</Box>,
		<Box x={0.75} y={0.5} h={80} w={0.5} align="middle" justify="center">
			<Text x={0.5} y={0} justify="center" size={20} color={palette.text(1)}>
				alt {round(state.value.alt)}
			</Text>
			<Text x={0.5} y={30} justify="center" size={20} color={palette.text(1)}>
				air {round(state.value.airP * 100)}%
			</Text>
			<Text x={0.5} y={60} justify="center" size={20} color={palette.text(1)}>
				vel {state.value.velU.toFixed(1)} b/s
			</Text>
		</Box>,
	];
}
