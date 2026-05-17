import { KeyEvent, pullEventAs } from "../lib/events";

while (true) {
	const e = pullEventAs(KeyEvent, "key");
	if (e) {
		print(keys.getName(e.key));
	}
}
