import { BaseConfig, ConfigArguments } from "./deps.ts";
import { expandHome } from "../ddu/helper.ts";

export class Config extends BaseConfig {
  override config({ contextBuilder }: ConfigArguments): Promise<void> {
    contextBuilder.patchGlobal({
      nvimServer: expandHome("~/.cache/nvim/server.pipe"),
      uiParams: {
        shell: {
          prompt: "%",
          promptPattern: "\w*% \?",
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
