// ============================================================
// DirectGPU – CC:Tweaked peripheral type declarations
// ============================================================

// ------------------------------------------------------------
// Shared data types
// ------------------------------------------------------------

declare namespace DirectGPU {
	export interface DisplayInfo {
		id: number;
		x: number;
		y: number;
		z: number;
		facing: string;
		width: number;
		height: number;
		pixelWidth: number;
		pixelHeight: number;
		resolutionMultiplier: number;
	}

	export interface DisplayPosition {
		x: number;
		y: number;
		z: number;
	}

	export interface Rotation {
		pitch: number;
		yaw: number;
		roll?: number;
	}

	export interface ImageData {
		width: number;
		height: number;
		pixels: number[];
		[key: string]: unknown;
	}

	export interface TextureInfo {
		id: number;
		width: number;
		height: number;
	}

	export interface TextMetrics {
		width: number;
		height: number;
		lines?: number;
		[key: string]: unknown;
	}

	export interface Color {
		r: number;
		g: number;
		b: number;
	}

	export interface CameraInfo {
		fov: number;
		near: number;
		far: number;
		x: number;
		y: number;
		z: number;
		pitch: number;
		yaw: number;
		roll: number;
	}

	export interface ModelInfo {
		id: number;
		vertexCount: number;
		faceCount: number;
	}

	export interface WorldInfo {
		dimension: string;
		time: number;
		weather: string;
	}

	export interface TimeInfo {
		dayTime: number;
		totalTime: number;
	}

	export interface MoonInfo {
		phase: number;
		name: string;
	}

	export interface WeatherInfo {
		raining: boolean;
		thundering: boolean;
	}

	export interface ControllerInfo {
		id: number;
		name: string;
		type: string;
		[key: string]: unknown;
	}

	export interface ControllerProfile {
		name: string;
		axes: string[];
		buttons: string[];
	}

	export interface ControllerState {
		axes: number[];
		buttons: boolean[];
	}

	export interface ControllerEvent {
		type: string;
		controllerId: number;
		[key: string]: unknown;
	}

	export type MouseButton = 0 | 1 | 2 | 3 | 4 | 5;

	export interface InputEvent {
		type: "mouse_click" | "mouse_drag" | "mouse_up" | "mouse_hover";
		x: number;
		y: number;
		button: MouseButton;
		timestamp: number;
	}

	export interface MetaballInfo {
		id: number;
		x: number;
		y: number;
		radius: number;
		strength: number;
		r: number;
		g: number;
		b: number;
	}

	export interface CalibrationValues {
		divisor: number;
		subtract: number;
	}

	export interface GIFFrameInfo {
		frameCount?: number;
		frameDurations?: number[];
		width?: number;
		height?: number;
		[key: string]: unknown;
	}

	export interface SecurityCameraInfo {
		id?: number;
		displayId?: number;
		x?: number;
		y?: number;
		z?: number;
		yaw?: number;
		pitch?: number;
		fov?: number;
		updateInterval?: number;
		[key: string]: unknown;
	}

	export interface CameraBlockInfo {
		id?: number;
		displayId?: number;
		yaw?: number;
		pitch?: number;
		fov?: number;
		updateInterval?: number;
		renderDistance?: number;
		[key: string]: unknown;
	}

	export type FontStyle = "plain" | "bold" | "italic" | "bold italic";

	// Point used in polygon / polyline / bezier functions: [x, y]
	export type Point = [number, number];
}
// ------------------------------------------------------------
// Module interfaces
// ------------------------------------------------------------

declare namespace DirectGPUModules {
	/** @noSelf */
	interface DisplayModule {
		autoDetectAndCreateDisplay(): number | undefined;
		autoDetectAndCreateDisplayWithResolution(resolutionMultiplier: number): number | undefined;

		autoDetectAndCreateDisplays(): unknown[];
		autoDetectAndCreateDisplays(maxCount: number): unknown[];
		autoDetectAndCreateDisplays(maxCount: number, resolutionMultiplier: number): unknown[];

		autoDetectMonitor(): string;

		autoDetectMonitors(): unknown[];
		autoDetectMonitors(maxCount: number): unknown[];

		clearAllDisplays(): void;

		createDisplay(
			x: number,
			y: number,
			z: number,
			facing: string,
			width: number,
			height: number,
		): number;

		createDisplayAt(
			x: number,
			y: number,
			z: number,
			facing: string,
			width: number,
			height: number,
		): number;

		createDisplayWithResolution(
			x: number,
			y: number,
			z: number,
			facing: string,
			width: number,
			height: number,
			resolutionMultiplier: number,
		): number;

		getDisplayInfo(displayId: number): DirectGPU.DisplayInfo;

		getDisplayPosition(displayId: number): DirectGPU.DisplayPosition | Record<string, unknown>;

		getDisplayFrameJpeg(displayId: number, quality?: number): string;

		getResourceStats(): string;

		getRotation(displayId: number): DirectGPU.Rotation | Record<string, unknown>;

		hasTransparentBackground(displayId: number): boolean;

		listDisplays(): number[];

		enableDeltaMode(displayId: number): void;

		mirrorDisplay(
			sourceDisplayId: number,
			targetDisplayIds: number[],
		): unknown[] | Record<string, unknown>;

		moveDisplay(
			displayId: number,
			targetX: number,
			targetY: number,
			targetZ: number,
			speed?: number,
			...extra: number[]
		): void;

		removeDisplay(displayId: number): boolean;

		setDisplayPersistent(displayId: number, persistent: boolean): void;

		setRotation(displayId: number, pitch: number, yaw: number): void;

		setTransparentBackground(displayId: number, enabled: boolean): void;

		setTransparencyColor(displayId: number, r: number, g: number, b: number): void;

		clearTransparencyColor(displayId: number): void;

		clearTransparent(displayId: number): void;

		stopDisplayMovement(displayId: number): void;

		updateDisplay(displayId: number): void;
	}

	/** @noSelf */
	interface D2DModule {
		clear(displayId: number, r: number, g: number, b: number): void;

		drawCircle(
			displayId: number,
			cx: number,
			cy: number,
			radius: number,
			r: number,
			g: number,
			b: number,
			filled: boolean,
		): void;

		drawEllipse(
			displayId: number,
			cx: number,
			cy: number,
			rx: number,
			ry: number,
			r: number,
			g: number,
			b: number,
			filled: boolean,
		): void;

		drawLine(
			displayId: number,
			x1: number,
			y1: number,
			x2: number,
			y2: number,
			r: number,
			g: number,
			b: number,
		): void;

		drawPolygon(
			displayId: number,
			points: DirectGPU.Point[],
			r: number,
			g: number,
			b: number,
		): void;

		drawPolylines(
			displayId: number,
			points: DirectGPU.Point[],
			r: number,
			g: number,
			b: number,
		): void;

		fillEllipse(
			displayId: number,
			cx: number,
			cy: number,
			rx: number,
			ry: number,
			r: number,
			g: number,
			b: number,
		): void;

		fillRect(
			displayId: number,
			x: number,
			y: number,
			w: number,
			h: number,
			r: number,
			g: number,
			b: number,
		): void;

		getPixel(displayId: number, x: number, y: number): DirectGPU.Color;

		setPixel(displayId: number, x: number, y: number, r: number, g: number, b: number): void;
	}

	/** @noSelf */
	interface TextModule {
		clearFontCache(): void;

		drawText(
			displayId: number,
			text: string,
			x: number,
			y: number,
			r: number,
			g: number,
			b: number,
			fontName: string,
			fontSize: number,
			style: DirectGPU.FontStyle,
		): DirectGPU.TextMetrics;

		drawTextFast(
			displayId: number,
			text: string,
			x: number,
			y: number,
			r?: number,
			g?: number,
			b?: number,
			fontSize?: number,
		): DirectGPU.TextMetrics;

		drawTextWithBg(
			displayId: number,
			text: string,
			x: number,
			y: number,
			fgR: number,
			fgG: number,
			fgB: number,
			bgR: number,
			bgG: number,
			bgB: number,
			padding: number,
			fontName: string,
			fontSize: number,
			style: DirectGPU.FontStyle,
		): DirectGPU.TextMetrics;

		drawTextWrapped(
			displayId: number,
			text: string,
			x: number,
			y: number,
			maxWidth: number,
			r: number,
			g: number,
			b: number,
			lineSpacing: number,
			fontName: string,
			fontSize: number,
			style: DirectGPU.FontStyle,
		): DirectGPU.TextMetrics;

		drawTextWrappedFast(
			displayId: number,
			text: string,
			x: number,
			y: number,
			maxWidth: number,
			r?: number,
			g?: number,
			b?: number,
			fontSize?: number,
		): DirectGPU.TextMetrics;

		measureText(
			text: string,
			fontName: string,
			fontSize: number,
			style: DirectGPU.FontStyle,
		): DirectGPU.TextMetrics;

		measureTextFast(text: string, fontSize?: number): DirectGPU.TextMetrics;

		getAvailableFonts(): string[];
	}

	/** @noSelf */
	interface ImageModule {
		clearJPEGCache(): void;

		decodeAndScaleJPEG(
			base64JpegData: string,
			targetWidth: number,
			targetHeight: number,
		): DirectGPU.ImageData;

		decodeJPEG(base64JpegData: string): DirectGPU.ImageData;

		getJPEGDimensions(base64JpegData: string): {
			width: number;
			height: number;
		};

		getJPEGNetworkStats(): string;

		getRecommendedJPEGSettings(
			targetWidth: number,
			targetHeight: number,
		): Record<string, unknown>;

		loadJPEGFullscreen(displayId: number, base64JpegData: string): void;

		loadJPEGRegion(
			displayId: number,
			jpegBinaryData: number[],
			x: number,
			y: number,
			w: number,
			h: number,
		): void;

		loadJPEGRegionBytes(
			displayId: number,
			base64JpegData: string,
			x: number,
			y: number,
			w: number,
			h: number,
		): void;

		preloadJPEGSequence(displayId: number, jpegSequence: string[]): void;

		// PNG

		loadPNGFullscreen(displayId: number, base64PngData: string): void;

		loadPNGRegion(
			displayId: number,
			pngBinaryData: number[],
			x: number,
			y: number,
			w: number,
			h: number,
		): void;

		loadPNGRegionBytes(
			displayId: number,
			base64PngData: string,
			x: number,
			y: number,
			w: number,
			h: number,
		): void;

		decodePNG(base64PngData: string): DirectGPU.ImageData | Record<string, unknown>;

		decodeAndScalePNG(
			base64PngData: string,
			targetWidth: number,
			targetHeight: number,
		): DirectGPU.ImageData | Record<string, unknown>;

		getPNGDimensions(
			base64PngData: string,
		): { width: number; height: number } | Record<string, unknown>;

		// GIF

		loadGIFFullscreen(displayId: number, gifData: string): void;

		loadGIFRegion(
			displayId: number,
			gifBinaryData: number[],
			x: number,
			y: number,
			w: number,
			h: number,
		): void;

		loadGIFRegionBytes(
			displayId: number,
			base64GifData: string,
			x: number,
			y: number,
			w: number,
			h: number,
		): void;

		loadGIFFrame(
			displayId: number,
			gifData: string,
			frameIndex: number,
			x: number,
			y: number,
			w: number,
			h: number,
		): void;

		stopGIF(displayId: number): void;

		decodeGIF(base64GifData: string): DirectGPU.ImageData | Record<string, unknown>;

		decodeAndScaleGIF(
			base64GifData: string,
			targetWidth: number,
			targetHeight: number,
		): DirectGPU.ImageData | Record<string, unknown>;

		getGIFDimensions(
			base64GifData: string,
		): { width: number; height: number } | Record<string, unknown>;

		getGIFFrameInfo(base64GifData: string): DirectGPU.GIFFrameInfo | Record<string, unknown>;

		// Generic image

		loadImageFullscreen(displayId: number, base64ImageData: string): void;

		loadImageRegionBytes(
			displayId: number,
			base64ImageData: string,
			x: number,
			y: number,
			w: number,
			h: number,
		): void;

		decodeImage(base64ImageData: string): DirectGPU.ImageData | Record<string, unknown>;

		decodeAndScaleImage(
			base64ImageData: string,
			targetWidth: number,
			targetHeight: number,
		): DirectGPU.ImageData | Record<string, unknown>;

		getImageDimensions(
			base64ImageData: string,
		): { width: number; height: number } | Record<string, unknown>;

		detectImageFormat(base64ImageData: string): string;
	}

	/** @noSelf */
	interface TextureModule {
		getTextureInfo(textureId: number): DirectGPU.TextureInfo;

		loadTexture(width: number, height: number, base64PixelData: string): number;

		loadTextureFromImage(imageData: DirectGPU.ImageData): number;

		unloadTexture(textureId: number): boolean;
	}

	/** @noSelf */
	interface DictionaryModule {
		clearDictionary(): void;

		compressWithDict(base64Data: string): Record<string, string>;

		decompressFromDict(hashMap: Record<string, string>): string;

		getChunk(hash: string): string;

		getDictionaryStats(): string;

		hasChunk(hash: string): boolean;
	}

	/** @noSelf */
	interface CameraModule {
		clearZBuffer(displayId: number): void;

		getCameraInfo(displayId: number): DirectGPU.CameraInfo;

		lookAt(displayId: number, targetX: number, targetY: number, targetZ: number): void;

		setCameraPosition(displayId: number, x: number, y: number, z: number): void;

		setCameraRotation(displayId: number, pitch: number, yaw: number, roll: number): void;

		setCameraTarget(displayId: number, x: number, y: number, z: number): void;

		setupCamera(
			displayId: number,
			fov: number,
			near: number,
			far: number,
		): DirectGPU.CameraInfo;
	}

	/** @noSelf */
	interface D3DPrimitivesModule {
		clear3D(displayId: number): void;

		drawCube(
			displayId: number,
			x: number,
			y: number,
			z: number,
			size: number,
			rotX: number,
			rotY: number,
			rotZ: number,
			r: number,
			g: number,
			b: number,
		): void;

		drawPyramid(
			displayId: number,
			x: number,
			y: number,
			z: number,
			size: number,
			rotX: number,
			rotY: number,
			rotZ: number,
			r: number,
			g: number,
			b: number,
		): void;

		drawSphere(
			displayId: number,
			x: number,
			y: number,
			z: number,
			radius: number,
			segments: number,
			r: number,
			g: number,
			b: number,
			textureName: string | null,
		): void;
	}

	/** @noSelf */
	interface D3DModelsModule {
		clearAll3DModels(): void;

		draw3DModel(
			displayId: number,
			modelId: number,
			x: number,
			y: number,
			z: number,
			rotX: number,
			rotY: number,
			rotZ: number,
			scale: number,
			r: number,
			g: number,
			b: number,
		): void;

		draw3DModelTextured(
			displayId: number,
			modelId: number,
			x: number,
			y: number,
			z: number,
			rotX: number,
			rotY: number,
			rotZ: number,
			scale: number,
			textureId: number,
		): void;

		get3DModelInfo(modelId: number): DirectGPU.ModelInfo;

		load3DModel(objData: string): number;

		load3DModelFromBytes(base64ObjData: string): number;

		unload3DModel(modelId: number): boolean;
	}

	/** @noSelf */
	interface LightingModule {
		addAmbientLight(
			displayId: number,
			r: number,
			g: number,
			b: number,
			intensity: number,
		): void;

		addDirectionalLight(
			displayId: number,
			dirX: number,
			dirY: number,
			dirZ: number,
			r: number,
			g: number,
			b: number,
			intensity: number,
		): void;

		clearLights(displayId: number): void;

		setBackfaceCulling(displayId: number, enabled: boolean): void;

		setPhongShading(displayId: number, enabled: boolean): void;
	}

	/** @noSelf */
	interface VectorModule {
		drawBezierCurve(
			displayId: number,
			points: DirectGPU.Point[],
			r: number,
			g: number,
			b: number,
			segments?: number,
		): void;

		drawRoundedRect(
			displayId: number,
			x: number,
			y: number,
			w: number,
			h: number,
			radius: number,
			r: number,
			g: number,
			b: number,
			filled: boolean,
		): void;

		drawSVGPath(
			displayId: number,
			pathData: string,
			x: number,
			y: number,
			scale: number,
			r: number,
			g: number,
			b: number,
		): void;

		drawStar(
			displayId: number,
			cx: number,
			cy: number,
			pointCount: number,
			outerRadius: number,
			innerRadius: number,
			r: number,
			g: number,
			b: number,
			filled: boolean,
		): void;
	}

	/** @noSelf */
	interface MetaballModule {
		addMetaball(
			systemId: number,
			x: number,
			y: number,
			radius: number,
			strength: number,
		): number;

		clearMetaballs(systemId: number): void;

		createMetaballSystem(displayId: number): number;

		getMetaballCount(systemId: number): number;

		getMetaballInfo(systemId: number, ballId: number): DirectGPU.MetaballInfo;

		removeMetaballSystem(systemId: number): void;

		renderMetaballs(systemId: number, threshold: number, renderMode: number): void;

		setMetaballColor(systemId: number, ballId: number, r: number, g: number, b: number): void;

		setMetaballPhysics(systemId: number, enabled: boolean, gravity: number, drag: number): void;

		setMetaballVelocity(systemId: number, ballId: number, vx: number, vy: number): void;

		updateMetaballs(systemId: number, deltaTime: number): void;
	}

	/** @noSelf */
	interface InputModule {
		clearEvents(displayId: number): void;

		hasEvents(displayId: number): boolean;

		pollEvent(displayId: number): DirectGPU.InputEvent | null;
	}

	/** @noSelf */
	interface WorldModule {
		getBiomeAt(x: number, y: number, z: number): string;

		getDimension(): string;

		getMoonInfo(): DirectGPU.MoonInfo;

		getTimeInfo(): DirectGPU.TimeInfo;

		getWeather(): DirectGPU.WeatherInfo;

		getWorldInfo(): DirectGPU.WorldInfo;
	}

	/** @noSelf */
	interface ControllerModule {
		clearControllerEvents(controllerId: number): void;

		getAxes(controllerId: number): number[];

		getAxis(controllerId: number, axisIndex: number): number;

		getButton(controllerId: number, buttonIndex: number): boolean;

		getButtons(controllerId: number): boolean[];

		getControllerCount(): number;

		getControllerDeadzone(): number;

		getControllerInfo(controllerId: number): DirectGPU.ControllerInfo;

		hasControllerEvents(controllerId: number): boolean;

		listControllers(): DirectGPU.ControllerInfo[] | unknown[];

		pollControllerEvent(controllerId: number): DirectGPU.ControllerEvent | null;

		scanForControllers(): void;

		setControllerDeadzone(deadzone: number): void;

		updateControllerState(controllerId: number): void;
	}

	/** @noSelf */
	interface ControllerMappingModule {
		exportRawControllerState(controllerId: number): string;

		getControllerMapping(controllerId: number): Record<string, unknown>;

		getMappedAxis(controllerId: number, axisName: string): number;

		getMappedButton(controllerId: number, buttonName: string): boolean;

		resetControllerMapping(controllerId: number): void;

		saveControllerMappings(): void;

		setAxisMapping(
			controllerId: number,
			axisName: string,
			rawAxis: number,
			inverted: boolean,
		): void;

		setButtonMapping(controllerId: number, buttonName: string, rawButton: number): void;
	}

	/** @noSelf */
	interface ControllerProfileModule {
		getControllerAxisNames(controllerId: number): string[];

		getControllerButtonNames(controllerId: number): string[];

		getControllerInputs(controllerId: number): string[];

		getControllerProfile(controllerId: number): DirectGPU.ControllerProfile;

		getControllerType(controllerId: number): string;

		getNamedAxesActive(controllerId: number, threshold: number): string[];

		getNamedAxis(controllerId: number, axisName: string): number;

		getNamedButton(controllerId: number, buttonName: string): boolean;

		getNamedButtonsPressed(controllerId: number): string[];

		hasInput(controllerId: number, inputName: string): boolean;

		refreshControllerProfile(controllerId: number): void;
	}

	/** @noSelf */
	interface ServerControllerModule {
		getPlayerUUID(): string;

		getServerControllerAxes(playerUUID: string, localControllerId: number): number[];

		getServerControllerAxis(
			playerUUID: string,
			controllerId: number,
			axisIndex: number,
		): number;

		getServerControllerButton(
			playerUUID: string,
			controllerId: number,
			buttonIndex: number,
		): boolean;

		getServerControllerButtons(playerUUID: string, localControllerId: number): boolean[];

		getServerControllerCount(playerUUID: string): number;

		getServerControllerInfo(
			playerUUID: string,
			localControllerId: number,
		): DirectGPU.ControllerInfo;

		getServerControllerState(
			playerUUID: string,
			controllerId: number,
		): DirectGPU.ControllerState;

		hasServerController(playerUUID: string, localControllerId: number): boolean;

		listServerControllers(playerUUID: string): DirectGPU.ControllerInfo[] | unknown[];
	}

	/** @noSelf */
	interface CalibrationModule {
		getCalibrationValues(): DirectGPU.CalibrationValues;

		setCalibrationMode(enabled: boolean, divisor: number, subtract: number): void;
	}

	/** @noSelf */
	interface SecurityCameraModule {
		createSecurityCamera(
			displayId: number,
			camX: number,
			camY: number,
			camZ: number,
			yaw: number,
			pitch: number,
			fov: number,
			updateInterval: number,
		): number;

		updateSecurityCamera(cameraId: number, yaw: number, pitch: number, fov?: number): boolean;

		updateSecurityCameraRotation(cameraId: number, yaw: number, pitch: number): boolean;

		stopSecurityCamera(cameraId: number): void;

		listSecurityCameras(): number[] | unknown[];

		getSecurityCameraInfo(
			cameraId: number,
		): DirectGPU.SecurityCameraInfo | Record<string, unknown>;

		captureCamera(
			displayId: number,
			camX: number,
			camY: number,
			camZ: number,
			yaw: number,
			pitch: number,
			fov: number,
		): void;

		captureCameraAuto(displayId: number, camX: number, camY: number, camZ: number): void;
	}

	/** @noSelf */
	interface TerminalRenderModule {
		termRender(
			displayId: number,
			lines: string[],
			...args: unknown[]
		): LuaMultiReturn<[boolean, ...unknown[]]>;
	}

	export type Peripheral = DisplayModule &
		D2DModule &
		TextModule &
		ImageModule &
		TextureModule &
		DictionaryModule &
		CameraModule &
		D3DPrimitivesModule &
		D3DModelsModule &
		LightingModule &
		VectorModule &
		MetaballModule &
		InputModule &
		WorldModule &
		ControllerModule &
		ControllerMappingModule &
		ControllerProfileModule &
		ServerControllerModule &
		CalibrationModule &
		SecurityCameraModule &
		TerminalRenderModule;
}

// ------------------------------------------------------------
// Peripheral intersection type
// ------------------------------------------------------------

declare type DirectGPUPeripheral = DirectGPUModules.Peripheral;

// ------------------------------------------------------------
// Map reader peripheral (separate block type: "map_reader")
// ------------------------------------------------------------

interface DirectGPUMapEntry {
	mapId: number;
	slot: number;
	displayName: string;
}

interface DirectGPUMapData {
	scale: number;
	dimension: string;
	centerX: number;
	centerZ: number;
	locked: boolean;
	pixels: string; // Base64-encoded RGB pixel data
	decorations: unknown[];
}

/** @noSelf */
declare interface DirectGPUMapReaderPeripheral {
	scanAll(): DirectGPUMapEntry[];

	scanInternal(): DirectGPUMapEntry[];

	scanAdjacent(): DirectGPUMapEntry[];

	getMapCounts(): { total: number; [key: string]: number };

	getAdjacentContainers(): unknown[];

	readMap(mapId: number): DirectGPUMapData;
}

// ------------------------------------------------------------
// Camera block peripheral (separate block type: "camera")
// ------------------------------------------------------------

/** @noSelf */
declare interface DirectGPUCameraPeripheral {
	createCamera(
		displayId: number,
		yaw?: number,
		pitch?: number,
		fov?: number,
		updateInterval?: number,
		renderDistance?: number,
	): number;

	updateCamera(cameraId: number, yaw: number, pitch: number, fov?: number): void;

	pointAt(cameraId: number, x: number, y: number, z: number, fov?: number): void;

	stopCamera(cameraId: number): void;

	stopAllCameras(): void;

	listCameras(): number[] | unknown[];

	getCameraInfo(cameraId: number): DirectGPU.CameraBlockInfo | Record<string, unknown>;

	getPos():
		| {
				x: number;
				y: number;
				z: number;
		  }
		| Record<string, unknown>;
}
