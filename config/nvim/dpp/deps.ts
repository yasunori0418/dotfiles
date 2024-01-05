export { BaseConfig } from "https://deno.land/x/dpp_vim@v0.0.9/types.ts";
export type {
  ConfigReturn,
  Context,
  ContextBuilder,
  Dpp,
  DppOptions,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.9/types.ts";

export type { Denops } from "https://deno.land/x/dpp_vim@v0.0.9/deps.ts";
export { fn, vars } from "https://deno.land/x/dpp_vim@v0.0.9/deps.ts";

export type {
  ConfigArguments,
  LazyMakeStateResult,
  Toml,
  VimrcSkipRule,
} from "./helper.ts";
export { gatherTomls, gatherVimrcs } from "./helper.ts";
