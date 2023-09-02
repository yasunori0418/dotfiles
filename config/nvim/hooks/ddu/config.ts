import {
  ActionArguments,
  ActionData,
  ActionFlags,
  BaseConfig,
  ConfigArguments,
  expandHome,
  GitCommitActionData,
  uiSize,
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
          defaultAction: "cdOpen",
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
        git_branch: {
          columns: [
            "git_branch_head",
            "git_branch_remote",
            "git_branch_name",
            "git_branch_upstream",
            "git_branch_author",
            "git_branch_date",
          ],
        },
        ghq: {
          defaultAction: "cdOpen",
        },
        lsp_definition: {
          converters: [
            "converter_devicon",
            "converter_hl_dir",
          ],
        },
        lsp_references: {
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
            word: "Search",
          },
        },
        git_branch: {
          remote: false,
        },
        ghq: {
          display: "relative",
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
                name: "git_diff",
                sourceOptions: {
                  git_diff: {
                    path: action.path,
                  },
                },
              });

              return Promise.resolve(ActionFlags.None);
            },
          },
        },
        git_commit: {
          defaultAction: "yank",
          actions: {
            diffTree: async (
              args: ActionArguments<Params>,
            ): Promise<ActionFlags> => {
              const action = args.items[0].action as GitCommitActionData;

              await args.denops.call("ddu#start", {
                name: "git_diff_tree-ff",
                sourceParams: {
                  git_diff_tree: {
                    commitHash: action.hash,
                  },
                },
              });

              return Promise.resolve(ActionFlags.None);
            },
          },
        },
        git_branch: {
          defaultAction: "switch",
        },
        lsp: {
          defaultAction: "open",
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

    args.contextBuilder.patchLocal("current", {
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

    args.contextBuilder.patchLocal("dotfiles", {
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

    args.contextBuilder.patchLocal("help", {
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

    args.contextBuilder.patchLocal("search_line", {
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

    args.contextBuilder.patchLocal("buffer", {
      ui: "ff",
      sources: [
        { name: "buffer" },
      ],
    });

    args.contextBuilder.patchLocal("plugin-list", {
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

    args.contextBuilder.patchLocal("home", {
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

    args.contextBuilder.patchLocal("register", {
      ui: "ff",
      sources: [
        {
          name: "register",
        },
      ],
    });

    args.contextBuilder.patchLocal("mrr", {
      ui: "ff",
      sources: [
        {
          name: "mr",
          options: {
            defaultAction: "cdOpen",
          },
          params: {
            kind: "mrr",
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("mru", {
      ui: "ff",
      sources: [
        {
          name: "mr",
          options: {
            matchers: ["matcher_relative"],
          },
          params: {
            kind: "mru",
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("highlight", {
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

    args.contextBuilder.patchLocal("dein_update", {
      ui: "ff",
      sources: [
        {
          name: "dein_update",
        },
      ],
    });

    args.contextBuilder.patchLocal("ripgrep", {
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
        },
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

    args.contextBuilder.patchLocal("path_history", {
      ui: "ff",
      sources: [
        { name: "path_history" },
      ],
    });

    args.contextBuilder.patchLocal("git_status", {
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

    args.contextBuilder.patchLocal("git_diff", {
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

    args.contextBuilder.patchLocal("git_diff_tree", {
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
          name: "git_diff_tree",
        },
      ],
    });

    args.contextBuilder.patchLocal("git_log", {
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
          name: "git_log",
          params: {
            commitOrdering: "topo",
            showGraph: true,
            showAll: true,
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("git_branch", {
      ui: "ff",
      uiParams: {
        ff: {
          ...await uiSize(args, 1, "vertical"),
        },
      },
      sources: [
        {
          name: "git_branch",
        },
      ],
    });

    args.contextBuilder.patchLocal("ghq", {
      ui: "ff",
      uiParams: {
        ff: {
          startFilter: true,
        },
      },
      sources: [
        {
          name: "ghq",
        },
      ],
    });

    args.contextBuilder.patchLocal("lsp:definition", {
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
          name: "lsp_definition",
        },
      ],
    });

    args.contextBuilder.patchLocal("lsp:references", {
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
          name: "lsp_references",
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
