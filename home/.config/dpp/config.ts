import { BaseConfig, ConfigArguments, ConfigReturn, join } from "./deps.ts";
import { assertExtraArgs, gatherCheckFiles, getProtocols } from "./helper.ts";
import { gatherVimrcs } from "./helper/inlineVimrcs.ts";
import { gatherTomls, getTomlExt } from "./helper/toml.ts";
import { getLazyExt, makeState } from "./helper/lazy.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const { denops, contextBuilder, basePath, extraArgs } = args;

    const { vimrcSkipRules, directories, noLazyTomlNames, checkFilesGlobs } =
      assertExtraArgs(extraArgs);

    contextBuilder.setGlobal({
      inlineVimrcs: gatherVimrcs(directories.rc, vimrcSkipRules),
      protocols: ["git"],
      protocolParams: {
        git: {
          enablePartialClone: true,
        },
      },
      extParams: {
        installer: {
          checkDiff: false,
          logFilePath: join(
            basePath,
            // installer_{YYYYMMDD}.log
            `installer_${
              new Date()
                .toLocaleDateString("ja-JP", {
                  year: "numeric",
                  month: "2-digit",
                  day: "2-digit",
                  hour: "2-digit",
                  minute: "2-digit",
                  second: "2-digit",
                })
                .replaceAll(new RegExp(/[\/ :]/, "g"), "")
            }.log`,
          ),
        },
      },
    });

    const [context, options] = await contextBuilder.get(denops);
    const protocols = await getProtocols(denops);

    const [tomlExt, tomlOptions, tomlParams] = await getTomlExt(args);

    const toml = await gatherTomls({
      denops,
      context,
      options,
      protocols,
      tomlExt,
      tomlOptions,
      tomlParams,
      path: directories.toml,
      noLazyTomlNames,
    });

    const [lazyExt, lazyOptions, lazyParams] = await getLazyExt(args);
    const lazyResult = await makeState({
      denops,
      context,
      options,
      protocols,
      lazyExt,
      lazyOptions,
      lazyParams,
      plugins: toml.plugins,
    });

    return {
      checkFiles: gatherCheckFiles(directories.base, checkFilesGlobs),
      hooksFiles: toml.hooksFiles,
      ftplugins: toml.ftplugins,
      multipleHooks: toml.multipleHooks,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
