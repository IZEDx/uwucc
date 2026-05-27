/*
(_G as any).__error = _G.error;
_G.error = (message: string, level?: number | undefined) => {
	printError(message);
	return (_G as any).__error(message, level) as never;
};
*/

export function readFile(path: string): string | undefined {
	const [file] = fs.open(path, "r");
	const result = file?.readAll();
	file?.close();
	return result;
}

export function pairs<T extends Record<any, any>>(obj: T): [keyof T, T[keyof T]][] {
	return Object.entries(obj);
}

export function memoize<F extends (...args: any[]) => any>(fn: F): F {
	const cache = {} as Record<string, [ReturnType<F>]>;
	return ((...args: Parameters<F>) => {
		const key = args.map((a) => tostring(a)).join(";");
		let entry = cache[key];
		if (!entry) {
			entry = [fn(...args)];
			cache[key] = entry;
		}
		return entry[0];
	}) as F;
}

/*
export function map<T, U>(t: T[], fn: (v: T, i: number, t: T[]) => U): U[] {
	const result: U[] = [];
	for (let i = 0; i < t.length; i++) {
		result[i] = fn(t[i], i, t);
	}
	return result;
}
*/

const logFile = "disk/log";
const [file] = fs.open(logFile, "w");
file?.write("");
file?.close();

export function log(...args: any[]) {
	//const [file] = fs.open(logFile, "a");
	//if (!file) return;
	//file.writeLine(args.map((s) => tostring(s)).join(" "));
	//file.close();
}

export function getLuaFunctionLabel(fn: (...args: any[]) => any): string {
	const info = debug.getinfo(fn, "Sn");
	const name = info?.name;
	if (name && name.length > 0) return name;
	const src = info?.short_src ?? info?.source ?? "<fn>";
	const line = info?.linedefined ?? -1;
	return `${src}:${line}`;
}

const CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

const LOOKUP: number[] = [];
for (let i = 0; i < CHARS.length; i++) LOOKUP[CHARS.charCodeAt(i)] = i;

export function base64Encode(input: string): string {
	let result = "";
	let i = 0;

	while (i < input.length) {
		const b0 = input.charCodeAt(i++);
		const b1 = i < input.length ? input.charCodeAt(i++) : 0;
		const b2 = i < input.length ? input.charCodeAt(i++) : 0;
		const rem = input.length - i;

		result += CHARS[b0 >> 2];
		result += CHARS[((b0 & 0x3) << 4) | (b1 >> 4)];
		result += rem >= -1 ? CHARS[((b1 & 0xf) << 2) | (b2 >> 6)] : "=";
		result += rem >= 0 ? CHARS[b2 & 0x3f] : "=";
	}

	return result;
}

export function base64Decode(input: string): string {
	const [clean] = string.gsub(input, "=", "");
	let result = "";

	for (let i = 0; i < clean.length; i += 4) {
		const c0 = LOOKUP[clean.charCodeAt(i)];
		const c1 = LOOKUP[clean.charCodeAt(i + 1)];
		const c2 = i + 2 < clean.length ? LOOKUP[clean.charCodeAt(i + 2)] : 0;
		const c3 = i + 3 < clean.length ? LOOKUP[clean.charCodeAt(i + 3)] : 0;

		result += String.fromCharCode((c0 << 2) | (c1 >> 4));
		if (i + 2 < clean.length) result += String.fromCharCode(((c1 & 0xf) << 4) | (c2 >> 2));
		if (i + 3 < clean.length) result += String.fromCharCode(((c2 & 0x3) << 6) | c3);
	}

	return result;
}
