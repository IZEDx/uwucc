import { clamp, formatValue, lerp, niceStep } from "../../lib/math";
import { each } from "../../lib/uwui-gpu/hooks";
import { If, Line, Text } from "../../lib/uwui-gpu/components";
import { useSignal, useTick, useGPU } from "../../lib/uwui-gpu/hooks";
import { Box, rgb, Signal, UwUi } from "../../lib/uwui-gpu/uwui";
import { palette } from "./palette";
import { RGB } from "../../lib/uwui-gpu/colors";
import { resolve } from "../../lib/uwui-gpu/signal";
import { PAC } from "../../lib/algorithm/pac";

const TITLE_FONT_SIZE = 12;
const LABEL_FONT_SIZE = 10;

export function AltitudeGraph(props: { algo: Signal.Maybe<PAC> }) {
	useTick();
	const gpu = useGPU();
	const state = useSignal({ center: 0, displayRange: 10 });
	const algo = resolve(props.algo);
	const sensorHistory = algo.sensorHistory.items;
	const targetHistory = algo.targetHistory.items;
	const lastSensor = algo.sensorHistory.youngest() ?? 0;

	const { w, h } = gpu.clip;

	let targetSum = 0;
	for (const value of targetHistory) {
		targetSum += value;
	}
	const targetCenter =
		targetHistory.length > 0 ? targetSum / targetHistory.length : state.value.center;
	const center = lerp(state.value.center, targetCenter, 0.08);

	let sampleMin = center;
	let sampleMax = center;
	for (const value of sensorHistory) {
		sampleMin = math.min(sampleMin, value);
		sampleMax = math.max(sampleMax, value);
	}
	for (const value of targetHistory) {
		sampleMin = math.min(sampleMin, value);
		sampleMax = math.max(sampleMax, value);
	}

	const targetRange = math.max(2, math.max(center - sampleMin, sampleMax - center) * 2);
	const displayRange = lerp(state.value.displayRange, targetRange, 0.1);
	state.value = {
		center,
		displayRange,
	};

	const padding = { left: 46, right: 55, top: 25, bottom: 30 };
	const plotW = math.max(1, w - padding.left - padding.right);
	const plotH = math.max(1, h - padding.top - padding.bottom);
	const midY = padding.top + plotH / 2;
	const valueToY = (value: number) => midY - ((value - center) / displayRange) * plotH;
	const gridStep = niceStep(displayRange / 8);
	const gridCount = math.floor(displayRange / gridStep);
	const displayMin = center - displayRange / 2;

	const axisColor = rgb(145, 231, 255);
	const gridColor = rgb(55, 70, 95);
	const textColor = palette.text(0);

	return (
		<Box x={10} y={10} w={-10} h={-10}>
			<AltitudeGrid
				padding={padding}
				plotW={plotW}
				plotH={plotH}
				midY={midY}
				center={center}
				displayMin={displayMin}
				displayRange={displayRange}
				gridCount={gridCount}
				gridStep={gridStep}
				axisColor={axisColor}
				gridColor={gridColor}
				textColor={textColor}
				title={algo.name}
				scaleLabel={`+/-${formatValue(displayRange / 2)}`}
			/>
			<If condition={targetHistory.length > 10}>
				<Line smoothing={0.8}>
					{...each(targetHistory, (target, idx) => {
						const xStep = plotW / targetHistory.length;
						const mode = algo.modeHistory.get(idx);
						return {
							x: padding.left + idx * xStep,
							y: valueToY(target),
							color: rgb(
								mode === "attack" ? 200 : 105,
								mode === "attack" ? 180 : 180,
								mode === "attack" ? 180 : 210,
							),
						};
					})}
				</Line>
			</If>
			<If condition={sensorHistory.length > 10}>
				<Line smoothing={0.8}>
					{...each(sensorHistory, (value, idx) => {
						const xStep = plotW / sensorHistory.length;
						const normalized = clamp((value - center) / (displayRange / 2), -1, 1);
						const intensity = math.max(0, 1 - math.abs(normalized));
						const mode = algo.modeHistory.get(idx);
						return {
							x: padding.left + idx * xStep,
							y: valueToY(value),
							color: rgb(240 - 145 * intensity, 80, mode === "attack" ? 200 : 255),
						};
					})}
				</Line>
			</If>
			<Box x={-25} y={valueToY(lastSensor)} w={25} h={15} align="middle">
				<Text x={0} y={0.5} align="middle">
					{formatValue(lastSensor)}
				</Text>
			</Box>
		</Box>
	);
}

function AltitudeGrid(props: {
	padding: { left: number; right: number; top: number; bottom: number };
	plotW: number;
	plotH: number;
	midY: number;
	center: number;
	displayMin: number;
	displayRange: number;
	gridCount: number;
	gridStep: number;
	axisColor: RGB;
	gridColor: RGB;
	textColor: RGB;
	title: string;
	scaleLabel: string;
}) {
	const gpu = useGPU();
	const { w, h } = gpu.clip;
	const {
		padding,
		plotW,
		plotH,
		midY,
		center,
		displayMin,
		displayRange,
		gridCount,
		gridStep,
		axisColor,
		gridColor,
		textColor,
		title,
		scaleLabel,
	} = props;

	gpu.drawText(
		title,
		padding.left,
		6,
		textColor.r,
		textColor.g,
		textColor.b,
		"Arial",
		TITLE_FONT_SIZE,
		"bold",
	);
	gpu.drawText(
		scaleLabel,
		w - padding.right - 48,
		6,
		textColor.r,
		textColor.g,
		textColor.b,
		"Arial",
		TITLE_FONT_SIZE,
		"bold",
	);

	for (let index = 0; index <= gridCount; index++) {
		const value = displayMin + index * gridStep;
		const y = midY - ((value - center) / displayRange) * plotH;
		const color = gridColor; //index === gridCount / 2 ? axisColor : gridColor;
		if (y >= padding.top && y <= h) {
			gpu.drawLine(padding.left, y, padding.left + plotW, y, color.r, color.g, color.b);
			const label = formatValue(value);
			gpu.drawText(
				label,
				4,
				clamp(y - LABEL_FONT_SIZE / 2, padding.top, h),
				textColor.r,
				textColor.g,
				textColor.b,
				"Arial",
				LABEL_FONT_SIZE,
				"bold",
			);
		}
	}

	/*
	gpu.drawLine(
		padding.left,
		midY,
		padding.left + plotW,
		midY,
		axisColor.r,
		axisColor.g,
		axisColor.b,
	);
    */
	gpu.drawRect(padding.left, padding.top, plotW, plotH, 80, 100, 140);
	return [];
}
