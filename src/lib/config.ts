export namespace Config {
	export type Value = string | number | boolean | null;

	export type Data = {
		[section in string]: {
			[key in string]: Value;
		};
	};
}

export class Config<Data extends Config.Data> {
	loadCooldown = 3;
	private _lastLoad = -Infinity;
	private _order = {} as Record<keyof Data, string[]>;

	constructor(
		public file: string,
		public data: Data,
	) {
		for (const section in data) {
			this._order[section] = Object.keys(data[section]);
		}
		this.load();
	}

	define<S extends keyof Data, K extends keyof Data[S]>(section: S, key: K, value: Data[S][K]) {
		this.load();
		if (!this.get(section, key)) {
			this.set(section, key, value);
			this.save();
		}
	}

	set<S extends keyof Data, K extends keyof Data[S]>(section: S, key: K, value: Data[S][K]) {
		const s = this.data[section] ?? ({} as Data[S]);
		this.data[section] = s;
		s[key] = value;
	}

	get<S extends keyof Data, K extends keyof Data[S]>(section: S, key: K) {
		return this.data[section]?.[key];
	}

	load() {
		if (!fs.exists(this.file)) {
			this.save();
			return this.data;
		}

		if (os.clock() < this._lastLoad + this.loadCooldown) {
			return this.data;
		}

		this._lastLoad = os.clock();

		const [file] = fs.open(this.file, "r");
		if (!file) return;

		let currentSection = "default";
		const lines = file
			.readAll()
			.split("\n")
			.map((line) => line.trim())
			.filter((line) => line !== "" && !line.startsWith(";") && !line.startsWith("#"));

		for (const line of lines) {
			if (line.startsWith("[")) {
				currentSection = line.slice(1, line.length - 1);
			} else {
				const [head, ...tail] = line.split("=");
				const k = head.trim();
				const v = tail.join("=").trim();
				let parsed: any = v;
				if (v === "true") {
					parsed = true;
				} else if (v === "false") {
					parsed = false;
				} else if (tonumber(v) !== undefined) {
					parsed = tonumber(v);
				} else if (v.startsWith('"')) {
					parsed = v.slice(1, v.endsWith(`"`) ? -1 : 0);
				} else {
					//continue;
				}
				this.set(currentSection, k, parsed);
			}
		}

		file.close();
		return this.data;
	}

	save() {
		const [file] = fs.open(this.file, "w");
		if (!file) return;

		const sections = Object.keys(this.data).toSorted();

		for (const sectionName of sections) {
			if (sectionName !== "default") {
				file.writeLine("[" + sectionName + "]");
			}

			for (const key in this.data[sectionName]) {
				let value: any = this.get(sectionName, key);
				if (typeof value === "boolean") {
					value = value ? "true" : "false";
				} else if (typeof value === "number") {
					value = tostring(value);
				} else if (typeof value === "string") {
					value = `"${value}"`;
				} else {
					value = "";
				}

				file.writeLine(key + " = " + value);
			}

			file.writeLine("");
		}

		file.close();
	}

	extend<NewData extends Config.Data>(newData: NewData) {
		const cfg = this as any as Config<Data & NewData>;
		cfg.load();
		for (const section of Object.keys(newData)) {
			for (const key of Object.keys(newData[section])) {
				const value = cfg.get(section, key) ?? newData[section][key];
				cfg.set(section, key, value as any);
			}
		}
		cfg.save();
		return cfg;
	}
}
