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
import { ActionData } from "../@ddu-kinds/gh_project_task.ts";

type Params = {
  cmd: string;
  owner: string;
  limit: number;
  projectId?: string;
  projectNumber?: number;
};

type GHProjectTaskContent = {
  title: string;
  body: string;
  type:
    | "DraftIssue"
    | "Issue"
    | "PullRequest";
  number?: number;
  repository?: string;
  url?: string;
  id?: string;
};

type GHProjectTask = {
  id: string;
  status: string;
  title: string;
  content: GHProjectTaskContent;
  assignees?: string[];
  repository?: string;
};

export type GHProjectTaskField = {
  id: string;
  name: string;
  type: string;
  options?: GHProjectTaskSingleSelectField[];
};

type GHProjectTaskSingleSelectField = {
  id: string;
  name: string;
};

export class Source extends BaseSource<Params> {
  override kind = "gh_project_task";

  override gather(
    { sourceParams }: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        const projectNumber = sourceParams.projectNumber;
        if (!projectNumber) throw "required projectNumber";
        const projectId = sourceParams.projectId;
        if (!projectId) throw "required projectId";

        const taskFieldsPipeout = new Deno.Command(sourceParams.cmd, {
          args: [
            "project",
            "field-list",
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

        const taskFields: GHProjectTaskField[] = [];
        await taskFieldsPipeout.stdout
          .pipeThrough(new TextDecoderStream())
          .pipeThrough(new JSONLinesParseStream())
          .pipeTo(
            new WritableStream<{ fields: GHProjectTaskField[] }>({
              write(chunk: { fields: GHProjectTaskField[] }) {
                for (const filed of chunk.fields) {
                  taskFields.push(filed);
                }
              },
            }),
          ).finally(async () => {
            await taskFieldsPipeout.stdout.cancel();
          });

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
            new WritableStream<{ items: GHProjectTask[] }>({
              write(task: { items: GHProjectTask[] }) {
                controller.enqueue(
                  task.items.map((item: GHProjectTask): Item<ActionData> => {
                    return {
                      word: item.title,
                      display: `[${item.status}] ${item.title}`,
                      action: {
                        taskId: item.content.id ?? item.id,
                        projectId: projectId,
                        title: item.title,
                        type: item.content.type,
                        body: item.content.body,
                        currentStatus: item.status,
                        fields: taskFields,
                      },
                    };
                  }).reverse(),
                );
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
      limit: 1000,
    };
  }
}
