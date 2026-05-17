import { KeyEvent, pullEventAs } from "../../lib/events";

const gpu = peripheral.find("directgpu")[0] as DirectGPUPeripheral;

const IMAGES = [
	"https://i.guim.co.uk/img/media/c6f7b43fa821d06fe1ab4311e558686529931492/180_92_1046_628/master/1046.jpg?width=465&dpr=1&s=none&crop=none",
	"https://wallpapers.com/images/hd/minecraft-shaders-1920-x-965-ifep35n93dhu1uzw.jpg",
	"https://wallpapers.com/images/hd/minecraft-shaders-1920-x-1080-dxnqfhk4rnysfhx5.jpg",
];
const SLIDE_DURATION = 5; // seconds per image
const RESOLUTION = 2;

print("Image Slideshow - Auto-detecting monitor+.");
const display = gpu.autoDetectAndCreateDisplayWithResolution(RESOLUTION)!;

if (!display || display == -1) {
	throw "Failed to create display";
}

const info = gpu.getDisplayInfo(display);
const w = info.pixelWidth;
const h = info.pixelHeight;
print(string.format("Display: %dx%d", w, h));

function loadAndDisplayImage(url: string) {
	print("Loading: " + url);
	const [response] = http.get(url, undefined, true);

	if (!response) {
		printError("Failed to fetch: " + url);
		return false;
	}

	const data = response.readAll()!;
	response.close();

	if (data.length < 100) {
		printError("Invalid image data");
		return false;
	}

	try {
		gpu.loadJPEGRegion(display, data as any, 0, 0, w, h);
		gpu.fillRect(display, 0, 0, 200, 200, 200, 50, 200);
	} catch (err) {
		printError("Failed to load image: " + tostring(err));
		return false;
	}

	gpu.updateDisplay(display);
	return true;
}

print("Starting slideshow+. (Press Q to quit)");
let currentIndex = 0;
let running = true;

parallel.waitForAny(
	() => {
		while (running) {
			loadAndDisplayImage(IMAGES[currentIndex]);
			sleep(SLIDE_DURATION);
			currentIndex = (currentIndex + 1) % IMAGES.length;
		}
	},
	() => {
		while (true) {
			const e = pullEventAs(KeyEvent, "key");
			if (e && e.key == keys.q) {
				running = false;
				break;
			}
		}
	},
);

gpu.removeDisplay(display);
print("Done");
