import {
  ConfigArguments,
  LazyExt,
  LazyMakeStateResult,
  LazyParams,
  Plugin,
} from "../deps.ts";
import { Ext, ExtArgs, getExt } from "../helper.ts";

export type GetLazyExtResults = Ext<LazyParams, LazyExt>;

export const getLazyExt = async (
  args: ConfigArguments,
): Promise<GetLazyExtResults> =>
  (await getExt<LazyParams, LazyExt>(args, "lazy")) as GetLazyExtResults;

export type makeStateArgs = {
  lazyExtArgs: ExtArgs<LazyParams, LazyExt>;
  plugins: Plugin[];
};

export const makeState = async ({
  lazyExtArgs,
  plugins,
}: makeStateArgs): Promise<LazyMakeStateResult | undefined> => {
  const {
    denops,
    context,
    options,
    protocols,
    ext: lazyExt,
    extOptions: lazyOptions,
    extParams: lazyParams,
  } = lazyExtArgs;
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
