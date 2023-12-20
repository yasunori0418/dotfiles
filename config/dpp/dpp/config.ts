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
    const basePath: string = args.basePath;
    const dpp: Dpp = args.dpp;

    console.log(basePath);

    // const inlineVimrcs: string[] = [];
    // try {
    //   const RC_DIR = Deno.env.get("RC_DIR");
    //   if (typeof RC_DIR == "undefined") {
    //     throw "failure read directory in $RC_DIR";
    //   }
    //   for (const dirEntry of Deno.readDirSync(RC_DIR)) {
    //     if (typeof dirEntry == "undefined") continue;
    //     console.log(vars.globals.get(denops, "neovide"))
    //     if (dirEntry.name == "neovide.lua" && vars.globals.get(denops, "neovide") == null) continue;
    //     inlineVimrcs.push(`$RC_DIR/${dirEntry.name}`);
    //   }
    // } catch (e) {
    //   console.error(e);
    //   throw e;
    // }

    args.contextBuilder.setGlobal({
      protocols: ["git"],
    });

    const [context, options] = await contextBuilder.get(denops);

    const tomls: Toml[] = [];
    const toml = await dpp.extAction(
      denops,
      context,
      options,
      "toml",
      "load",
      {
        path: "$TOML_DIR/dpp.toml",
        options: {
          lazy: false,
        },
      },
    ) as Toml | undefined;
    console.log(toml);
    if (toml) tomls.push(toml);
    console.log(tomls);

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];
    for (const toml of tomls) {
      for (const plugin of toml.plugins) {
        recordPlugins[plugin.name] = plugin;
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
