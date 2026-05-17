import { program } from "../../lib/program";

program(() => {
	print("DirectGPU Display Cleaner");
	print("=========================");

	const gpu = peripheral.find("directgpu")[0] as DirectGPUPeripheral;
	if (!gpu) {
		print("ERROR: DirectGPU peripheral not found!");
		return;
	}

	print("Found DirectGPU peripheral");

	const displays = gpu.listDisplays();

	if (displays.length == 0) {
		print("No displays found - nothing to clear");
		return;
	}

	print("Found", displays.length, "display(s)");
	for (const display of displays) {
		print("Removing display", display, "...");
		const success = gpu.removeDisplay(display);
		if (success) print("  Removed!");
		else print("  Failed to remove!");
	}

	print("\nAll displays cleared!");
});
