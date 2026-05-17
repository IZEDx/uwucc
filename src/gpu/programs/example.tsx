import { program } from "../../lib/program";
import { UwUi, Box, Text, each, signal, useSignal, useGPU, Signal } from "../../lib/uwui-gpu/uwui";

type Card = {
	id: number;
	x: number;
	y: number;
	w: number;
	h: number;
	color: DirectGPU.Color;
	label: string;
};

function CardView(props: { card: Card; key?: string | number }) {
	return (
		<Box
			x={props.card.x}
			y={props.card.y}
			w={props.card.w}
			h={props.card.h}
			bg={props.card.color}
			key={props.card.id}
		>
			<Text x={8} y={8} color={{ r: 255, g: 255, b: 255 }} size={4}>
				{props.card.label}
			</Text>
			<Text x={8} y={24} color={{ r: 220, g: 230, b: 255 }} size={3}>
				id={props.card.id}
			</Text>
		</Box>
	);
}

function Animated(props: { cards: Signal<Card[]> }) {
	return each(props.cards.value, (card, idx) => (
		<CardView
			key={idx}
			card={{
				...card,
				y: 20 + math.floor(10 * math.sin(frameSignal.value * 1.1 + idx * 0.8)),
				x: 20 + idx * 200 + math.floor(8 * math.cos(frameSignal.value * 0.7 + idx)),
			}}
		/>
	));
}

function Dashboard() {
	const cards = useSignal<Card[]>([
		{ id: 1, x: 20, y: 50, w: 180, h: 72, color: { r: 90, g: 120, b: 255 }, label: "Flight" },
		{
			id: 2,
			x: 220,
			y: 50,
			w: 180,
			h: 72,
			color: { r: 80, g: 200, b: 150 },
			label: "Telemetry",
		},
		{ id: 3, x: 420, y: 50, w: 180, h: 72, color: { r: 255, g: 140, b: 80 }, label: "UI" },
	]);

	return (
		<Box x={0} y={0} w={screenW} h={screenH} bg={{ r: 34, g: 38, b: 46 }}>
			<Box x={20} y={20} w={screenW - 40} h={100} bg={{ r: 50, g: 40, b: 50 }}>
				<Text x={20} y={8} color={{ r: 255, g: 240, b: 190 }} size={4}>
					uwui-gpu primitives t={os.clock().toFixed(2)}
				</Text>
				<Text x={20} y={32} color={{ r: 180, g: 205, b: 255 }} size={3}>
					opaque Boxes act as repaint boundaries
				</Text>
			</Box>
			<Box x={20} y={150} w={screenW - 40} h={80} bg={{ r: 50, g: 40, b: 50 }}>
				<Animated cards={cards} />
			</Box>
		</Box>
	);
}

const gpu = peripheral.find("directgpu")[0] as DirectGPUPeripheral;
const display = gpu.autoDetectAndCreateDisplay()!;
const info = gpu.getDisplayInfo(display);
const screenW = info.pixelWidth;
const screenH = info.pixelHeight;
const frameSignal = signal(0);

program(
	() => {
		while (true) {
			frameSignal.value = os.clock();
			sleep(0);
		}
	},
	() => {
		UwUi.render(() => <Dashboard />, gpu, display);
	},
);
