import { BaseConfig, ConfigArguments } from "./deps.ts";
import { ddtUiSize } from "./helper.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const { contextBuilder } = args;

    const defaultFloatingTerminalUiSize = await ddtUiSize(
      args,
      "floating",
      0.6,
    );

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
          ...defaultFloatingTerminalUiSize,
        },
      },
    });

    contextBuilder.patchLocal("claude", {
      uiParams: {
        terminal: {
          command: ["claude"],
          promptPattern: "│ > ",
          ...(await ddtUiSize(args, "horizontal", 0.5)),
        },
      },
    });

    return Promise.resolve();
  }
}
