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

type Params = {
  cmd: string;
  owner: string;
  limit: number;
  projectNumber?: number;
};

type GHProjectItemContent = {
  title: string;
  body: string;
  type: string;
  number?: number;
  repository?: string;
  url?: string;
};

type GHProjectItem = {
  id: string;
  status: string;
  title: string;
  content: GHProjectItemContent;
  assignees?: string[];
  repository?: string;
};

export class Source extends BaseSource<Params> {
  override kind = "gh_project_item";

  override gather(
    { sourceParams }: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        const projectNumber = sourceParams.projectNumber;
        if (!projectNumber) throw "required projectNumber";

        const { stdout } = new Deno.Command(sourceParams.cmd, {
          args: [
            "project",
            "item-list",
            projectNumber.toString(),
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
            new WritableStream<{ items: GHProjectItem[] }>({
              write(chunk: { items: GHProjectItem[] }) {
                for (const item of chunk.items) {
                  console.log(item);
                }
              },
            }),
          );
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
