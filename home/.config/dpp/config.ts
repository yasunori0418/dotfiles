import { BaseConfig, ConfigArguments, ConfigReturn, join } from "./deps.ts";
import {
  assertExtraArgs,
  gatherCheckFiles,
  generateExtArgs,
} from "./helper.ts";
import { gatherVimrcs } from "./helper/inlineVimrcs.ts";
import { gatherTomls, getTomlExt } from "./helper/toml.ts";
import { getLazyExt, makeState } from "./helper/lazy.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const { contextBuilder, basePath, extraArgs } = args;

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

    const getExtArgsFunc = await generateExtArgs(args);

    const { plugins, hooksFiles, ftplugins, multipleHooks } = await gatherTomls(
      {
        tomlExtArgs: (await getExtArgsFunc(getTomlExt)),
        path: directories.toml,
        noLazyTomlNames,
      },
    );

    const lazyResult = await makeState({
      lazyExtArgs: (await getExtArgsFunc(getLazyExt)),
      plugins,
    });

    return {
      checkFiles: gatherCheckFiles(directories.base, checkFilesGlobs),
      hooksFiles,
      ftplugins,
      multipleHooks,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
