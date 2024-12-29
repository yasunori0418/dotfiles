import {
  ConfigArguments,
  Context,
  Denops,
  DppOptions,
  ExtOptions,
  LazyExt,
  LazyMakeStateResult,
  LazyParams,
  Plugin,
  Protocol,
} from "../deps.ts";
import { Ext, getExt } from "../helper.ts";

export type GetLazyExtResults = Ext<LazyParams, LazyExt>;

export async function getLazyExt(args: ConfigArguments) {
  return await getExt<LazyParams, LazyExt>(args, "lazy");
}

export interface makeStateArgs {
  denops: Denops;
  context: Context;
  options: DppOptions;
  protocols: Record<string, Protocol>;
  lazyExt: LazyExt | undefined;
  lazyOptions: ExtOptions;
  lazyParams: LazyParams;
  plugins: Plugin[];
}

export async function makeState(
  args: makeStateArgs,
): Promise<LazyMakeStateResult | undefined> {
  if (!args.lazyExt) throw "Failed load lazy extension.";
  const {
    denops,
    context,
    options,
    protocols,
    lazyExt,
    lazyOptions,
    lazyParams,
    plugins,
  } = args;
  const action = lazyExt.actions.makeState;
  return await action.callback({
    denops,
    context,
    options,
    protocols,
    extOptions: lazyOptions,
    extParams: lazyParams,
    actionParams: {
      plugins,
    },
  });
}
