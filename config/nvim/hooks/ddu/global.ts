import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
} from "https://deno.land/x/ddu_vim@v3.2.7/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.2.7/base/config.ts";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v3.2.7/deps.ts";
// import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.5.2/file.ts";

// type Params = Record<string, unknown>;

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
    });
    return Promise.resolve();
  }
}
