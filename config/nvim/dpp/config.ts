import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn,
  Denops,
  gatherCheckFiles,
  gatherGhqPlugins,
  gatherTomls,
  gatherVimrcs,
  join,
  LazyMakeStateResult,
  Plugin,
  Toml,
  vars,
  VimrcSkipRule,
} from "./deps.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const denops: Denops = args.denops;

    const vimrcSkipRules = [
      {
        name: "neovide.lua",
        condition: await vars.globals.get(denops, "neovide") === null,
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
          checkDiff: true,
          logFilePath: join(
            await vars.globals.get(denops, "dpp_cache"),
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

    const tomls = await gatherTomls(
      await vars.globals.get(denops, "toml_dir"),
      ["dpp.toml", "no_lazy.toml"],
      args,
    ) as Toml[];

    const recordPlugins: Record<string, Plugin> = {};
    const hooksFiles: string[] = [];

    for (const toml of tomls) {
      if (toml.plugins) {
        for (const plugin of toml.plugins) {
          recordPlugins[plugin.name] = plugin;
        }
      }

      if (toml.hooks_file) {
        hooksFiles.push(toml.hooks_file);
      }
    }

    const [context, options] = await args.contextBuilder.get(denops);

    const lazyResult = await args.dpp.extAction(
      denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(recordPlugins),
      },
    ) as LazyMakeStateResult | undefined;

    const checkFiles = gatherCheckFiles(
      await vars.g.get(denops, "base_dir"),
      "**/*.*(ts|lua|toml)",
    );

    return {
      checkFiles: checkFiles,
      hooksFiles,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
