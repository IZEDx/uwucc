import { LAC } from "../../lib/algorithm/lac";
import { printValue } from "../../lib/chalk";
import { clamp } from "../../lib/math";
import { Model, Scene } from "../../lib/uwui-gpu/components";
import { useHook, useTick } from "../../lib/uwui-gpu/hooks";
import { Box, each, Signal, Text, useGPU, useSignal, UwUi } from "../../lib/uwui-gpu/uwui";
import { Controller } from "../controller";
import { state } from "../peripherals";
import { AltitudeGraph } from "./altitudeGraph";
import { palette } from "./palette";

export function HUD(props: { controller: Controller }) {
	useTick();
	const gpu = useGPU();
	const model = useHook(() => {
		const display = gpu.display;

		gpu.gpu.enableDeltaMode(display);

		gpu.gpu.setBackgroundOpacity(display, 0);
		gpu.gpu.setOpacity(display, 80);

		gpu.gpu.setupCamera(display, 50, 0.05, 100);
		gpu.gpu.setCameraPosition(display, 0, 0, -10);
		gpu.gpu.lookAt(display, 0, 0, 0);

		gpu.gpu.setBackfaceCulling(display, false);
		gpu.gpu.setPhongShading(display, true);

		gpu.gpu.clearLights(display);
		gpu.gpu.addAmbientLight(display, 255, 255, 255, 0.95);
		gpu.gpu.addDirectionalLight(display, -0.45, -0.85, -0.35, 255, 255, 255, 0.65);
		gpu.gpu.addDirectionalLight(display, 0.5, 0.25, -0.7, 120, 180, 255, 0.25);

		const model = gpu.loadObjModel("disk/static/Drone_Icon_UI_MC2.obj");
		return model;
	});

	gpu.clear();
	const algo = props.controller.algos.alt as LAC;

	gpu.gpu.draw3DModel(
		gpu.display,
		model.id,
		0,
		clamp(algo.state.error / 10, -0.5, 0.5),
		0,
		state.value.pitch,
		0,
		-state.value.roll,
		0.07, //MODEL_SCALE,
		255, //MODEL_R,
		255, //MODEL_G,
		255, //MODEL_B,
	);
	return [];
}
