import { clamp, lerp, niceStep } from "../../lib/math";
import { each } from "../../lib/uwui-gpu/hooks";
import { Line } from "../../lib/uwui-gpu/components";
import { useSignal, useTick, useGPU } from "../../lib/uwui-gpu/hooks";
import { Box, rgb, UwUi } from "../../lib/uwui-gpu/uwui";
import { Controller } from "../controller";
import { palette } from "./palette";
import { RGB } from "../../lib/uwui-gpu/colors";
import { AltitudeGraph } from "./altitudeGraph";
import { LAC } from "../../lib/algorithm/lac";

const TITLE_FONT_SIZE = 12;
const LABEL_FONT_SIZE = 10;

export function Graphs(props: { controller: Controller }) {
	return (
		<Box bg={palette.bg(3)} x={10} y={10} w={-20} h={-10}>
			<AltitudeGraph algo={props.controller.algos.alt as LAC} />
			{/*
			<AttitudeGraph algo={props.controller.algos.pitch} />
			<AttitudeGraph algo={props.controller.algos.roll} />
			*/}
		</Box>
	);
}
