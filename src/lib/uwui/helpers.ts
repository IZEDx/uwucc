/** @noSelf */
export function normalizeChildren<C>(children: C[]): C[] {
	if (!Array.isArray(children)) {
		return [children] as C[];
	}
	const normalized = [] as C[];
	let curString = "";
	for (const c of children) {
		if (typeof c === "string") {
			curString += c.trim() + " ";
		} else {
			if (curString !== "") {
				normalized.push(curString.slice(0, curString.length - 1) as C);
				curString = "";
			}
			if (Array.isArray(c)) {
				normalized.push(...normalizeChildren(c));
			} else {
				normalized.push(c);
			}
		}
	}
	if (curString !== "") normalized.push(curString.slice(0, curString.length - 1) as C);
	return normalized;
}

/** @noSelf */
export function buffer<T>(size: number, prime: T) {
	const b = [] as T[];
	for (let i = 0; i < size; i++) {
		b[i] = prime;
	}
	return b;
}

export type PixelBuffer = string[] | number[][];

/** @noSelf */
export function pixelBuffer(w: number, h: number, prime: number) {
	w = math.ceil(w);
	h = math.ceil(h);
	const b = [] as number[][];
	for (let y = 0; y < h; y++) {
		b[y] = buffer(w, prime);
	}
	return b;
}

/** @noSelf */
export function parseStringBuffer(rows: string[]) {
	return rows.map((r, y) => r.split("").map((s) => string.byte(s)));
}
