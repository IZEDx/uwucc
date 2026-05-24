import { program } from "../lib/program";
import { Color } from "../lib/uwui/color";
import { Box, BoxProps, Button, Columns, If, Text, TextProps } from "../lib/uwui/components";
import { UwUi } from "../lib/uwui/uwui";

term.clear();
term.setCursorPos(1, 1);
const uwui = new UwUi({ term });

const inset = (n: number): BoxProps => ({ x: n, y: n, w: -n, h: -n });
const centered: TextProps = {
	x: 0.5,
	y: 0.5,
	justify: "center",
	align: "middle",
};

const start = os.clock();

const transFlag = Color.gradient(
	30,
	Color.hsl(0.57, 0.8, 0.7),
	Color.hsl(0.9, 0.6, 0.8),
	Color.hsl(0.8, 0, 0.9),
	Color.hsl(0.8, 0, 0.9),
	Color.hsl(0.8, 0, 0.9),
	Color.hsl(0.9, 0.6, 0.8),
	Color.hsl(0.57, 0.8, 0.7),
);

/*
const loadTime = 0.5;
let t = 0;
do {
	sleep(0);
	t = (os.clock() - start) / loadTime;
	uwui.render(<Box {...inset(0.5 - t / 2)} bg={transFlag.vertical}></Box>);
} while (t < 1);
*/
uwui.render(<Box bg={transFlag.vertical}></Box>);

const pink = Color.hsl(0.9, 0.6, 0.8);
const bg = Color.hsl(0.73, 0.25, 0.15);
const surface = Color.hsl(0.68, 0.22, 0.26);

const root = fs.combine(fs.getDir(shell.getRunningProgram()), "..");
const programs = {} as Record<
	string,
	{
		name: string;
		color: Color;
	}[]
>;

programs[""] = fs
	.list(fs.combine(root, "programs"))
	.filter((f) => f.endsWith(".lua") && f !== "gui.lua")
	.map((f) => ({ name: f.slice(0, -4), color: pink }));

fs.list(root)
	.map((f) => [f, fs.combine(root, f, "programs")])
	.filter(([_, p]) => fs.isDir(p))
	.forEach(([file, dir]) => {
		const color = Color.hsl(math.random(), 0.6, 0.8);
		programs[file] = fs
			.list(dir)
			.filter((f) => f.endsWith(".lua"))
			.map((f) => ({
				name: f.slice(0, -4),
				color,
			}));
	});

const App = () => (
	<Box {...inset(5)} bg={bg.idx}>
		<Text
			color={pink.idx}
			justify="center"
			align="middle"
			font="7px-Bold"
			x={0.5}
			y={0.3 /*0.3 + math.sin(os.clock()) * 0.05*/}
		>
			owo OS
		</Text>
		<Box stale="programs">
			<Columns justify="center" x={0.5}>
				{...Object.entries(programs).map(([category, ps]) => (
					<Box>
						<Text
							color={pink.idx}
							justify="center"
							x={0.5}
							align="bottom"
							y={-20 - ps.length * 15}
						>
							{category}
						</Text>
						{...ps.map((p, i) => (
							<Button
								bg={p.color.idx}
								color={bg.idx}
								justify="center"
								x={0.5}
								align="bottom"
								h={13}
								w={0.8}
								padding={0}
								y={-20 - i * 15}
								font={"7px"}
								onClick={() => {
									uwui.defer(() => {
										shell.run(
											fs.combine(root, category, "programs", p.name + ".lua"),
										);
									});
								}}
							>
								{p.name}
							</Button>
						))}
					</Box>
				))}
			</Columns>
		</Box>
		<Button
			stale="shell"
			bg={surface.idx}
			color={pink.idx}
			justify="right"
			x={-4}
			y={4}
			font={"5px-Bold-Condesed"}
			onClick={() => {
				uwui.stop();
			}}
		>
			{">_"}
		</Button>
	</Box>
);

program(
	() => uwui.run(App),
	//() => waitForKey(keys.space),
);
