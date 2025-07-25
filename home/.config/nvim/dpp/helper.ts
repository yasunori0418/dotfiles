import {
  BaseExt,
  BaseParams,
  ConfigArguments,
  ensure,
  expandGlobSync,
  ExtOptions,
  is,
  WalkEntry,
} from "./deps.ts";

export type Ext<P extends BaseParams, E extends BaseExt<P>> = [
  ext: E | undefined,
  options: ExtOptions,
  params: P,
];

export type ValidExt = "toml" | "lazy";

export async function getExt<P extends BaseParams, E extends BaseExt<P>>(
  { denops }: ConfigArguments,
  extName: ValidExt,
): Promise<Ext<P, E>> {
  return (await denops.dispatcher.getExt(extName)) as Ext<P, E>;
}

export function gatherCheckFiles(path: string, glob: string): string[] {
  return Array.from(
    expandGlobSync(glob, {
      root: path,
      globstar: true,
    }),
  ).map(({ path }: WalkEntry) => path);
}

type Directories = {
  base: string;
  rc: string;
  toml: string;
};

type ExtraArgs = {
  neovide: boolean;
  directories: Directories;
};

export const assertExtraArgs = (
  extraArgs: Record<string, unknown>,
): ExtraArgs =>
  ensure(
    extraArgs,
    is.ObjectOf({
      neovide: is.Boolean,
      directories: is.ObjectOf({
        base: is.String,
        rc: is.String,
        toml: is.String,
      }),
    }),
  );
