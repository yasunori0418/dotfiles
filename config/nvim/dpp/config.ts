import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn,
  Denops,
  join,
  LazyMakeStateResult,
  vars,
} from "./deps.ts";
import {
  gatherCheckFiles,
  gatherVimrcs,
  VimrcSkipRule,
} from "./helper.ts";
import {
  gatherTomls,
  getTomlExt,
} from "./helper/toml.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const denops: Denops = args.denops;

    const vimrcSkipRules = [
      {
        name: "neovide.lua",
        condition: await vars.g.get(denops, "neovide") === null,
      },
    ] as VimrcSkipRule[];

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
    const protocols = await args.dpp.getProtocols(denops, options);
    const [tomlExt, tomlOptions, tomlParams] = await getTomlExt(args, options);

    const toml = await gatherTomls({
      denops,
      context,
      options,
      protocols,
      tomlExt,
      tomlOptions,
      tomlParams,
      path: await vars.g.get(denops, "toml_dir"),
      noLazyTomlNames: ["dpp.toml", "no_lazy.toml"]
    });

    const lazyResult = await args.dpp.extAction(
      denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(toml.recordPlugins ?? {}),
      },
    ) as LazyMakeStateResult | undefined;

    const checkFiles = gatherCheckFiles(
      await vars.g.get(denops, "base_dir"),
      "**/*.(ts|lua|toml)",
    );

    return {
      checkFiles: checkFiles,
      hooksFiles: toml.hooksFiles,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
