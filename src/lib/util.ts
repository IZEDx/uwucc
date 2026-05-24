/*
(_G as any).__error = _G.error;
_G.error = (message: string, level?: number | undefined) => {
	printError(message);
	return (_G as any).__error(message, level) as never;
};
*/

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
