import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
} from "https://deno.land/x/ddu_vim@v3.2.7/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.2.7/base/config.ts";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v3.2.7/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.5.2/file.ts";
import * as opt from "https://deno.land/x/denops_std@v5.0.1/option/mod.ts"

type Params = Record<string, unknown>;

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
          previewRow: Math.floor(winHeight / 2),
          previewWidth: Math.floor(winWidth / 2),
          previewHeight: 20,
        },
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: [ "matcher_substring" ],
          converters: [ "converter_devicon" ],
        },
        file: {
          columns: [ "icon_filename" ],
          converters: [],
        },
        dein: {
          defaultAction: "cd",
        },
        help: {
          defaultAction: "open",
        },
        dein_update: {
          matchers: [ "matcher_dein_update" ],
        },
        path_history: {
          defaultAction: "uiCd",
        },
      },
      sourceParams: {
        dein_update: {
          useGraphQL: false,
        },
        rg: {
          args: [
            "--json",
            "--ignore-case",
            "--column",
            "--no-heading",
            "--color",
            "never",
          ],
          highlights: {
            word: "Title",
          },
        },
      },
      kindOptions: {
        file: {
          defaultAction: "open",
          actions: {
            uiCd: async (args: ActionArguments<Params>): Promise<ActionFlags> => {
              const action = args.items[0].action as ActionData;

              await args.denops.call("ddu#ui#sync_action", "itemAction", {
                name: "narrow",
                params: {
                  path: action.path,
                },
              });

              return Promise.resolve(ActionFlags.None);
            },
          },
        },
        action: {
          defaultAction: "do",
        },
        word: {
          defaultAction: "append",
        },
        deol: {
          defaultAction: "switch",
        },
        readme_viewer: {
          defaultAction: "open",
        },
        dein_update: {
          defaultAction: "viewDiff",
        },
      },
      actionOptions: {
        narrow: { quit: false },
        echo: { quit: false },
        echoDiff: { quit: false },
      },
      columnParams: {
        icon_filename: {
          span: 2,
          iconWidth: 2,
          defaultIcon: {
            icon: "",
          },
        },
      },
    });

    args.contextBuilder.patchLocal("current-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          startFilter: true,
        },
      },
      sources: [
        { name: "file_rec" },
      ]
    });

    args.contextBuilder.patchLocal("dotfiles-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          startFilter: true,
        },
      },
      sourceOptions: {
        file_rec: {
          path: await args.denops.call("expand", "~/dotfiles"),
        },
      },
      sources: [
        { name: "file_rec" },
      ],
    });

    return Promise.resolve();
  }
}
