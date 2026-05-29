import { Box, Text } from "./basic";
import { extract, Getters } from "../signal";
import { UwUi } from "../runtime";

export namespace Button {
	export type Props = Box.Props &
		Text.Props & {
			/** @noSelf */
			onClick?: (event: DirectGPU.InputEvent) => any;
		};
}

export function Button(props: Getters<Button.Props>, ...children: any[]) {
	return (
		<Box
			{...props}
			onInput={(e) => {
				if (e.type === "mouse_click") {
					props.onClick?.(e);
				}
			}}
		>
			<Text x={0.5} y={0.5} align="middle" justify="center">
				{...children}
			</Text>
		</Box>
	);
}
