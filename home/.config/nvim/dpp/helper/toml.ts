import {
  ConfigArguments,
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
import { Ext, getExt } from "../helper.ts";

type GetTomlExtResults = Ext<TomlParams, TomlExt>;

export async function getTomlExt(
  args: ConfigArguments,
): Promise<GetTomlExtResults> {
  return (await getExt<TomlParams, TomlExt>(args, "toml")) as GetTomlExtResults;
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
  plugins: Plugin[];
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
  return Array.from(Deno.readDirSync(path))
    .filter((tomlFile: Deno.DirEntry) => typeof tomlFile.name !== "undefined")
    .map((tomlFile: Deno.DirEntry) => {
      return {
        path: `${path}/${tomlFile.name}`,
        lazy: !noLazyTomlNames.includes(tomlFile.name),
      } as GatherTomlFilesResult;
    });
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
  const tomlPromises = gatherTomlFiles(path, noLazyTomlNames).map((tomlFile) =>
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
    }),
  );
  const tomls = await Promise.all(tomlPromises);
  const results: GatherTomlsResults = {
    plugins: [],
    ftplugins: {},
    hooksFiles: [],
    multipleHooks: [],
  };
  tomls.forEach((toml) => {
    results.plugins.push(...(toml.plugins ?? []));
    mergeFtplugins(results.ftplugins, toml.ftplugins ?? {});
    results.multipleHooks.push(...(toml.multiple_hooks ?? []));
    if (toml.hooks_file) {
      results.hooksFiles.push(toml.hooks_file);
    }
  });
  return results;
}
