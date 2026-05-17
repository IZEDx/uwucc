import { anyKey, showHeader } from "./chalk";
import { stopRotors } from "../drone/peripherals";

export function program(...fns: Array<() => void>): void {
	let ok = true;
	parallel.waitForAny(
		...fns.map((fn) => {
			return () => {
				try {
					return fn();
				} catch (e) {
					printError(e);
					ok = false;
				}
			};
		}),
	);

	term.setGraphicsMode(false);
	//if (!ok) anyKey();
	//shell.run("disk/startup.lua");
}

/** @noSelf */
export function runSafe(fn: () => any): [ok: true, err: undefined] | [ok: false, err: unknown] {
	try {
		fn();
		return [true, undefined];
	} catch (e) {
		printError(e);
		return [false, e];
	}
}
