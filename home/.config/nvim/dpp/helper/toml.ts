import {
  Context,
  Denops,
  DppOptions,
  ExtOptions,
  mergeFtplugins,
  MultipleHook,
  Plugin,
  Protocol,
  TomlExt,
  TomlParams,
} from "../deps.ts";

export type GetTomlExtResults = [
  TomlExt | undefined,
  ExtOptions,
  TomlParams,
];

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
