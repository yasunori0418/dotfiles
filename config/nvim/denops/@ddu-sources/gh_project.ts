import {
  BaseSource,
  // DduOptions,
  Item,
  // SourceOptions,
} from "https://deno.land/x/ddu_vim@v3.10.2/types.ts";
import {
  GatherArguments,
} from "https://deno.land/x/ddu_vim@v3.10.2/base/source.ts";
import { JSONLinesParseStream } from "https://deno.land/x/jsonlines@v1.2.2/mod.ts";
import { ActionData } from "../@ddu-kinds/gh_project.ts";
import { GitHubProject } from "../gh_project/type.ts";

type Params = {
  cmd: string;
  owner: string;
  limit: number;
};

export class Source extends BaseSource<Params> {
  override kind = "gh_project";

  override gather(
    { sourceParams }: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        const items: Item<ActionData>[] = [];

        const { stdout } = new Deno.Command(sourceParams.cmd, {
          args: [
            "project",
            "list",
            "--owner",
            sourceParams.owner,
            "--limit",
            sourceParams.limit.toString(),
            "--format",
            "json",
          ],
          stdin: "null",
          stderr: "null",
          stdout: "piped",
        }).spawn();

        await stdout
          .pipeThrough(new TextDecoderStream())
          .pipeThrough(new JSONLinesParseStream())
          .pipeTo(
            new WritableStream<{ projects: GitHubProject[] }>({
              write(chunk: { projects: GitHubProject[] }) {
                for (const project of chunk.projects) {
                  items.push({
                    word: project.title,
                    display: project.title,
                    action: {
                      title: project.title,
                      number: project.number,
                    },
                  });
                }
              },
            }),
          );

        controller.enqueue(items);

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
