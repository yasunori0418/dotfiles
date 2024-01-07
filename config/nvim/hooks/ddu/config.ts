import {
  ActionArguments,
  ActionData,
  ActionFlags,
  BaseConfig,
  ConfigArguments,
  expandHome,
  fn,
  GitCommitActionData,
  Notification,
  NvimNotifyActionData,
  separator,
  uiSize,
  vars,
} from "./deps.ts";

type Params = Record<string, unknown>;

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const denops = args.denops;
    args.setAlias("source", "file_fd", "file_external");
    args.setAlias("source", "file_rg", "file_external");

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
        file_fd: {
          ignoreCase: true,
          converters: [
            "converter_devicon",
            "converter_hl_dir",
          ],
        },
        file_rg: {
          ignoreCase: true,
          converters: [
            "converter_devicon",
            "converter_hl_dir",
          ],
        },
        dpp: {
          defaultAction: "cdOpen",
        },
        help: {
          defaultAction: "open",
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
            "converter_relativepath",
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
        lsp_documentSymbol: {
          converters: [
            "converter_lsp_symbol",
          ],
        },
        lsp_workspaceSymbol: {
          converters: [
            "converter_lsp_symbol",
          ],
        },
        lsp_codeAction: {
          defaultAction: "apply",
        },
        lsp_diagnostic: {
          defaultAction: "open",
        },
      },
      sourceParams: {
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
        file_fd: {
          cmd: [
            "fd",
            ".",
            "--hidden",
            "--exclude",
            ".git",
            "--type",
            "f",
            "--color",
            "never",
          ],
        },
        file_rg: {
          cmd: [
            "rg",
            "--files",
            "--hidden",
            "--glob",
            "!.git",
            "--color",
            "never",
          ],
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

              await denops.call("ddu#ui#do_action", "itemAction", {
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
              await denops.call("chdir", action.path);
              await denops.cmd("edit .");

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
        git_status: {
          defaultAction: "open",
          actions: {
            gitDiff: async (
              args: ActionArguments<Params>,
            ): Promise<ActionFlags> => {
              const action = args.items[0].action as ActionData;

              await denops.call("ddu#start", {
                name: "git:diff",
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

              await denops.call("ddu#start", {
                name: "git:diff_tree",
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
        "nvim-notify": {
          defaultAction: "yank",
          actions: {
            yank: async (
              args: ActionArguments<Params>,
            ): Promise<ActionFlags> => {
              const action = args.items[0].action as NvimNotifyActionData;
              const notification = action.notification as Notification;
              const message = notification.message.join(" ");

              await fn.setreg(denops, '"', message, "v");
              await fn.setreg(
                denops,
                await vars.v.get(denops, "register"),
                message,
                "v",
              );

              return Promise.resolve(ActionFlags.Persist);
            },
          },
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
          name: "dpp",
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

    args.contextBuilder.patchLocal("git:status", {
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
            ignoreEmpty: true,
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

    args.contextBuilder.patchLocal("git:diff", {
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

    args.contextBuilder.patchLocal("git:diff_tree", {
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

    args.contextBuilder.patchLocal("git:log", {
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

    args.contextBuilder.patchLocal("git:branch", {
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

    const lsp_definition_methods: string[] = [
      "declaration",
      "definition",
      "typeDefinition",
      "implementation",
    ];
    lsp_definition_methods.forEach(async (method: string) => {
      args.contextBuilder.patchLocal(`lsp:${method}`, {
        ui: "ff",
        sync: true,
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
              immediateAction: "open",
              ignoreEmpty: true,
            },
            ...await uiSize(args, 0.5, "vertical"),
          },
        },
        sources: [
          {
            name: "lsp_definition",
            params: {
              method: `textDocument/${method}`,
            },
          },
        ],
      });
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
            ignoreEmpty: true,
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

    args.contextBuilder.patchLocal("lsp:definition_all", {
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
            ignoreEmpty: true,
          },
          ...await uiSize(args, 0.5, "vertical"),
        },
      },
      sources: [
        separator(">>Definition<<"),
        {
          name: "lsp_definition",
          params: {
            method: "textDocument/definition",
          },
        },
        separator(">>Declaration<<"),
        {
          name: "lsp_definition",
          params: {
            method: "textDocument/declaration",
          },
        },
        separator(">>Type Definition<<"),
        {
          name: "lsp_definition",
          params: {
            method: "textDocument/typeDefinition",
          },
        },
        separator(">>Implementation<<"),
        {
          name: "lsp_definition",
          params: {
            method: "textDocument/implementation",
          },
        },
      ],
    });

    args.contextBuilder.patchLocal("lsp:finder", {
      ui: "ff",
      sources: [
        separator(">>Definition<<"),
        {
          name: "lsp_definition",
          params: {
            method: "textDocument/definition",
          },
        },
        separator(">>References<<"),
        {
          name: "lsp_references",
          params: {
            includeDeclaration: false,
          },
        },
      ],
    });

    const lsp_symbol_scope = [
      "document",
      "workspace",
    ];
    lsp_symbol_scope.forEach(async (scope) => {
      args.contextBuilder.patchLocal(`lsp:${scope}Symbol`, {
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
              ignoreEmpty: true,
            },
            ...await uiSize(args, 0.5, "vertical"),
          },
        },
        sources: [
          {
            name: `lsp_${scope}Symbol`,
          },
        ],
      });
    });

    const lsp_hierarchy_methods = [
      "callHierarchy/incomingCalls",
      "callHierarchy/outgoingCalls",
      "typeHierarchy/supertypes",
      "typeHierarchy/ssupertypesubtypes",
    ];
    lsp_hierarchy_methods.forEach(async (method) => {
      args.contextBuilder.patchLocal(`lsp:${method.split("/")[1]}`, {
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
              ignoreEmpty: true,
              displayTree: true,
            },
            ...await uiSize(args, 0.5, "vertical"),
          },
        },
        sources: [
          {
            name: `lsp_${method.split("/")[0]}`,
            params: { method: method },
          },
        ],
      });
    });

    args.contextBuilder.patchLocal("lsp:codeAction", {
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
            ignoreEmpty: true,
          },
          ...await uiSize(args, 0.5, "vertical"),
        },
      },
      sources: [
        {
          name: "lsp_codeAction",
        },
      ],
    });

    args.contextBuilder.patchLocal("lsp:diagnostics", {
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
            ignoreEmpty: true,
          },
          ...await uiSize(args, 0.5, "vertical"),
        },
      },
      sources: [
        {
          name: "lsp_diagnostic",
        },
      ],
    });

    args.contextBuilder.patchLocal("notify", {
      ui: "ff",
      uiParams: {
        ff: {
          ignoreEmpty: true,
        },
      },
      sources: [
        {
          name: "nvim-notify",
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
