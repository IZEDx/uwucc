/** @noSelf */
declare class GyroscopicPropellerPeripheral implements IPeripheral {
	getManualTarget(): [number, number, number];
	setManualTarget(target: [number, number, number]): void;
	clearManualTarget(): void;
	getBlockNormal(): [number, number, number];
}
