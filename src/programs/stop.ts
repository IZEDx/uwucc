// Emergency stop program - disables all rotors
for (const name of peripheral.getNames()) {
	if (name.startsWith("electric_motor")) {
		const p = peripheral.wrap(name) as ElectricMotorPeripheral;
		p.stop();
	}
}
print("All motors stopped");
