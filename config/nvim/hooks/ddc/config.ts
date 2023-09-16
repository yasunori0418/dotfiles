import {
  BaseConfig,
  type ConfigArguments,
  // fn,
} from "./helper/deps.ts";

export class Config extends BaseConfig {
  override /* async */ config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      ui: "pum",
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
    });

    return Promise.resolve();
  }
}
