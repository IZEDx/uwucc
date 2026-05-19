import { clamp, lerp, niceStep } from "../../lib/math";
import { each } from "../../lib/uwui-gpu/hooks";
import { Line } from "../../lib/uwui-gpu/components";
import { useSignal, useTick, useGPU } from "../../lib/uwui-gpu/hooks";
import { Box, rgb, Signal, UwUi } from "../../lib/uwui-gpu/uwui";
import { Controller } from "../controller";
import { palette } from "./palette";
import { RGB } from "../../lib/uwui-gpu/colors";
import { AltitudeGraph } from "./altitudeGraph";
import { LAC } from "../../lib/algorithm/lac";

const TITLE_FONT_SIZE = 12;
const LABEL_FONT_SIZE = 10;
