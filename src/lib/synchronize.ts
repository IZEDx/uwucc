type Task<T> = {
	at?: number;
	fn: () => T;
	res: (v: T) => any;
	rej: (err: any) => any;
};

let queue = [] as Task<any>[];

/** @noSelf */
export function schedule<R>(fn: () => R): Promise<R> {
	return new Promise((res, rej) => {
		queue.push({ fn, res, rej });
	});
}

export function synchronize() {
	const startTime = os.clock();
	while (true) {
		const now = os.clock();
		print("DT: ", now - startTime);
		parallel.waitForAll(
			() => sleep(0),
			...queue.map((task) => () => {
				if (!task.at || task.at <= now) {
					try {
						task.res(task.fn());
					} catch (e) {
						task.rej(e);
					}
				}
			}),
		);
		queue = queue.filter((task) => task.at && task.at > now);
	}
}
