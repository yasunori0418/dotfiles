import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn,
  Denops,
  join,
  Protocol,
  vars,
} from "./deps.ts";
import { gatherCheckFiles } from "./helper.ts";
import { gatherVimrcs, VimrcSkipRule } from "./helper/inlineVimrcs.ts";
import { gatherTomls, getTomlExt } from "./helper/toml.ts";
import { getLazyExt, makeState } from "./helper/lazy.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const denops: Denops = args.denops;

    const vimrcSkipRules = [
      {
        name: "neovide.lua",
        condition: (await vars.g.get(denops, "neovide")) === null,
      },
    ] as VimrcSkipRule[];

    args.contextBuilder.setGlobal({
      inlineVimrcs: gatherVimrcs(
        await vars.g.get(denops, "rc_dir"),
        vimrcSkipRules,
      ),
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
            `installer_${new Date()
              .toLocaleDateString("ja-JP", {
                year: "numeric",
                month: "2-digit",
                day: "2-digit",
              })
              .replaceAll("/", "")}.log`,
          ),
        },
      },
    });

    const [context, options] = await args.contextBuilder.get(denops);
    const protocols = (await denops.dispatcher.getProtocols()) as Record<
      string,
      Protocol
    >;
    const [tomlExt, tomlOptions, tomlParams] = await getTomlExt(args);

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

    const checkFiles = gatherCheckFiles(
      await vars.g.get(denops, "base_dir"),
      "**/*.(ts|lua|toml)",
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
