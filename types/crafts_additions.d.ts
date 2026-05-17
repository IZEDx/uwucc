/** @noSelf */
declare class ElectricMotorPeripheral implements IPeripheral {
	getSpeed(): number;
	setSpeed(newSpeed: number): void;
	stop(): void;
}
