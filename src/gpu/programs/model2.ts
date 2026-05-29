import { printf, printValue } from "../../lib/chalk";
import { prepareOBJ } from "../../lib/uwui-gpu/components/3d";

const OBJ_FILE = "disk/static/Drone_Icon_UI_MC2.obj";

const FOV = 50;
const NEAR = 0.05;
const FAR = 100;

const ROTATE_SPEED = 22;
const MODEL_SCALE = 2.25;

const CAMERA_X = 1.7;
const CAMERA_Y = 1.15;
const CAMERA_Z = -4.6;

const BG_R = 0;
const BG_G = 0;
const BG_B = 0;

const MODEL_R = 0;
const MODEL_G = 200;
const MODEL_B = 255;

const gpu = peripheral.find("directgpu")[0] as DirectGPUPeripheral;

const dashboardDisplay = gpu.autoDetectAndCreateDisplay()!;
sleep(0);
gpu.fillRect(dashboardDisplay, 0, 0, 100, 100, 200, 100, 100);
gpu.updateDisplay(dashboardDisplay);

const m = gpu.autoDetectMonitors().monitors[1];
const hudDisplay = gpu.createDisplay(m.x + 3, m.y + 1, m.z - 1, "cc:west:south:up", 3, 3);
sleep(0);
gpu.fillRect(hudDisplay, 0, 0, 100, 100, 200, 100, 100);
gpu.updateDisplay(hudDisplay);

gpu.enableDeltaMode(hudDisplay);

gpu.setBackgroundOpacity(hudDisplay, 0);
gpu.setOpacity(hudDisplay, 80);

gpu.setupCamera(hudDisplay, FOV, NEAR, FAR);
gpu.setCameraPosition(hudDisplay, CAMERA_X, CAMERA_Y, CAMERA_Z);
gpu.lookAt(hudDisplay, 0, 0, 0);

gpu.setBackfaceCulling(hudDisplay, false);
gpu.setPhongShading(hudDisplay, true);

gpu.clearLights(hudDisplay);
gpu.addAmbientLight(hudDisplay, 255, 255, 255, 0.95);
gpu.addDirectionalLight(hudDisplay, -0.45, -0.85, -0.35, 255, 255, 255, 0.65);
gpu.addDirectionalLight(hudDisplay, 0.5, 0.25, -0.7, 120, 180, 255, 0.25);

const file = fs.open(OBJ_FILE, "r")[0];
const objData = file!.readAll()!;
file?.close();
const [preparedOBJ, vertexCount, faceCount] = prepareOBJ(objData);
//print(preparedOBJ, vertexCount, faceCount);
const modelId = gpu.load3DModel(preparedOBJ);

printf("Loaded model %d with %d vertices and %d faces.", modelId, vertexCount, faceCount);

let yaw = -25;
let lastTime = os.clock();

try {
	while (true) {
		const now = os.clock();
		const dt = now - lastTime;
		lastTime = now;

		yaw = (yaw + ROTATE_SPEED * dt) % 360;

		gpu.clear(hudDisplay, BG_R, BG_G, BG_B);
		gpu.clearZBuffer(hudDisplay);
		//gpu.fillRect(display, 0, 0, 10, 10, 200, 0, 0);

		//const [pitch, yaw, roll] = sublevel.getLogicalPose().orientation.toEuler();
		gpu.draw3DModel(
			hudDisplay,
			modelId,
			0,
			0,
			0,
			0, //math.deg(-pitch),
			yaw,
			0, //math.deg(-roll),
			MODEL_SCALE,
			MODEL_R,
			MODEL_G,
			MODEL_B,
		);

		gpu.updateDisplay(hudDisplay);

		sleep(0.03);
	}
} catch (e) {
	printError(e);
}

gpu.clear(hudDisplay, 0, 0, 0);
gpu.updateDisplay(hudDisplay);
gpu.unload3DModel?.(modelId);
gpu.removeDisplay(hudDisplay);
