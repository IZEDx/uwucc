declare namespace term {
	export function drawPixels(x: number, y: number, pixels: number[][] | string[]): void;
}

declare type RedstoneRelayPeripheral = IPeripheral & typeof redstone;
