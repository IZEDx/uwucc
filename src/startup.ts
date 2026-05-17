term.clear();
term.setCursorPos(1, 1);

import { log } from "./lib/util";
import { showHeader, print, chalk, printCentered } from "./lib/chalk";
import { Config } from "./lib/config";

const config = new Config(".owo", {
	default: {
		gui: true,
	},
});

showHeader(":3");

printCentered(chalk.bgBlack.lightBlue, "Available programs:");

const root = "disk";
print("");

let programs = fs
	.list(root + "/programs")
	.filter((f) => f.endsWith(".lua"))
	.map((f) => f.slice(0, -4));
programs.forEach((f) => {
	shell.setAlias(f, root + "/programs/" + f + ".lua");
});
printCentered(chalk.bgBlack, programs.map((f) => chalk.pink(f)).join(chalk.lightGray(", ")));

print("");
for (const file of fs.list(root)) {
	const dir = root + "/" + file + "/programs/";
	if (fs.isDir(dir)) {
		let programs = fs
			.list(dir)
			.filter((f) => f.endsWith(".lua"))
			.map((f) => f.slice(0, -4));
		programs.forEach((f) => {
			shell.setAlias(file + "_" + f, dir + f + ".lua");
		});
		print(
			chalk.lightGray(" - "),
			chalk.black.bgPink(file).trim(),
			chalk.lightGray.bgBlack(": "),
			programs.map((f) => chalk.white(f)).join(chalk.lightGray(", ")),
		);
	}
}
print("");
if (config.data.default.gui) {
	//shell.run("disk/programs/gui.lua");
}

/*
shell.setAlias("test", "disk/startup.lua test");
shell.setAlias("start", "disk/dist/programs/control.lua");
shell.setAlias("stop", "disk/dist/programs/stop.lua");
shell.setAlias("tune", "disk/dist/programs/tune.lua");
shell.setAlias("calibrate", "disk/dist/programs/calibrate.lua");


print("Shell aliases configured:");
print("  start   - Launch flight controller");
print("  stop    - Emergency motor stop");
print("  tune    - PID auto-tuner");
print("  calibrate - Trim calibration");
*/
