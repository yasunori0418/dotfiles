import { ConfigArguments, op } from "./deps.ts";

type DdtSplit =
  | ""
  | "floating"
  | "vertical"
  | "farleft"
  | "farright"
  | "horizontal";

type DdtUiSize =
  | DdtFloatingUiSize
  | DdtVerticalUiSize
  | DdtHorizontalUiSize
  | DdtFullWindowUiSize;

type DdtFloatingUiSize = {
  split: "floating";
  winRow: number;
  winCol: number;
  winWidth: number;
  winHeight: number;
};

type DdtVerticalUiSize = {
  split: "vertical" | "farleft" | "farright";
  winWidth: number;
};

type DdtHorizontalUiSize = {
  split: "horizontal";
  winHeight: number;
};

type DdtFullWindowUiSize = {
  split: "";
};

export const ddtUiSize = async (
  args: ConfigArguments,
  split: DdtSplit,
  raitio: number,
): Promise<DdtUiSize> => {
  const { denops } = args;
  const columns = await op.columns.get(denops);
  const lines = await op.lines.get(denops);
  const winWidth = Math.ceil(columns * raitio);
  const winHeight = Math.ceil(lines * raitio);

  switch (split) {
    case "floating": {
      const winCol = Math.ceil((columns - winWidth) / 2);
      const winRow = Math.ceil((lines - winHeight) / 2);
      return {
        split,
        winCol,
        winRow,
        winWidth,
        winHeight,
      } as DdtFloatingUiSize;
    }
    case "vertical":
    case "farleft":
    case "farright":
      return { split, winWidth } as DdtVerticalUiSize;
    case "horizontal":
      return { split, winHeight } as DdtHorizontalUiSize;
    case "":
      return { split } as DdtFullWindowUiSize;
  }
};
