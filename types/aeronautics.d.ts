/** @noSelf */
declare class AltitudeSensorPeripheral implements IPeripheral {
	getHeight(): number;
	getAirPressure(): number;
}

/** @noSelf */
declare class VelocitySensorPeripheral implements IPeripheral {
	getVelocity(): number;
}

/** @noSelf */
declare class GimbalSensorPeripheral implements IPeripheral {
	getAngles(): [number, number];
}
