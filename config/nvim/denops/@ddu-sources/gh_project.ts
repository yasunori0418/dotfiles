import {
  BaseSource,
  // DduOptions,
  Item,
  // SourceOptions,
} from "https://deno.land/x/ddu_vim@v3.10.2/types.ts";
import {
  GatherArguments,
} from "https://deno.land/x/ddu_vim@v3.10.2/base/source.ts";
import {
  // Denops,
  fn,
} from "https://deno.land/x/ddu_vim@v3.10.2/deps.ts";
import { join } from "https://deno.land/std@0.215.0/path/mod.ts";
import { ActionData } from "../@ddu-kinds/gh_project.ts";

type Params = {
  cmd?: string;
  owner?: string;
  limit?: number;
};

export class Source extends BaseSource<Params> {
  override kind = "gh_project";

  override gather(
    args: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        const dir = await fn.getcwd(args.denops) as string;

        const tree = async (root: string) => {
          const items: Item<ActionData>[] = [];
          try {
            for await (const entry of Deno.readDir(root)) {
              const path = join(root, entry.name);

              items.push({
                word: path,
                action: {
                  path: path,
                },
              });
            }
          } catch (e: unknown) {
            console.error(e);
          }

          return items;
        };

        controller.enqueue(
          await tree(dir),
        );

        controller.close();
      },
    });
  }

  override params(): Params {
    return {
      cmd: "gh",
      owner: "@me",
      limit: 0,
    };
  }
}
