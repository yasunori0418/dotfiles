import {
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

export type GetLazyExtResults = [
  LazyExt | undefined,
  ExtOptions,
  LazyParams,
];

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
