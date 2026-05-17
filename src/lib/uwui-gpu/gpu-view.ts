import { printError } from "../chalk";
import { clamp } from "../math";
import { Pos, Rect, RGB } from "./types";

/*
export interface GPUView {
	clear(r?: number, g?: number, b?: number): void;
	fillRect(x: number, y: number, w: number, h: number, r: number, g: number, b: number): void;
	drawRect(x: number, y: number, w: number, h: number, r: number, g: number, b: number): void;
	drawLine(x1: number, y1: number, x2: number, y2: number, r: number, g: number, b: number): void;
	drawCircle(
		cx: number,
		cy: number,
		radius: number,
		r: number,
		g: number,
		b: number,
		filled: boolean,
	): void;
	drawEllipse(
		cx: number,
		cy: number,
		rx: number,
		ry: number,
		r: number,
		g: number,
		b: number,
		filled: boolean,
	): void;
	fillEllipse(
		cx: number,
		cy: number,
		rx: number,
		ry: number,
		r: number,
		g: number,
		b: number,
	): void;
	drawPolygon(points: DirectGPU.Point[], r: number, g: number, b: number): void;
	drawPolylines(points: DirectGPU.Point[], r: number, g: number, b: number): void;
	drawText(
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
		text: string,
		x: number,
		y: number,
		r?: number,
		g?: number,
		b?: number,
		fontSize?: number,
	): DirectGPU.TextMetrics;
	drawTextWrapped(
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
		text: string,
		x: number,
		y: number,
		maxWidth: number,
		r?: number,
		g?: number,
		b?: number,
		fontSize?: number,
	): DirectGPU.TextMetrics;
	drawRoundedRect(
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
	drawStar(
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
	drawSVGPath(
		pathData: string,
		x: number,
		y: number,
		scale: number,
		r: number,
		g: number,
		b: number,
	): void;
	setPixel(x: number, y: number, r: number, g: number, b: number): void;
	getPixel(x: number, y: number): DirectGPU.Color;
	drawBezierCurve(
		points: DirectGPU.Point[],
		r: number,
		g: number,
		b: number,
		segments?: number,
	): void;
	childRect(x: number, y: number, w: number, h: number): GPUView;
	withOffset(x: number, y: number): GPUView;
	getOpaque(): boolean;
	setOpaque(value: boolean): void;
}
	*/

function intersects(a: Rect, b: Rect) {
	return a.x < b.x + b.w && a.x + a.w > b.x && a.y < b.y + b.h && a.y + a.h > b.y;
}

function clampRect(parent: Rect, child: Rect) {
	const x = math.max(parent.x, child.x);
	const y = math.max(parent.y, child.y);
	const maxX = math.min(parent.x + parent.w, child.x + child.w);
	const maxY = math.min(parent.y + parent.h, child.y + child.h);
	return { x, y, w: math.max(0, maxX - x), h: math.max(0, maxY - y) };
}

export class GPUView {
	constructor(
		public readonly gpu: DirectGPUPeripheral,
		public readonly display: number,
		public readonly clip: Rect,
		//public opaque = true,
	) {}

	createView(rect: Rect) {
		rect = { ...rect, x: this.clip.x + rect.x, y: this.clip.y + rect.y };
		return new GPUView(this.gpu, this.display, clampRect(this.clip, rect));
	}

	translateX(x: number) {
		return x + this.clip.x;
	}

	translateY(y: number) {
		return y + this.clip.y;
	}

	translatePoint([x, y]: DirectGPU.Point) {
		return [x + this.clip.x, y + this.clip.y];
	}

	clear(r = 0, g = 0, b = 0) {
		this.gpu.clear(this.display, r, g, b);
	}

	translatePos({ x, y }: Pos) {
		return {
			x: x + this.clip.x,
			y: y + this.clip.y,
		};
	}

	translateRect(rect: Rect) {
		return { ...rect, ...this.translatePos(rect) };
	}

	fillRect(rect: Rect, r: number, g: number, b: number) {
		rect = this.translateRect(rect);
		if (intersects(this.clip, rect)) {
			const { x, y, w, h } = clampRect(this.clip, rect);
			this.gpu.fillRect(this.display, x, y, w, h, r, g, b);
		}
	}

	drawRoundedRect(rect: Rect, radius: number, { r, g, b }: RGB, filled: boolean) {
		rect = this.translateRect(rect);
		if (intersects(this.clip, rect)) {
			const { x, y, w, h } = clampRect(this.clip, rect);
			this.gpu.drawRoundedRect(this.display, x, y, w, h, radius, r, g, b, filled);
		}
	}
	drawRect(x: number, y: number, w: number, h: number, r: number, g: number, b: number) {
		const xx = this.translateX(x);
		const yy = this.translateY(y);
		if (!intersects(this.clip, { x: xx, y: yy, w, h })) return;
		this.gpu.fillRect(this.display, xx, yy, w, 1, r, g, b);
		this.gpu.fillRect(this.display, xx, yy + h - 1, w, 1, r, g, b);
		this.gpu.fillRect(this.display, xx, yy, 1, h, r, g, b);
		this.gpu.fillRect(this.display, xx + w - 1, yy, 1, h, r, g, b);
	}
	drawLine(x1: number, y1: number, x2: number, y2: number, r: number, g: number, b: number) {
		x1 = this.translateX(clamp(x1, 1, this.clip.w - 1));
		y1 = this.translateY(clamp(y1, 1, this.clip.h - 1));
		x2 = this.translateX(clamp(x2, 1, this.clip.w - 1));
		y2 = this.translateY(clamp(y2, 1, this.clip.h - 1));
		this.gpu.drawLine(this.display, x1, y1, x2, y2, r, g, b);
	}
	drawCircle(
		cx: number,
		cy: number,
		radius: number,
		r: number,
		g: number,
		b: number,
		filled: boolean,
	) {
		this.gpu.drawCircle(this.display, cx, cy, radius, r, g, b, filled);
	}
	drawEllipse(
		cx: number,
		cy: number,
		rx: number,
		ry: number,
		r: number,
		g: number,
		b: number,
		filled: boolean,
	) {
		this.gpu.drawEllipse(this.display, cx, cy, rx, ry, r, g, b, filled);
	}
	fillEllipse(cx: number, cy: number, rx: number, ry: number, r: number, g: number, b: number) {
		this.gpu.fillEllipse(this.display, cx, cy, rx, ry, r, g, b);
	}
	drawPolygon(points: DirectGPU.Point[], r: number, g: number, b: number) {
		this.gpu.drawPolygon(this.display, points, r, g, b);
	}
	drawPolylines(points: DirectGPU.Point[], r: number, g: number, b: number) {
		this.gpu.drawPolylines(this.display, points, r, g, b);
	}
	drawText(
		text: string,
		x: number,
		y: number,
		r: number,
		g: number,
		b: number,
		fontName: string,
		fontSize: number,
		style: DirectGPU.FontStyle,
	) {
		return this.gpu.drawText(
			this.display,
			text,
			this.translateX(x),
			this.translateY(y),
			r,
			g,
			b,
			fontName,
			fontSize,
			style,
		);
	}
	/** DON'T USE! This one is broken in the dependency, it flickers randomly and doesn't size properly */
	drawTextFast(
		text: string,
		x: number,
		y: number,
		r?: number,
		g?: number,
		b?: number,
		fontSize?: number,
	) {
		return this.gpu.drawTextFast(
			this.display,
			text,
			this.translateX(x),
			this.translateY(y),
			r,
			g,
			b,
			fontSize,
		);
	}
	drawTextWrapped(
		text: string,
		pos: Pos,
		{ r, g, b }: RGB,
		maxWidth: number,
		lineSpacing: number,
		fontName: string,
		fontSize: number,
		style: DirectGPU.FontStyle,
	) {
		const { x, y } = this.translatePos(pos);
		return this.gpu.drawTextWrapped(
			this.display,
			text,
			x,
			y,
			maxWidth,
			r,
			g,
			b,
			lineSpacing,
			fontName,
			fontSize,
			style,
		);
	}
	/** DON'T USE! This one is broken in the dependency, it flickers randomly and doesn't size properly */
	drawTextWrappedFast(
		text: string,
		x: number,
		y: number,
		maxWidth: number,
		r?: number,
		g?: number,
		b?: number,
		fontSize?: number,
	) {
		return this.gpu.drawTextWrappedFast(
			this.display,
			text,
			this.translateX(x),
			this.translateY(y),
			maxWidth,
			r,
			g,
			b,
			fontSize,
		);
	}

	drawStar(
		cx: number,
		cy: number,
		pointCount: number,
		outerRadius: number,
		innerRadius: number,
		r: number,
		g: number,
		b: number,
		filled: boolean,
	) {
		this.gpu.drawStar(
			this.display,
			this.translateX(cx),
			this.translateY(cy),
			pointCount,
			outerRadius,
			innerRadius,
			r,
			g,
			b,
			filled,
		);
	}
	drawSVGPath(
		pathData: string,
		x: number,
		y: number,
		scale: number,
		r: number,
		g: number,
		b: number,
	) {
		this.gpu.drawSVGPath(
			this.display,
			pathData,
			this.translateX(x),
			this.translateY(y),
			scale,
			r,
			g,
			b,
		);
	}
	setPixel(x: number, y: number, r: number, g: number, b: number) {
		this.gpu.setPixel(this.display, this.translateX(x), this.translateY(y), r, g, b);
	}
	getPixel(x: number, y: number) {
		return this.gpu.getPixel(this.display, this.translateX(x), this.translateY(y));
	}
	drawBezierCurve(points: DirectGPU.Point[], r: number, g: number, b: number, segments?: number) {
		this.gpu.drawBezierCurve(this.display, points, r, g, b, segments);
	}
}
