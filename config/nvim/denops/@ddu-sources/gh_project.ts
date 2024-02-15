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

function parseGHProjectAction(project: GHProject): ActionData {
  const {
    closed,
    id,
    number,
    readme,
    shortDescription,
    title,
    url,
  } = project;
  const fieldsTotalCount = project.fields.totalCount;
  const itemsTotalCount = project.items.totalCount;
  const ownerLogin = project.owner.login;
  const ownerType = project.owner.type;
  const isPublic = project.public;

  return {
    closed,
    fieldsTotalCount,
    id,
    itemsTotalCount,
    number,
    ownerLogin,
    ownerType,
    isPublic,
    readme,
    shortDescription,
    title,
    url,
  };
}

function parseGHProjectItem(project: GHProject): Item<ActionData> {
  return {
    word: project.title,
    display: project.title,
    action: parseGHProjectAction(project),
    kind: "gh_project",
  };
}

type Params = {
  cmd: string;
  owner: string;
  limit: number;
};

type GHProject = {
  closed: boolean,
  fields: {
    totalCount: number
  },
  id: string,
  items: {
    totalCount: number,
  },
  number: number,
  owner: {
    login: string,
    type: string
  },
  public: boolean,
  readme: string,
  shortDescription: string,
  title: string,
  url: string
};

export class Source extends BaseSource<Params> {
  override kind = "gh_project";

  override gather(
    { sourceParams }: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
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
            new WritableStream<{ projects: GHProject[] }>({
              write(chunk: { projects: GHProject[] }) {
                controller.enqueue(
                  chunk.projects.map((project) => parseGHProjectItem(project)),
                );
              },
            }),
          ).finally(async () => {
            await stdout.cancel();
            controller.close();
          });
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
