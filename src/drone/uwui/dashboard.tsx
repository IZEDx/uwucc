import { LAC } from "../../lib/algorithm/lac";
import { Box, each, Signal, Text, useGPU, useSignal, UwUi } from "../../lib/uwui-gpu/uwui";
import { Controller } from "../controller";
import { state } from "../peripherals";
import { AltitudeGraph } from "./altitudeGraph";
import { palette } from "./palette";

export function Dashboard(props: { controller: Controller }) {
	const gpu = useGPU();
	const algo = useSignal(props.controller.algos.alt as LAC);
	const { w, h } = gpu.clip;
	return (
		<Box w={w} h={h} bg={palette.bg(2)}>
			<Box
				x={10}
				y={10}
				w={150}
				h={-10}
				bg={palette.bg(3)}
				radius={20}
				border={palette.bg(5)}
			>
				<Status controller={props.controller} algo={algo} />
			</Box>
			<Box
				x={170}
				y={10}
				w={-10}
				h={-10}
				bg={palette.bg(3)}
				radius={20}
				border={palette.bg(5)}
			>
				<AltitudeGraph algo={algo.value} />
			</Box>
			{/*
			<Scene>
				<Model
					file="disk/static/Drone_Icon_UI_MC2.obj"
					rot={() => ({
						pitch: 360 - state.pitch,
						yaw: 260,
						roll: state.roll,
					})}
					pos={() => ({
						x: 0,
						y: -algo.value.state.error,
						z: 0,
					})}
				/>
			</Scene>
			*/}
		</Box>
	);
}

export function Status(props: { controller: Controller; algo: Signal<LAC> }) {
	const gpu = useGPU();
	const s = props.controller.status.value;
	let y = 0;
	return [
		<Text x={10} y={(y += 10)} size={17} color={palette.text(0)}>
			Targets
		</Text>,
		each(Object.entries(props.controller.inputs), ([name, input]) => {
			const algo = props.controller.algos[name as Controller.Part];
			return (
				<Box
					x={10}
					y={(y += 35)}
					w={-10}
					h={30}
					bg={palette.bg(algo.disabled.value ? 3 : algo === props.algo.value ? 5 : 4)}
					onInput={({ type, button }) => {
						//print(type, button);
						if (type !== "mouse_click") return;
						if (button === 1) {
							props.algo.value = algo as LAC;
						} else if (button === 2) {
							algo.disabled.value = !algo.disabled.value;
						}
					}}
				>
					<Text
						x={0.5}
						y={0.5}
						align="middle"
						justify="center"
						size={16}
						color={palette.text(2)}
					>
						{string.format("%s: %.2f", name, input)}
					</Text>
				</Box>
			);
		}),
		<Text x={0.5} y={-10} justify="center" align="bottom" size={17} color={palette.text(4)}>
			{string.format("DT: %.2f", s.avgDt)}
		</Text>,
	];
}

/*

*/
