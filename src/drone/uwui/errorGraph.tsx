import { clamp, formatValue, lerp, niceStep } from "../../lib/math";
import { each } from "../../lib/uwui-gpu/hooks";
import { useSignal, useTick, useGPU } from "../../lib/uwui-gpu/hooks";
import { Box, Line, rgb, UwUi } from "../../lib/uwui-gpu/uwui";
import { palette } from "./palette";
import { RGB } from "../../lib/uwui-gpu/colors";
import { Algorithm } from "../../lib/algorithm/abstract";

const TITLE_FONT_SIZE = 12;
const LABEL_FONT_SIZE = 10;

export function ErrorGraph(props: { algo: Algorithm }) {
	useTick();
	const gpu = useGPU();
	const state = useSignal({ targetRange: 5, displayRange: 5, min: -5, max: 5 });

	const { w, h } = gpu.clip;
	const items = props.algo.errorHistory.items; // history of errors

	let sampleMin = 0;
	let sampleMax = 0;
	if (items.length > 0) {
		sampleMin = items[0];
		sampleMax = items[0];
		for (const value of items) {
			sampleMin = math.min(sampleMin, value);
			sampleMax = math.max(sampleMax, value);
		}
	}

	const rawMax = math.max(5, math.max(math.abs(sampleMin), math.abs(sampleMax)));
	const targetRange = rawMax * 2;
	const smoothedRange = lerp(state.value.displayRange, targetRange, 0.1);
	const displayRange = math.max(smoothedRange, 10);
	const displayMax = displayRange / 2;
	const displayMin = -displayMax;

	state.value = {
		...state.value,
		targetRange,
		displayRange,
		min: displayMin,
		max: displayMax,
	};

	const padding = { left: 46, right: 12, top: 22, bottom: 20 };
	const plotW = math.max(1, w - padding.left - padding.right);
	const plotH = math.max(1, h - padding.top - padding.bottom);
	const midY = padding.top + plotH / 2;
	const valueToY = (value: number) => midY - (value / displayRange) * plotH;
	const xStep = items.length > 1 ? plotW / (items.length - 1) : plotW;
	const gridStep = niceStep(displayRange / 4);
	const gridCount = math.floor(displayRange / gridStep);

	const axisColor = rgb(145, 231, 255);
	const gridColor = rgb(55, 70, 95);
	const textColor = palette.text(0);

	const title = props.algo.name;
	const scaleLabel = `+/-${formatValue(displayMax)}`;

	return (
		<Box bg={palette.bg(3)} border={rgb(35, 45, 65)} radius={10}>
			<ErrorGrid
				padding={padding}
				plotW={plotW}
				plotH={plotH}
				midY={midY}
				displayMin={displayMin}
				displayRange={displayRange}
				gridCount={gridCount}
				gridStep={gridStep}
				axisColor={axisColor}
				gridColor={gridColor}
				textColor={textColor}
				title={title}
				scaleLabel={scaleLabel}
			/>
			<Line smoothing={0.8}>
				{...each(items, (error, idx) => {
					const normalized = clamp(error / displayMax, -1, 1);
					const x = padding.left + idx * xStep;
					const y = valueToY(error);
					const intensity = math.max(0, 1 - math.abs(normalized));
					return {
						x,
						y,
						color: rgb(240 - 145 * intensity, 80, 255),
					};
				})}
			</Line>
		</Box>
	);
}

function ErrorGrid(props: {
	padding: { left: number; right: number; top: number; bottom: number };
	plotW: number;
	plotH: number;
	midY: number;
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
		const y = midY - (value / displayRange) * plotH;
		const color = index === gridCount / 2 ? axisColor : gridColor;
		if (y >= padding.top && y <= h - padding.bottom) {
			gpu.drawLine(padding.left, y, padding.left + plotW, y, color.r, color.g, color.b);
			const label = formatValue(value);
			gpu.drawText(
				label,
				4,
				y - 6,
				textColor.r,
				textColor.g,
				textColor.b,
				"Arial",
				LABEL_FONT_SIZE,
				"bold",
			);
		}
	}

	gpu.drawLine(
		padding.left,
		midY,
		padding.left + plotW,
		midY,
		axisColor.r,
		axisColor.g,
		axisColor.b,
	);
	gpu.drawRect(padding.left, padding.top, plotW, plotH, 80, 100, 140);
	return [];
}
