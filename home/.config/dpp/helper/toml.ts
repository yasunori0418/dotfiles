import {
  ConfigArguments,
  mergeFtplugins,
  MultipleHook,
  Plugin,
  TomlExt,
  TomlParams,
} from "../deps.ts";
import { Ext, ExtArgs, getExt, omitProperties } from "../helper.ts";

type GetTomlExtResults = Ext<TomlParams, TomlExt>;

export const getTomlExt = async (
  args: ConfigArguments,
): Promise<GetTomlExtResults> =>
  (await getExt<TomlParams, TomlExt>(args, "toml")) as GetTomlExtResults;

export type GatherTomlsArgs = {
  path: string;
  noLazyTomlNames: string[];
  tomlExtArgs: ExtArgs<TomlParams, TomlExt>;
};

export type GatherTomlsResults = {
  plugins: Plugin[];
  ftplugins: Record<string, string>;
  hooksFiles: string[];
  multipleHooks: MultipleHook[];
};

type GatherTomlFilesResult = {
  path: string;
  lazy: boolean;
};

const gatherTomlFiles = (
  path: string,
  noLazyTomlNames: string[],
): GatherTomlFilesResult[] =>
  Array.from(Deno.readDirSync(path))
    .map((tomlFile: Deno.DirEntry) => {
    return {
      path: `${path}/${tomlFile.name}`,
      lazy: !noLazyTomlNames.includes(tomlFile.name),
    } as GatherTomlFilesResult;
  });

export const gatherTomls = async ({
  tomlExtArgs,
  path,
  noLazyTomlNames,
}: GatherTomlsArgs): Promise<GatherTomlsResults> => {
  if (!tomlExtArgs.ext) throw "Failed load toml extension.";
  const action = tomlExtArgs.ext.actions.load;
  const actionCallbackArgs = omitProperties(tomlExtArgs, "ext");
  const tomlPromises = gatherTomlFiles(path, noLazyTomlNames).map((tomlFile) =>
    action.callback({
      ...actionCallbackArgs,
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
};
