import { BaseConfig, ConfigArguments } from "./deps.ts";
import { ddtUiSize } from "./helper.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const { contextBuilder } = args;

    contextBuilder.patchGlobal({
      nvimServer: "~/.cache/nvim/server.pipe",
      uiParams: {
        shell: {
          prompt: "%",
          promptPattern: "% ",
          // shellHistoryPath: expandHome("~/.cache/ddt-shell-history"),
        },
        terminal: {
          command: [Deno.env.get("SHELL")],
          promptPattern: "❯ ",
          split: "",
        },
      },
    });

    contextBuilder.patchLocal("terminal-floating", {
      ui: "terminal",
      uiParams: {
        terminal: {
          ...await ddtUiSize(args, "floating", 0.6),
        },
      },
    });

    return Promise.resolve();
  }
}
