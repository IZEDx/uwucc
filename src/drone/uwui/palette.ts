import { rgb } from "../../lib/uwui-gpu/uwui";

export const palette = {
	bg: (i: number) => rgb(10 * i, 8 * i, 12 * i),
	text: (i: number) => {
		const l = 245 - i * 15;
		return rgb(l, l, l);
	},
};
