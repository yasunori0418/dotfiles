import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
} from "https://deno.land/x/ddu_vim@v3.4.2/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.4.2/base/config.ts";
// import { Denops, fn } from "https://deno.land/x/ddu_vim@v3.4.2/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.5.3/file.ts";
import * as opt from "https://deno.land/x/denops_std@v5.0.1/option/mod.ts";

type Params = Record<string, unknown>;

const expandHome = (path: string): string => {
  return path.replace(/^~/, Deno.env.get("HOME") || "");
};

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const winWidth: number = await opt.columns.get(args.denops);
    const winHeight: number = await opt.lines.get(args.denops);

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
          previewFloatingBorder: "single",
          previewSplit: "horizontal",
          previewWindowOptions: [
            ["&signcolumn", "no"],
            ["&foldcolumn", 0],
            ["&foldenable", 0],
            ["&number", 0],
            ["&relativenumber", 0],
            ["&wrap", 0],
          ],
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
          matchers: ["matcher_substring"],
          converters: ["converter_devicon"],
        },
        file: {
          columns: ["icon_filename"],
          converters: [],
        },
        dein: {
          defaultAction: "cd",
        },
        help: {
          defaultAction: "open",
        },
        dein_update: {
          matchers: ["matcher_dein_update"],
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
            uiCd: async (
              args: ActionArguments<Params>,
            ): Promise<ActionFlags> => {
              const action = args.items[0].action as ActionData;

              await args.denops.call("ddu#ui#do_action", "itemAction", {
                name: "narrow",
                params: {
                  path: action.path,
                },
              });

              return Promise.resolve(ActionFlags.None);
            },
            cdOpen: async (
              args: ActionArguments<Params>,
            ): Promise<ActionFlags> => {
              const action = args.items[0].action as ActionData;
              await args.denops.call("chdir", action.path);
              await args.denops.cmd("edit .");

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
      filterParams: {
        matcher_substring: {
          highlightMatched: "Search",
        },
        matcher_kensaku: {
          highlightMatched: "Search",
        },
        matcher_fuse: {
          threshold: 0.6,
        },
        merge: {
          filters: [
            {
              name: "matcher_kensaku",
              weight: 2.0,
            },
            {
              name: "matcher_fuse",
            },
          ],
          unique: true,
        },
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
      ],
    });

    args.contextBuilder.patchLocal("dotfiles-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          startFilter: true,
        },
      },
      sources: [
        {
          name: "file_rec",
          options: {
            path: expandHome("~/dotfiles"),
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("project-list-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          startFilter: true,
        },
      },
      sources: [
        {
          name: "file",
          options: {
            path: Deno.env.get("WORKING_DIR"),
            defaultAction: "cdOpen",
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("help-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          startFilter: true,
        },
      },
      sync: true,
      sources: [
        { name: "help" },
        { name: "readme_viewer" },
      ],
    });

    args.contextBuilder.patchLocal("search_line-ff", {
      ui: "ff",
      uiParams: {
        ff: { startFilter: true },
      },
      sources: [
        {
          name: "line",
          options: {
            matchers: ["matcher_fuse"],
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("buffer-ff", {
      ui: "ff",
      sources: [
        { name: "buffer" },
      ],
    });

    args.contextBuilder.patchLocal("plugin-list-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          startFilter: true,
        },
      },
      sources: [
        {
          name: "dein",
          options: {
            defaultAction: "cdOpen",
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("home-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          startFilter: true,
        },
      },
      sources: [
        {
          name: "file",
          options: {
            path: Deno.env.get("HOME"),
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("register-ff", {
      ui: "ff",
      sources: [
        {
          name: "register",
        },
      ],
    });

    args.contextBuilder.patchLocal("mrr-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          startFilter: true,
        },
      },
      sources: [
        {
          name: "mr",
          options: {
            defaultAction: "cdOpen",
          },
          params: {
            kind: "mrr",
            current: false,
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("mru-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          startFilter: true,
        },
      },
      sources: [
        {
          name: "mr",
          params: {
            kind: "mru",
            current: true,
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("highlight-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          startFilter: true,
        },
      },
      sources: [
        { name: "highlight" },
      ],
    });

    args.contextBuilder.patchLocal("dein_update-ff", {
      ui: "ff",
      sources: [
        {
          name: "dein_update",
        },
      ],
    });

    return Promise.resolve();
  }
}
