import {
  BaseConfig,
  ConfigReturn,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.9/types.ts";
import { Denops, vars } from "https://deno.land/x/dpp_vim@v0.0.9/deps.ts";

type Toml = {
  hooks_file?: string;
  ftplugins?: Record<string, string>;
  plugins?: Plugin[];
};

type LazyMakeStateResult = {
  plugins: Plugin[];
  stateLines: string[];
};

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<ConfigReturn> {
    const denops: Denops = args.denops;
    const contextBuilder: ContextBuilder = args.contextBuilder;
    // const basePath: string = args.basePath;
    const dpp: Dpp = args.dpp;

    const inlineVimrcs: string[] = [];
    try {
      const rc_dir: string = await vars.g.get(denops, "rc_dir");
      if (rc_dir === null) throw "failure read directory in g:rc_dir";
      for (const dirEntry of Deno.readDirSync(rc_dir)) {
        if (typeof dirEntry == "undefined") continue;
        if (
          dirEntry.name == "neovide.lua" &&
          vars.globals.get(denops, "neovide") === null
        ) continue;
        inlineVimrcs.push(`${rc_dir}/${dirEntry.name}`);
      }
    } catch (e) {
      console.error(e);
      throw e;
    }

    contextBuilder.setGlobal({
      inlineVimrcs: inlineVimrcs,
      protocols: ["git"],
    });

    const [context, options] = await contextBuilder.get(denops);

    const tomls: Toml[] = [];
    const toml_dir: string = await vars.g.get(denops, "toml_dir");
    for (const dirEntry of Deno.readDirSync(toml_dir)) {
      if (typeof dirEntry == "undefined") continue;
      const toml = await dpp.extAction(
        denops,
        context,
        options,
        "toml",
        "load",
        {
          path: `${toml_dir}/${dirEntry.name}`,
          options: {
            lazy: dirEntry.name == "dpp.toml" ? false : true,
          },
        },
      ) as Toml | undefined;
      if (toml) tomls.push(toml);
    }
    console.log(tomls);

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
