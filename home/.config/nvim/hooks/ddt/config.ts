import { BaseConfig, ConfigArguments } from "./deps.ts";
import { expandHome } from "../ddu/helper.ts";

export class Config extends BaseConfig {
  override config({ contextBuilder }: ConfigArguments): Promise<void> {
    contextBuilder.patchGlobal({
      nvimServer: expandHome("~/.cache/nvim/server.pipe"),
      ui: "shell",
      uiParams: {
        shell: {
          prompt: "%",
          promptPattern: "\w*% \?",
          // shellHistoryPath: expandHome("~/.cache/ddt-shell-history"),
        },
      },
    });
    return Promise.resolve();
  }
}
