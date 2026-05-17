import { Box, each, Text, useGPU, UwUi } from "../../lib/uwui-gpu/uwui";
import { Controller } from "../controller";
import { Graphs } from "./graphs";
import { palette } from "./palette";

export function Dashboard(props: { controller: Controller }) {
	const gpu = useGPU();
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
				<Status controller={props.controller} />
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
				<Graphs controller={props.controller} />
			</Box>
		</Box>
	);
}

export function Status(props: { controller: Controller }) {
	const gpu = useGPU();
	const s = props.controller.status.value;
	let y = 0;
	return [
		<Text x={10} y={(y += 10)} size={17} color={palette.text(0)}>
			Targets
		</Text>,
		each(Object.entries(props.controller.inputs), ([name, input]) => (
			<Text x={10} y={(y += 20)} size={16} color={palette.text(2)}>
				{string.format("%s: %.2f", name, input)}
			</Text>
		)),
		<Text x={0.5} y={-10} justify="center" align="bottom" size={17} color={palette.text(4)}>
			{string.format("DT: %.2f", s.avgDt)}
		</Text>,
	];
}

/*

*/
