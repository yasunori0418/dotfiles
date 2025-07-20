import { ConfigArguments, op } from "./deps.ts";

export const expandHome = (path: string): string => {
  return path.replace(/^~/, Deno.env.get("HOME") || "");
};

type DduUiSize = {
  winRow: number;
  winCol: number;
  winWidth: number;
  winHeight: number;
  previewFloating: boolean;
  previewSplit: "vertical" | "horizontal";
  previewRow: number;
  previewCol: number;
  previewHeight: number;
  previewWidth: number;
};

export async function uiSize(
  args: ConfigArguments,
  splitRaitio: number,
  previewSplit: "horizontal" | "vertical",
): Promise<DduUiSize> {
  const { denops } = args;
  const FRAME_SIZE = 2;
  const columns = await op.columns.get(denops);
  const lines = await op.lines.get(denops);
  const winRow = -1;
  const winCol = 0;

  let winHeight!: number;
  let winWidth!: number;
  let previewRow!: number;
  let previewCol!: number;
  let previewHeight!: number;
  let previewWidth!: number;

  const splitWindowLength = (length: number): number => {
    return Math.floor(length * splitRaitio);
  };

  if (previewSplit === "horizontal") {
    winHeight = splitWindowLength(lines);
    winWidth = columns - FRAME_SIZE - 1;
    previewRow = lines - FRAME_SIZE;
    previewCol = 0;
    previewHeight = (lines - winHeight) - (FRAME_SIZE * 3);
    previewWidth = winWidth;
  } else if (previewSplit === "vertical") {
    winHeight = lines - FRAME_SIZE - 1;
    winWidth = splitWindowLength(columns);
    previewRow = 0;
    previewCol = columns - FRAME_SIZE;
    previewHeight = winHeight;
    previewWidth = columns - winWidth - (FRAME_SIZE * 3);
  }

  return {
    winRow,
    winCol,
    winWidth,
    winHeight,
    previewFloating: true,
    previewSplit,
    previewRow,
    previewCol,
    previewHeight,
    previewWidth,
  };
}

type DduDummySource = {
  name: string;
  params: {
    word: string;
    hlGroup: string;
  };
};

export function separator(
  word: string,
  hlGroup:
    | "ErrorMsg"
    | "Type"
    | "Keyword"
    | "String" = "Type",
): DduDummySource {
  return {
    name: "dummy",
    params: {
      word: word,
      hlGroup: hlGroup,
    },
  };
}
