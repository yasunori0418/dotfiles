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

export const getLazyExt = async (
  args: ConfigArguments,
): Promise<GetLazyExtResults> =>
  (await getExt<LazyParams, LazyExt>(args, "lazy")) as GetLazyExtResults;

export type makeStateArgs = {
  denops: Denops;
  context: Context;
  options: DppOptions;
  protocols: Record<string, Protocol>;
  lazyExt: LazyExt | undefined;
  lazyOptions: ExtOptions;
  lazyParams: LazyParams;
  plugins: Plugin[];
};

export const makeState = async ({
  denops,
  context,
  options,
  protocols,
  lazyExt,
  lazyOptions,
  lazyParams,
  plugins,
}: makeStateArgs): Promise<LazyMakeStateResult | undefined> => {
  if (!lazyExt) throw "Failed load lazy extension.";
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
};
