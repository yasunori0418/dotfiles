import {
  ConfigArguments,
  LazyExt,
  LazyMakeStateResult,
  LazyParams,
  Plugin,
} from "../deps.ts";
import { Ext, ExtArgs, getExt, omitProperties } from "../helper.ts";

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
  if (!lazyExtArgs.ext) throw "Failed load lazy extension.";
  return await lazyExtArgs.ext.actions.makeState.callback({
    ...omitProperties(lazyExtArgs, "ext"),
    actionParams: {
      plugins,
    },
  });
};
