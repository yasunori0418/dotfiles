import { BaseConfig, ConfigArguments } from "./deps.ts";

export class Config extends BaseConfig {
  override config({ contextBuilder }: ConfigArguments): Promise<void> {
    contextBuilder.patchGlobal({
      nvimServer: "~/.cache/nvim/server.pipe",
      uiParams: {
        shell: {
          prompt: "%",
          promptPattern: "% ",
          // shellHistoryPath: expandHome("~/.cache/ddt-shell-history"),
        },
        terminal: {
          command: [Deno.env.get('SHELL')]
        },
      },
    });
    return Promise.resolve();
  }
}
