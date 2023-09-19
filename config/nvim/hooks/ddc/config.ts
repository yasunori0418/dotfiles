import {
  BaseConfig,
  type ConfigArguments,
  type UserSource,
} from "./helper/deps.ts";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    const main_sources: UserSource[] = ["vsnip", "around", "file", "rg"];
    const denops = args.denops;

    args.contextBuilder.patchGlobal({
      ui: "pum",
      sources: main_sources,
      autoCompleteEvents: [
        "CmdlineChanged",
        "CmdlineEnter",
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "TextChangedT",
      ],
      cmdlineSources: {
        ":": ["cmdline", "cmdline-history", "around"],
        "@": ["cmdline-history", "input", "file", "around"],
        ">": ["cmdline-history", "input", "file", "around"],
        "/": ["around", "line"],
        "?": ["around", "line"],
        "-": ["around", "line"],
        "=": ["input"],
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_fuzzy"],
          sorters: ["sorter_fuzzy"],
          converters: ["converter_fuzzy"],
        },
        around: { mark: "A" },
        buffer: { mark: "B" },
        line: { mark: "line" },
        rg: {
          mark: "rg",
          minAutoCompleteLength: 5,
          enabledIf: "finddir('.git', ';') != ''",
        },
        necovim: { mark: "vim" },
        vsnip: {
          mark: "snip",
          dup: "keep",
        },
        "nvim-lsp": {
          mark: "LSP",
          forceCompletionPattern: "\\k+",
          dup: "force",
          sorters: ["sorter_lsp-kind", "converter_kind_labels"],
        },
        "nvim-lua": {
          mark: "lua",
          forceCompletionPattern: "\\.\\w*",
        },
        skkeleton: {
          mark: "SKK",
          matchers: ["skkeleton"],
          sorters: ["sorter_rank"],
          minAutoCompleteLength: 2,
          isVolatile: true,
        },

        cmdline: {
          mark: "cmd",
          forceCompletionPattern: "\\S/\\S*|\\.\\w*",
          dup: "force",
        },
        "cmdline-history": {
          mark: "cmd-history",
          sorters: [],
        },
        input: {
          mark: "input",
          forceCompletionPattern: "\\S/\\S*",
          isVolatile: true,
          dup: "force",
        },
        "shell-native": {
          mark: "sh",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
        },
        "shell-history": {
          mark: "sh-history",
        },
      },
      sourceParams: {
        buffer: {
          requireSameFiletype: false,
          fromAltBuf: true,
          bufNameStyle: "basename",
        },
        line: { maxSize: 500 },
        "shell-native": {
          shell: "zsh",
        },
        "nvim-lsp": {
          enableResolveItem: true,
          enableAdditionalTextEdit: true,
          confirmBehavior: "replace",
          snippetEngine: async (body: string) => {
            await denops.call("vsnip#anonymous", body);
          },
        },
      },
      filterParams: {
        converter_kind_labels: {
          kindLabels: {
            Text: "Text ",
            Method: "Method ",
            Function: "Function ",
            Constructor: "Constructor ",
            Field: "Field ",
            Variable: "Variable ",
            Class: "Class ",
            Interface: "Interface ",
            Module: "Module ",
            Property: "Property ",
            Unit: "Unit ",
            Value: "Value ",
            Enum: "Enum ",
            Keyword: "Keyword ",
            Snippet: "Snippet ",
            Color: "Color ",
            File: "File ",
            Reference: "Reference ",
            Folder: "Folder ",
            EnumMember: "EnumMember ",
            Constant: "Constant ",
            Struct: "Struct ",
            Event: "Event ",
            Operator: "Operator ",
            TypeParameter: "TypeParameter ",
          },
          kindHlGroups: {
            Text: "String",
            Method: "Function",
            Function: "Function",
            Constructor: "Function",
            Field: "Identifier",
            Variable: "Identifier",
            Class: "Structure",
            Interface: "Structure",
            Module: "Function",
            Property: "Identifier",
            Unit: "Identifier",
            Value: "String",
            Enum: "Structure",
            Keyword: "Identifier",
            Snippet: "Structure",
            Color: "Structure",
            File: "Structure",
            Reference: "Function",
            Folder: "Structure",
            EnumMember: "Structure",
            Constant: "String",
            Struct: "Structure",
            Event: "Function",
            Operator: "Identifier",
            TypeParameter: "Identifier",
          },
        },
      },
    });

    // lsp
    for (
      const filetype of [
        "python",
        "php",
        "typescript",
      ]
    ) {
      args.contextBuilder.patchFiletype(filetype, {
        sources: ["nvim-lsp", ...main_sources],
      });
    }

    args.contextBuilder.patchFiletype("lua", {
      sources: ["nvim-lua", "nvim-lsp", ...main_sources],
    });

    args.contextBuilder.patchFiletype("vim", {
      sources: ["necovim", ...main_sources],
    });

    args.contextBuilder.patchFiletype("deol", {
      specialBufferCompletion: true,
      sources: ["shell-native", "shell-history", "around"],
      sourceOptions: {
        _: {
          keywordPattern: "[0-9a-zA-Z_./#:-]*",
          minAutoCompleteLength: 1,
        },
      },
    });

    args.contextBuilder.patchFiletype("ddu-ff-filter", {
      specialBufferCompletion: true,
      sources: ["line", "buffer"],
      sourceOptions: {
        _: {
          keywordPattern: "[0-9a-zA-Z_:#-]*",
        },
      },
    });

    return Promise.resolve();
  }
}
