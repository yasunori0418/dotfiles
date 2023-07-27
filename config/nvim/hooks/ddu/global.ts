import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
  ConfigArguments,
  ActionData,
  uiSize,
  expandHome,
} from "./helper/deps.ts";

type Params = Record<string, unknown>;

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
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
          ...{
            split: "floating",
            splitDirection: "topleft",
            floatingBorder: "single",
            sort: "filename",
            sortTreesFirst: true,
            displayRoot: false,
            previewFloatingBorder: "single",
            previewWindowOptions: [
              ["&signcolumn", "no"],
              ["&foldcolumn", 0],
              ["&foldenable", 0],
              ["&number", 0],
              ["&relativenumber", 0],
              ["&wrap", 0],
            ],
          },
          ...await uiSize(args, 0.2, "vertical"),
        },
      },
      sourceOptions: {
        _: {
          matchers: ["matcher_substring"],
        },
        file: {
          columns: ["icon_filename"],
        },
        file_rec: {
          ignoreCase: true,
          converters: [
            "converter_devicon",
            "converter_hl_dir",
          ],
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
        git_status: {
          converters: [
            "converter_hl_dir",
            "converter_devicon",
            "converter_git_status",
          ],
        },
        mr: {
          converters: [
            "converter_devicon",
            "converter_hl_dir",
          ],
        },
        buffer: {
          converters: [
            "converter_hl_dir",
          ],
        },
        rg: {
          converters: [
            "converter_devicon",
            "converter_hl_dir",
          ],
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
        git_status: {
          defaultAction: "open",
          actions: {
            gitDiff: async (
              args: ActionArguments<Params>,
            ): Promise<ActionFlags> => {
              const action = args.items[0].action as ActionData;

              await args.denops.call("ddu#start", {
                name: "git_diff-ff",
                sourceOptions: {
                  git_diff: {
                    path: action.path,
                  },
                },
              });

              return Promise.resolve(ActionFlags.None);
            },
          }
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
        converter_hl_dir: {
          hlGroup: [
            "Directory",
            "Number",
            "Type",
          ],
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

    // UI: fuzzy-finder

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
          startFilter: false,
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

    args.contextBuilder.patchLocal("ripgrep-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          ...{
            startAutoAction: true,
            autoAction: {
              delay: 0,
              name: "preview",
            },
            autoResize: false,
            startFilter: true,
            filterFloatingPosition: "top",
          },
          ...await uiSize(args, 0.3, "horizontal"),
        }
      },
      sources: [
        {
          name: "rg",
          options: {
            matchers: [],
            volatile: true,
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("path_history-ff", {
      ui: "ff",
      sources: [
        { name: "path_history" },
      ],
    });

    args.contextBuilder.patchLocal("git_status-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          ...{
            startAutoAction: true,
            autoAction: {
              delay: 0,
              name: "preview",
            },
            autoResize: false,
            filterFloatingPosition: "bottom",
          },
          ...await uiSize(args, 0.5, "vertical"),
        },
      },
      sources: [
        {
          name: "git_status",
        },
      ],
    });

    args.contextBuilder.patchLocal("git_diff-ff", {
      ui: "ff",
      uiParams: {
        ff: {
          ...await uiSize(args, 1, "vertical"),
        },
      },
      sources: [
        {
          name: "git_diff",
          params: {
            onlyFile: true,
          },
        },
      ],
    });

    // UI: filer

    args.contextBuilder.patchLocal("current-filer", {
      ui: "filer",
      sources: [
        { name: "file" },
      ],
    });

    args.contextBuilder.patchLocal("home-filer", {
      ui: "filer",
      sources: [
        {
          name: "file",
          options: {
            path: Deno.env.get("HOME"),
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("dotfiles-filer", {
      ui: "filer",
      sources: [
        {
          name: "file",
          options: {
            path: expandHome("~/dotfiles"),
          },
        },
      ],
    });

    return Promise.resolve();
  }
}
