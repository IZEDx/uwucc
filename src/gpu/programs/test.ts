import { anyKey, printValue } from "../../lib/chalk";

const gpu = peripheral.find("directgpu")[0] as DirectGPUPeripheral;

const display = gpu.autoDetectAndCreateDisplayWithResolution(2)!;
const info = gpu.getDisplayInfo(display);
const W = info.pixelWidth;
const H = info.pixelHeight;

try {
	while (true) {
		gpu.clear(display, 20, 20, 30);
		gpu.fillRect(display, 10, 10, 80, 40, 255, 0, 0);
		gpu.drawText(display, "Hello DirectGPU ", 12, 65, 255, 255, 255, "Arial", 18, "bold");
		gpu.drawLine(display, 0, 0, W, H, 255, 0, 0);
		gpu.updateDisplay(display);
		sleep(0.05);
	}
} catch (e) {
	printError(e);
} finally {
	gpu.removeDisplay(display);
}
