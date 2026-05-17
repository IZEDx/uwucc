import { Font } from "./font";
import { PixelBuffer } from "./helpers";
import { Pixels } from "./pixi";
import { UwUi } from "./uwui";

export interface PositionProps {
	x?: number;
	y?: number;
	mode?: "absolute" | "relative";
	justify?: "left" | "center" | "right";
	align?: "top" | "middle" | "bottom";
}

export interface BoxProps extends PositionProps, UwUi.Props {
	w?: number;
	h?: number;
	bg?: Color | Pixels.GradientFn;
	onClick?: () => any;
}

export class Box<P extends BoxProps = BoxProps> extends UwUi.ClassComponent<P> {
	name = "Box";

	translate(target: Pixels) {
		let x = this.props.x ?? 0;
		let y = this.props.y ?? 0;
		let w = this.props.w ?? target.w - x;
		let h = this.props.h ?? target.h - y;
		if (w === 0) w = target.w - x;
		if (h === 0) h = target.h - y;
		if (this.props.mode !== "absolute") {
			if (math.abs(x) <= 1) x = x * target.w;
			if (math.abs(y) <= 1) y = y * target.h;
			if (math.abs(w) <= 1) w = w * target.w;
			if (math.abs(h) <= 1) h = h * target.h;
		}
		if (x < 0) x = target.w + x;
		if (y < 0) y = target.h + y;
		if (w < 0) w = target.w - x + w;
		if (h < 0) h = target.h - y + h;
		if (this.props.justify === "center") {
			x -= w / 2;
		} else if (this.props.justify === "right") {
			x -= w;
		}
		if (this.props.align === "middle") {
			y -= h / 2;
		} else if (this.props.align === "bottom") {
			y -= h;
		}
		return target.section(x, y, w, h, this.props.bg ?? 0);
	}
}

const fonts = {
	"5px": new Font({ file: "disk/static/sigi-pixel-font-master/Sigi-5px-Regular.json" }),
	"5px-Bold": new Font({ file: "disk/static/sigi-pixel-font-master/Sigi-5px-Bold.json" }),
	"5px-Condesed": new Font({
		file: "disk/static/sigi-pixel-font-master/Sigi-5px-Condensed-Regular.json",
		spacing: { x: 1, y: 1 },
	}),
	"5px-Bold-Condesed": new Font({
		file: "disk/static/sigi-pixel-font-master/Sigi-5px-Condensed-Bold.json",
		spacing: { x: 1, y: 1 },
	}),
	"7px": new Font({ file: "disk/static/sigi-pixel-font-master/Sigi-7px-Regular.json" }),
	"7px-Bold": new Font({ file: "disk/static/sigi-pixel-font-master/Sigi-7px-Bold.json" }),
};

export interface TextProps extends BoxProps {
	font?: Font | keyof typeof fonts;
	color?: Color;
	padding?: number;
}

/** @noSelf */
export const Color = (props: { color: number }, ...children: any[]) => {
	return [props, ...children];
};

export class Text extends Box<TextProps> {
	name = "Text";
	font!: Font;
	text!: string;
	pixels!: number[][];

	translate(target: Pixels) {
		const { props, children } = this;
		const font =
			typeof props.font === "string" ? fonts[props.font] : (props.font ?? fonts["5px"]);
		const text = font.render(
			props.color ?? 1,
			...children.map((c, i) =>
				typeof c === "object" && c["color"]
					? (c["color"] as number)
					: tostring(c) + (i === children.length - 1 ? "" : " "),
			),
			//.join(" "),
		);
		this.text = text.text;
		this.pixels = text.pixels;
		const padding = this.props.padding ?? 0;
		this.props.w = (this.props.w ?? text.w) + padding;
		this.props.h = (this.props.h ?? text.h) + padding;
		return super.translate(target);
	}

	render(dt: number) {
		const padding = (this.props.padding ?? 0) / 2;
		this.target.drawPixels(padding, padding, this.pixels);
	}
}

export const If: UwUi.FunctionComponent = (props?: any, ...children: any[]) => {
	if (props?.condition || props === true) {
		return children;
	} else {
		return [];
	}
};

export interface ButtonProps extends BoxProps, TextProps {}

export const Button: UwUi.FunctionComponent<ButtonProps> = (props, ...children) => {
	if (!props.w || !props.h) {
		return (
			<Text {...props} padding={props.padding ?? 6}>
				{...children}
			</Text>
		);
	}
	return (
		<Box {...props}>
			<Text
				align="middle"
				justify="center"
				x={0.5}
				y={0.5}
				color={props.color}
				font={props.font}
				padding={props.padding ?? 6}
			>
				{...children}
			</Text>
		</Box>
	);
};

export const Columns: UwUi.FunctionComponent<BoxProps> = (props, ...children) => {
	if (children.length === 0) return [];
	const w = 1 / children.length;
	return (
		<Box {...props}>
			{...children.map((child, i) => (
				<Box x={i * w} w={w}>
					{child}
				</Box>
			))}
		</Box>
	);
};
