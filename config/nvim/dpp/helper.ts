import {
  ConfigArguments,
  Context,
  Denops,
  DppOptions,
  expandGlobSync,
  ExtOptions,
  mergeFtplugins,
  MultipleHook,
  Plugin,
  Protocol,
  TomlExt,
  TomlParams,
} from "./deps.ts";

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

export type GetTomlExtResults = [
  TomlExt | undefined,
  ExtOptions,
  TomlParams,
];

export async function getTomlExt(
  args: ConfigArguments,
  options: DppOptions,
): Promise<GetTomlExtResults> {
  return await args.dpp.getExt(
    args.denops,
    options,
    "toml",
  ) as GetTomlExtResults;
}

export interface GatherTomlsArgs {
  path: string;
  noLazyTomlNames: string[];
  denops: Denops;
  context: Context;
  options: DppOptions;
  protocols: Record<string, Protocol>;
  tomlExt: TomlExt | undefined;
  tomlOptions: ExtOptions;
  tomlParams: TomlParams;
}

export interface GatherTomlsResults {
  recordPlugins: Record<string, Plugin>;
  ftplugins: Record<string, string>;
  hooksFiles: string[];
  multipleHooks: MultipleHook[];
}

interface GatherTomlFilesResult {
  path: string;
  lazy: boolean;
}

function gatherTomlFiles(
  path: string,
  noLazyTomlNames: string[],
): GatherTomlFilesResult[] {
  const results: GatherTomlFilesResult[] = [];
  for (const tomlFile of Deno.readDirSync(path)) {
    if (typeof tomlFile.name === "undefined") continue;
    const isLazy = !noLazyTomlNames.includes(tomlFile.name);
    results.push({
      path: `${path}/${tomlFile.name}`,
      lazy: isLazy,
    });
  }
  return results;
}

export async function gatherTomls(
  args: GatherTomlsArgs,
): Promise<GatherTomlsResults> {
  if (!args.tomlExt) throw "Failed load toml extension.";
  const {
    denops,
    context,
    options,
    protocols,
    tomlExt,
    tomlOptions,
    tomlParams,
    path,
    noLazyTomlNames,
  } = args;
  const action = tomlExt.actions.load;
  const tomlPromises = gatherTomlFiles(
    path,
    noLazyTomlNames,
  ).map((tomlFile) =>
    action.callback({
      denops,
      context,
      options,
      protocols,
      extOptions: tomlOptions,
      extParams: tomlParams,
      actionParams: {
        path: tomlFile.path,
        options: {
          lazy: tomlFile.lazy,
        },
      },
    })
  );
  const tomls = await Promise.all(tomlPromises);
  const results: GatherTomlsResults = {
    recordPlugins: {},
    ftplugins: {},
    hooksFiles: [],
    multipleHooks: [],
  };
  for (const toml of tomls) {
    for (const plugin of toml.plugins ?? []) {
      results.recordPlugins[plugin.name] = plugin;
    }
    if (toml.ftplugins) {
      mergeFtplugins(results.ftplugins, toml.ftplugins);
    }
    if (toml.multiple_hooks) {
      results.multipleHooks = results.multipleHooks.concat(toml.multiple_hooks);
    }
    if (toml.hooks_file) {
      results.hooksFiles.push(toml.hooks_file);
    }
  }
  return results;
}

export async function gatherGhqPlugins(
  args: ConfigArguments,
): Promise<Plugin[]> {
  const [context, options] = await args.contextBuilder.get(args.denops);
  return await args.dpp.extAction(
    args.denops,
    context,
    options,
    "ghq",
    "ghq",
    {
      ghq_root: "~/src",
      repos: ["yasunori0418/ddu-gh_project"],
      hostname: "github.com",
      options: {
        lazy: true,
        merged: false,
        on_source: "ddu.vim",
        hook_add:
          "let g:ddu_gh_project_gh_cmd = '/home/yasunori/src/github.com/yasunori0418/cli/bin/gh'",
      },
    },
  ) as Plugin[];
}

export function gatherCheckFiles(path: string, glob: string): string[] {
  const checkFiles: string[] = [];
  for (
    const file of expandGlobSync(glob, {
      root: path,
      globstar: true,
    })
  ) {
    checkFiles.push(file.path);
  }
  return checkFiles;
}
