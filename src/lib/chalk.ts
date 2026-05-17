import { KeyEvent, pullEventAs } from "./events";

export const palette = {
	background: { blit: "f", hex: "#1a1626" },
	surface: { blit: "e", hex: "#2e2540" },
	overlay: { blit: "d", hex: "#3d3357" },
	border: { blit: "c", hex: "#54456e" },
	textDisabled: { blit: "b", hex: "#7a6a9a" },
	textSubtle: { blit: "a", hex: "#a08ec0" },
	textMuted: { blit: "0", hex: "#c3b4e0" },
	textDefault: { blit: "9", hex: "#f5f0ff" },
	success: { blit: "8", hex: "#6ed4a0" },
	primary: { blit: "7", hex: "#5ecfcf" },
	info: { blit: "6", hex: "#8ec8f5" },
	secondary: { blit: "5", hex: "#d96fa8" },
	error: { blit: "4", hex: "#f08080" },
	warning: { blit: "3", hex: "#f0c87a" },
	focus: { blit: "2", hex: "#f09bc8" },
	cursor: { blit: "1", hex: "#fce8f3" },
} as const;

export type ColorName = {
	[K in keyof typeof colors]: (typeof colors)[K] extends number ? K : never;
}[keyof typeof colors];
//export type Color = { blit: string; hex: string };

term.setPaletteColor(colors.black, parseInt("#1a1626".slice(1), 16));
term.setPaletteColor(colors.gray, parseInt("#2e2540".slice(1), 16));
term.setPaletteColor(colors.lightGray, parseInt("#3d3357".slice(1), 16));

/** @noSelf */
export function showHeader(title?: string): void {
	const [w, h] = term.getSize();
	let shellTitle = title || getHeader();
	(term as any)._shellTitle = shellTitle;
	clear();
	clearLine(chalk.bgGray);
	printCentered(chalk.bgGray, chalk.pink(shellTitle));
	clearLine(chalk.bgGray);
	clearLine();
}

/** @noSelf */
export function getHeader() {
	return ((term as any)._shellTitle as string | undefined) || ":3";
}

/** @noSelf */
export function clearLine(c = chalk) {
	const [w, h] = term.getSize();
	print(c(string.rep(" ", w)));
}

/** @noSelf */
export function clear() {
	term.setBackgroundColor(colors.black);
	term.clear();
	term.setCursorPos(1, 1);
}

// Helper function to print centered text
/** @noSelf */
export function printCentered(paddingColor: Chalk, ..._text: any[]): void {
	const text = chalk(..._text);
	const [w] = term.getSize();
	const x = math.max(0, math.floor((w - stripStyling(text).length) / 2));
	print(paddingColor(string.rep(" ", x)) + text + paddingColor(string.rep(" ", x)));
}

// TODO: chalkify
export function printError(e: any, maxTrace = 5) {
	if (e === undefined) return;
	term.setTextColor(colors.red);
	_G.print("ERROR:");
	let trace = debug.traceback(tostring(e), 3);
	const error = trace.split("stack traceback:")[0].trim();

	term.setTextColor(colors.orange);
	_G.print(error);

	/*
	//const file = error.split(":")[0].trim();
	const tt = (_G as any).__tracetrace as Record<string, Record<number, string>>;

	//const tracesInFile = ?.[file];

	for (const f of Object.keys(tt)) {
		if (error.includes(f)) {
			const errorLine = tonumber(error.split(f)[1].split(":")[1]) ?? 0;
			for (const l of Object.keys(tt[f])) {
				const functionLine = tonumber(l) ?? 0;
				if (functionLine >= errorLine) {
					break;
				}
				trace = tt[f][functionLine] ?? trace;
			}
		}
		//printValue();
	}
	*/

	term.setTextColor(colors.lightGray);
	print(
		trace
			.split("stack traceback:")
			.slice(1)
			.join("\n")
			.split("\n")
			.map((l) => l.trim())
			.filter((l, i) => l.length > 0 && i < maxTrace)
			.join("\n"),
	);

	//printValue(e);
	term.setTextColor(colors.white);
}

export function printValue(value: any, level = 0) {
	if (typeof value === "number") {
		term.setTextColor(colors.lightBlue);
		print(tostring(value));
	} else if (typeof value === "boolean") {
		term.setTextColor(colors.purple);
		print(tostring(value));
	} else if (typeof value === "string") {
		term.setTextColor(colors.orange);
		print(`"${value}"`);
	} else if (typeof value === "function") {
		term.setTextColor(colors.green);
		print(tostring(value));
	} else if (typeof value === "object" && level < 3) {
		term.setTextColor(colors.lightGray);
		print("{");
		level++;
		for (const key of Object.keys(value as Record<string | number, any>)) {
			term.setTextColor(colors.white);
			term.write(string.rep(" ", level) + `${key} `);
			term.setTextColor(colors.lightGray);
			term.write("= ");
			printValue(value[key]);
		}
		level--;
		term.setTextColor(colors.lightGray);
		print(" ".repeat(level) + "}");
	} else if (typeof value === "object") {
		term.setTextColor(colors.green);
		print(tostring(value));
	} else {
		term.setTextColor(colors.lightGray);
		print(tostring(value));
	}

	term.setTextColor(colors.white);
}

/** @noSelf */
export function anyKey(): void {
	print("");
	term.setTextColor(colors.lightGray);
	print("Press any key to continue...");
	term.setTextColor(colors.white);
	os.pullEvent("key");
}

/** @noSelf */
export function waitForKey(key?: number) {
	while (true) {
		const e = pullEventAs(KeyEvent, "key");

		if (!key || e?.key === key) {
			return;
		}
	}
}

/** @noSelf */
export function print(...args: any[]) {
	write(...args, "\r\n");
}

/** @noSelf */
export function stripStyling(...args: any[]) {
	const styled = chalk(...args);
	let out = "";

	for (let i = 0; i < styled.length; i++) {
		const c = styled[i];
		const [x, y] = term.getCursorPos();
		if (c === "{") {
			const f = styled[i + 1];
			const b = styled[i + 2];
			const colF = colors.fromBlit(f);
			const colB = colors.fromBlit(b);

			if (f === "_" || colF) i++;
			if (b === "_" || colB) i++;
			if (colF || colB || f === "_" || b === "_") {
				i++;
				if (styled[i] === "}") i++;
			} else {
				out += c;
			}
		} else {
			out += c;
		}
	}
	return out;
}

/** @noSelf */
export function write(...args: any[]) {
	const restore = backupStyle();

	const text = chalk(...args);
	//term.write(text);
	const [w, h] = term.getSize();

	for (let i = 0; i < text.length; i++) {
		const c = text[i];
		const [x, y] = term.getCursorPos();
		if (c === "\n") {
			_G.print("");
		} else if (x > w + 2) {
			term.setCursorPos(w - 2, y);
			term.write("...");
		} else if (c === "{") {
			const f = text[i + 1];
			const b = text[i + 2];
			const colF = colors.fromBlit(f);
			const colB = colors.fromBlit(b);

			if (f === "_" || colF) i++;
			if (colF) term.setTextColor(colF);

			if (b === "_" || colB) i++;
			if (colB) term.setBackgroundColor(colB);

			if (colF || colB || f === "_" || b === "_") {
				i++;
				if (text[i] === "}") i++;
			} else {
				term.write(c);
			}
		} else {
			term.write(c);
		}
	}

	restore();
}

/** @noSelf */
function backupStyle() {
	const backup = {
		fg: term.getTextColor(),
		bg: term.getBackgroundColor(),
	};
	return () => {
		term.setTextColor(backup.fg);
		term.setBackgroundColor(backup.bg);
	};
}

export const chalk = chalkFactory({});
/** @noSelf */
function chalkFactory(options: ChalkOptions) {
	const _chalk = ((...args: any[]) => {
		const fgBlit = options?.fg ? colors.toBlit(options.fg) : "_";
		const bgBlit = options?.bg ? colors.toBlit(options.bg) : "_";
		let output = `{${fgBlit}${bgBlit}}`;
		let part;
		while ((part = args.shift())) {
			if (typeof part === "function" && (part as any)["__isChalk"]) {
				return output + (output.length === 3 ? "" : " ") + part(...args);
			} else {
				output += (output.length === 3 ? "" : " ") + tostring(part);
			}
		}
		return output;
	}) as Chalk;

	for (const _name of Object.keys(colors)) {
		const name: ColorName = _name as any;
		const color = colors[name];
		if (typeof color === "number") {
			Object.defineProperty(_chalk, name, {
				get: () => chalkFactory({ ...options, fg: color }),
			});
			Object.defineProperty(_chalk, "bg" + name.slice(0, 1).toUpperCase() + name.slice(1), {
				get: () => chalkFactory({ ...options, bg: color }),
			});
		}
	}

	return _chalk;
}

type RenderFn = (...args: any[]) => string;
export type Chalk = RenderFn & { __isChalk: true } & {
	[K in ColorName]: Chalk;
} & {
	[K in ColorName as `bg${Capitalize<K>}`]: Chalk;
};

type ChalkOptions = {
	fg?: Color;
	bg?: Color;
};
