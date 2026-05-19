/// <reference types="./aeronautics.d.ts" />
/// <reference types="./cc.d.ts" />
/// <reference types="./ccsable.d.ts" />
/// <reference types="./crafts_additions.d.ts" />
/// <reference types="./directgpu.d.ts" />
/// <reference types="./avionics.d.ts" />

declare type Widen<T> = T extends string
	? string
	: T extends number
		? number
		: T extends boolean
			? boolean
			: T extends Array<infer U>
				? Widen<U>[]
				: T extends object
					? { [K in keyof T]: Widen<T[K]> }
					: T;
