import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn,
  Denops,
  join,
  Protocol,
  vars,
} from "./deps.ts";
import { gatherCheckFiles, getExt } from "./helper.ts";
import { gatherVimrcs, VimrcSkipRule } from "./helper/inlineVimrcs.ts";
import { gatherTomls, GetTomlExtResults } from "./helper/toml.ts";
import { GetLazyExtResults, makeState } from "./helper/lazy.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const denops: Denops = args.denops;

    const vimrcSkipRules: VimrcSkipRule[] = [];

    const inlineVimrcs: string[] = gatherVimrcs(
      await vars.g.get(denops, "rc_dir"),
      vimrcSkipRules,
    );

    args.contextBuilder.setGlobal({
      inlineVimrcs: inlineVimrcs,
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
            await vars.g.get(denops, "dpp_cache"),
            // installer_{YYYYMMDD}.log
            `installer_${
              new Date().toLocaleDateString("ja-JP", {
                year: "numeric",
                month: "2-digit",
                day: "2-digit",
              }).replaceAll("/", "")
            }.log`,
          ),
        },
      },
    });

    const [context, options] = await args.contextBuilder.get(denops);
    const protocols = await args.denops.dispatcher.getProtocols() as Record<
      string,
      Protocol
    >;
    const [tomlExt, tomlOptions, tomlParams] = await getExt<GetTomlExtResults>(
      args,
      "toml",
    );

    const toml = await gatherTomls({
      denops,
      context,
      options,
      protocols,
      tomlExt,
      tomlOptions,
      tomlParams,
      path: await vars.g.get(denops, "toml_dir"),
      noLazyTomlNames: ["dpp.toml", "no_lazy.toml"],
    });

    const [lazyExt, lazyOptions, lazyParams] = await getExt<GetLazyExtResults>(
      args,
      "lazy",
    );
    const lazyResult = await makeState({
      denops,
      context,
      options,
      protocols,
      lazyExt,
      lazyOptions,
      lazyParams,
      plugins: Object.values(toml.recordPlugins ?? {}),
    });

    const checkFiles = gatherCheckFiles(
      await vars.g.get(denops, "base_dir"),
      "**/*.(ts|toml|vim)",
    );

    return {
      checkFiles: checkFiles,
      hooksFiles: toml.hooksFiles,
      ftplugins: toml.ftplugins,
      multipleHooks: toml.multipleHooks,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
