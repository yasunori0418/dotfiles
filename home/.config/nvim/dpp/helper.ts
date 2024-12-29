import {
  BaseExt,
  BaseParams,
  ConfigArguments,
  expandGlobSync,
  ExtOptions,
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
