export type Pos = {
	x: number;
	y: number;
};

export type Size = {
	w: number;
	h: number;
};

export type Rect = Pos & Size;

export type RGB = { r: number; g: number; b: number };

export type Section = Rect & {
	opaque: boolean;
	mode: "absolute" | "relative";
	align: "top" | "bottom" | "middle";
	justify: "left" | "center" | "right";
};

export type Pos3D = {
	x: number;
	y: number;
	z: number;
};

export type Rotation = {
	pitch: number;
	yaw: number;
	roll: number;
};
