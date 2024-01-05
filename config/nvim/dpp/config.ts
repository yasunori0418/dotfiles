import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn,
  Denops,
  Dpp,
  gatherTomls,
  gatherVimrcs,
  LazyMakeStateResult,
  Plugin,
  Toml,
  vars,
  VimrcSkipRule,
} from "./deps.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const denops: Denops = args.denops;
    const dpp: Dpp = args.dpp;

    const vimrcSkipRules = [
      {
        name: "neovide.lua",
        condition: vars.globals.get(denops, "neovide") === null,
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
    });

    const tomls = await gatherTomls(
      await vars.globals.get(denops, "toml_dir"),
      ["dpp.toml", "no_lazy.toml"],
      args,
    ) as Toml[];

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];

    for (const toml of tomls) {
      if (toml.plugins) {
        for (const plugin of toml.plugins) {
          recordPlugins[plugin.name] = plugin;
        }
      }

      if (toml.ftplugins) {
        for (const filetype of Object.keys(toml.ftplugins)) {
          if (ftplugins[filetype]) {
            ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
          } else {
            ftplugins[filetype] = toml.ftplugins[filetype];
          }
        }
      }

      if (toml.hooks_file) {
        hooksFiles.push(toml.hooks_file);
      }
    }

    const [context, options] = await args.contextBuilder.get(denops);

    const lazyResult = await dpp.extAction(
      denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(recordPlugins),
      },
    ) as LazyMakeStateResult | undefined;

    return {
      ftplugins,
      hooksFiles,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
