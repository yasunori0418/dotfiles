import { ContextBuilder, Denops, Dpp, fn, Plugin } from "./deps.ts";

export type Toml = {
  hooks_file?: string;
  ftplugins?: Record<string, string>;
  plugins?: Plugin[];
};

export type ConfigArguments = {
  denops: Denops;
  contextBuilder: ContextBuilder;
  basePath: string;
  dpp: Dpp;
};

export type LazyMakeStateResult = {
  plugins: Plugin[];
  stateLines: string[];
};

export type VimrcSkipRule = {
  name: string; // file name
  condition: boolean; // skip target by condition
};

export function gatherVimrcs(
  path: string,
  vimrcSkipRules: VimrcSkipRule[],
): string[] {
  const inlineVimrcs: string[] = [];
  if (path === null) throw `failure read directory in ${path}`;
  for (const dirEntry of Deno.readDirSync(path)) {
    if (typeof dirEntry == "undefined") continue;

    const vimrcSkipRule = vimrcSkipRules.find((skipRule) => {
      return dirEntry.name == skipRule.name;
    }) as VimrcSkipRule | undefined;

    if (vimrcSkipRule?.condition) continue;

    inlineVimrcs.push(`${path}/${dirEntry.name}`);
  }
  return inlineVimrcs;
}

export async function gatherTomls(
  path: string,
  noLazyTomlNames: string[],
  args: ConfigArguments,
): Promise<Toml[]> {
  const tomls: Toml[] = [];
  const [context, options] = await args.contextBuilder.get(args.denops);

  for (const tomlFile of Deno.readDirSync(path)) {
    if (typeof tomlFile.name === "undefined") continue;
    const isLazy = !noLazyTomlNames.includes(tomlFile.name);
    tomls.push(
      await args.dpp.extAction(
        args.denops,
        context,
        options,
        "toml",
        "load",
        {
          path: `${path}/${tomlFile.name}`,
          options: {
            lazy: isLazy,
          },
        },
      ) as Toml,
    );
  }
  return tomls;
}

export async function gatherCheckFiles(
  denops: Denops,
  path: string,
  globs: string[],
): Promise<string[]> {
  const checkFiles: string[] = [];
  for (const glob of globs) {
    checkFiles.push(await fn.globpath(denops, path, glob, true, true));
  }

  return checkFiles.flat();
}