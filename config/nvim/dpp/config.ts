import {
  BaseConfig,
  ConfigArg,
  ConfigReturn,
  ContextBuilder,
  Denops,
  Dpp,
  gatherVimrcs,
  LazyMakeStateResult,
  Plugin,
  Toml,
  vars,
  VimrcSkipRule,
} from "./deps.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArg): Promise<ConfigReturn> {
    const denops: Denops = args.denops;
    const contextBuilder: ContextBuilder = args.contextBuilder;
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

    contextBuilder.setGlobal({
      inlineVimrcs: inlineVimrcs,
      protocols: ["git"],
      protocolParams: {
        git: {
          enablePartialClone: true,
        },
      },
    });

    const [context, options] = await contextBuilder.get(denops);

    const tomlDir: string = await vars.globals.get(denops, "toml_dir");
    const tomls: Toml[] = [];

    for (const tomlFile of Deno.readDirSync(tomlDir)) {
      if (typeof tomlFile.name === "undefined") continue;
      const isLazy = !["dpp.toml", "no_lazy.toml"].includes(tomlFile.name);
      tomls.push(
        await dpp.extAction(denops, context, options, "toml", "load", {
          path: `${tomlDir}/${tomlFile.name}`,
          options: {
            lazy: isLazy,
          },
        }) as Toml,
      );
    }

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
