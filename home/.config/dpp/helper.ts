import {
  BaseExt,
  BaseParams,
  ConfigArguments,
  Context,
  Denops,
  DppOptions,
  ensure,
  expandGlobSync,
  ExtOptions,
  is,
  Protocol,
  WalkEntry,
} from "./deps.ts";

import { VimrcSkipRule } from "./helper/inlineVimrcs.ts";

export type Ext<P extends BaseParams, E extends BaseExt<P>> = [
  ext: E | undefined,
  options: ExtOptions,
  params: P,
];

export type ValidExt = "toml" | "lazy";

export const getExt = async <P extends BaseParams, E extends BaseExt<P>>(
  { denops }: ConfigArguments,
  extName: ValidExt,
): Promise<Ext<P, E>> => (await denops.dispatcher.getExt(extName)) as Ext<P, E>;

type GetExtFunc<P extends BaseParams, E extends BaseExt<P>> = (
  args: ConfigArguments,
) => Promise<Ext<P, E>>;

export type ProtocolRecord = Record<string, Protocol>;

export type ExtArgs<P extends BaseParams, E extends BaseExt<P>> = {
  denops: Denops;
  context: Context;
  options: DppOptions;
  protocols: ProtocolRecord;
  ext: E | undefined;
  extOptions: ExtOptions;
  extParams: P;
};

export const generateExtArgs = async (
  args: ConfigArguments,
): Promise<
  <P extends BaseParams, E extends BaseExt<P>>(
    getExtFunc: GetExtFunc<P, E>,
  ) => Promise<ExtArgs<P, E>>
> => {
  const { denops, contextBuilder } = args;
  const [context, options] = await contextBuilder.get(denops);
  const protocols = (await denops.dispatcher.getProtocols()) as ProtocolRecord;
  return async <P extends BaseParams, E extends BaseExt<P>>(
    getExtFunc: GetExtFunc<P, E>,
  ): Promise<ExtArgs<P, E>> => {
    const [ext, extOptions, extParams] = await getExtFunc(args);
    return {
      denops,
      context,
      options,
      protocols,
      ext,
      extOptions,
      extParams,
    };
  };
};

export const gatherCheckFiles = (path: string, globs: string[]): string[] =>
  globs.flatMap((glob) =>
    Array.from(
      expandGlobSync(glob, {
        root: path,
      }),
    ).map(({ path }: WalkEntry) => path)
  );

type Directories = {
  base: string;
  rc: string;
  toml: string;
};

type ExtraArgs = {
  vimrcSkipRules: VimrcSkipRule[];
  directories: Directories;
  noLazyTomlNames: string[];
  checkFilesGlobs: string[];
};

export const assertExtraArgs = (
  extraArgs: Record<string, unknown>,
): ExtraArgs =>
  ensure(
    extraArgs,
    is.ObjectOf({
      vimrcSkipRules: is.ArrayOf(
        is.ObjectOf({
          name: is.String,
          condition: is.Boolean,
        }),
      ),
      directories: is.ObjectOf({
        base: is.String,
        rc: is.String,
        toml: is.String,
      }),
      noLazyTomlNames: is.ArrayOf(is.String),
      checkFilesGlobs: is.ArrayOf(is.String),
    }),
  );
