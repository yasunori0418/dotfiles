import {
  BaseConfig,
  type ConfigArguments,
  type UserSource,
  // fn,
} from "./helper/deps.ts";

export class Config extends BaseConfig {
  override /* async */ config(args: ConfigArguments): Promise<void> {
    const main_sources: UserSource[] = ["vsnip", "around", "file", "rg"];

    args.contextBuilder.patchGlobal({
      ui: "pum",
      sources: main_sources,
      specialBufferCompletion: true,
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
          forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
          dup: "force",
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
      },
    });
    return Promise.resolve();
  }
}
