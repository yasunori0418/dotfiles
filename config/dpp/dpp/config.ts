import {
  BaseConfig,
  ConfigReturn,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.8/types.ts";
import { Denops, vars } from "https://deno.land/x/dpp_vim@v0.0.8/deps.ts";

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
    const denops = args.denops;
    // const contextBuilder = args.contextBuilder;
    // const basePath = args.basePath;
    // const dpp = args.dpp;

    const inlineVimrcs: string[] = [];
    try {
      const RC_DIR = Deno.env.get("RC_DIR");
      if (typeof RC_DIR == "undefined") {
        throw "failure read directory in $RC_DIR";
      }
      for (const dirEntry of Deno.readDirSync(RC_DIR)) {
        if (typeof dirEntry == "undefined") {
          continue;
        }
        inlineVimrcs.push(dirEntry.name);
      }
    } catch (e) {
      console.error(e);
      throw e;
    }

    args.contextBuilder.setGlobal({
      protocols: ["git"],
    });

    const [context, options] = await args.contextBuilder.get(args.denops);

    const tomlPlugins = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "toml",
      "load",
      {
        path: "$BASE_DIR/toml/dpp.toml",
      },
    ) as Plugin[];
    console.log(tomlPlugins);

    const recordPlugins: Record<string, Plugin> = {};
    for (const plugin of tomlPlugins) {
      recordPlugins[plugin.name] = plugin;
    }

    const stateLines = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(recordPlugins),
      },
    ) as string[];

    return {
      plugins: Object.values(recordPlugins),
      stateLines,
    };
  }
}
