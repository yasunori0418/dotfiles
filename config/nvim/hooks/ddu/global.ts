import {
  // ActionArguments,
  // ActionFlags,
  BaseConfig,
} from "https://deno.land/x/ddu_vim@v3.2.7/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.2.7/base/config.ts";
// import { Denops, fn } from "https://deno.land/x/ddu_vim@v3.2.7/deps.ts";
// import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.5.2/file.ts";
import * as opt from "https://deno.land/x/denops_std@v5.0.1/option/mod.ts"

// type Params = Record<string, unknown>;

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const winWidth = await opt.columns.get(args.denops);
    const winHeight = await opt.lines.get(args.denops);
    args.contextBuilder.patchGlobal({
      uiOptions: {
        filer: {
          toggle: true,
        },
      },
      uiParams: {
        ff: {
          split: "floating",
          floatingBorder: "single",
          prompt: "",
          filterSplitDirection: "floating",
          filterFloatingPosition: "top",
          displaySourceName: "long",
          previewFloating: true,
          previewFloatingBorder: "double",
          previewSplit: "horizontal",
        },
        filer: {
          split: "vertical",
          splitDirection: "topleft",
          winWidth: Math.floor(winWidth / 6),
          previewFloating: true,
          previewFloatingBorder: "single",
          previewCol: Math.floor(winWidth / 4),
          previewRow: winHeight,
          previewWidth: winWidth,
          previewHeight: 20,
        },
      },
    });
    return Promise.resolve();
  }
}
