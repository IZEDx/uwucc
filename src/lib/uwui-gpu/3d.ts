import { Line } from "./components";

function parseIndex(value: string | null, count: number): number | null {
	const parsed = value === null ? NaN : Number(value);

	if (Number.isNaN(parsed)) {
		return null;
	}

	return parsed < 0 ? count + parsed + 1 : parsed;
}

function parseFaceToken(token: string, vertexCount: number): number | null {
	const [match] = string.match(token, "^(-?%d+)");
	return parseIndex(match ?? null, vertexCount);
}

function normalizeVector(x: number, y: number, z: number): [number, number, number] {
	const length = Math.sqrt(x * x + y * y + z * z);

	if (length <= 0) {
		return [0, 1, 0];
	}

	return [x / length, y / length, z / length];
}

function makeNormal(a: number[], b: number[], c: number[]): [number, number, number] {
	const ux = b[0] - a[0];
	const uy = b[1] - a[1];
	const uz = b[2] - a[2];

	const vx = c[0] - a[0];
	const vy = c[1] - a[1];
	const vz = c[2] - a[2];

	return normalizeVector(uy * vz - uz * vy, uz * vx - ux * vz, ux * vy - uy * vx);
}

/** @noSelf */
export function prepareOBJ(data: string): [string, number, number] {
	const sourceVertices: number[][] = [];
	const faceLines: string[] = [];

	let minX = Infinity;
	let minY = Infinity;
	let minZ = Infinity;
	let maxX = -Infinity;
	let maxY = -Infinity;
	let maxZ = -Infinity;

	for (const [line] of string.gmatch(data, "[^\r\n]+")) {
		const [x, y, z] = string.match(
			line,
			"^%s*v%s+([%+%-%.%deE]+)%s+([%+%-%.%deE]+)%s+([%+%-%.%deE]+)",
		);

		if (x !== undefined) {
			const vx = tonumber(x)!;
			const vy = tonumber(z)!;
			const vz = -tonumber(y)!;

			sourceVertices.push([vx, vy, vz]);

			minX = Math.min(minX, vx);
			minY = Math.min(minY, vy);
			minZ = Math.min(minZ, vz);

			maxX = Math.max(maxX, vx);
			maxY = Math.max(maxY, vy);
			maxZ = Math.max(maxZ, vz);
		}

		if (string.match(line, "^%s*f%s+")[0] !== undefined) {
			faceLines.push(line);
		}
	}

	if (sourceVertices.length === 0) {
		throw new Error("OBJ contains no vertices");
	}

	const centerX = (minX + maxX) * 0.5;
	const centerY = (minY + maxY) * 0.5;
	const centerZ = (minZ + maxZ) * 0.5;

	const span = math.max(maxX - minX, maxY - minY, maxZ - minZ);
	const scale = span > 0 ? 1 / span : 1;

	for (const v of sourceVertices) {
		v[0] = (v[0] - centerX) * scale;
		v[1] = (v[1] - centerY) * scale;
		v[2] = (v[2] - centerZ) * scale;
	}

	const vertices: number[][] = [];
	const normals: number[][] = [];
	const faces: number[][] = [];

	function pushVertex(v: number[], nx: number, ny: number, nz: number): number {
		vertices.push([v[0], v[1], v[2]]);
		normals.push([nx, ny, nz]);
		return vertices.length;
	}

	function pushTriangle(a: number[], b: number[], c: number[]): void {
		let [nx, ny, nz] = makeNormal(a, b, c);

		const cx = (a[0] + b[0] + c[0]) / 3;
		const cy = (a[1] + b[1] + c[1]) / 3;
		const cz = (a[2] + b[2] + c[2]) / 3;

		if (nx * cx + ny * cy + nz * cz < 0) {
			const temp = b;
			b = c;
			c = temp;
			nx = -nx;
			ny = -ny;
			nz = -nz;
		}

		const a1 = pushVertex(a, nx, ny, nz);
		const b1 = pushVertex(b, nx, ny, nz);
		const c1 = pushVertex(c, nx, ny, nz);

		const a2 = pushVertex(a, nx, ny, nz);
		const b2 = pushVertex(c, nx, ny, nz);
		const c2 = pushVertex(b, nx, ny, nz);

		faces.push([a1, b1, c1]);
		faces.push([a2, b2, c2]);
	}

	for (const line of faceLines) {
		const indices: number[] = [];
		for (const [token] of string.gmatch(line, "%S+")) {
			if (token !== "f") {
				const index = parseFaceToken(token, sourceVertices.length);
				if (index !== null) {
					indices.push(index);
				}
			}
		}

		for (let i = 1; i < indices.length - 1; i += 1) {
			const a = sourceVertices[indices[0] - 1];
			const b = sourceVertices[indices[i] - 1];
			const c = sourceVertices[indices[i + 1] - 1];

			if (a !== undefined && b !== undefined && c !== undefined) {
				pushTriangle(a, b, c);
			}
		}
	}

	const out: string[] = [];

	for (const v of vertices) {
		out.push(`v ${v[0].toFixed(8)} ${v[1].toFixed(8)} ${v[2].toFixed(8)}`);
	}

	for (const n of normals) {
		out.push(`vn ${n[0].toFixed(8)} ${n[1].toFixed(8)} ${n[2].toFixed(8)}`);
	}

	for (const f of faces) {
		out.push(`f ${f[0]}//${f[0]} ${f[1]}//${f[1]} ${f[2]}//${f[2]}`);
	}

	return [out.join("\n"), vertices.length, faces.length];
}
