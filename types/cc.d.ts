declare namespace term {
	export function drawPixels(x: number, y: number, pixels: number[][] | string[]): void;
}

declare type RedstoneRelayPeripheral = IPeripheral & typeof redstone;

declare module "cc.base64" {
	export function encode(s: string): string;
	export function decode(s: string): string;
}
