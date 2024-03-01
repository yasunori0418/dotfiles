import {
  ActionArguments,
  ActionFlags,
  BaseKind,
  DduItem,
  // PreviewContext,
  // Previewer,
} from "https://deno.land/x/ddu_vim@v3.10.2/types.ts";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v3.10.2/deps.ts";
import { GHProjectTaskField } from "../@ddu-sources/gh_project_task.ts";
import { stringify as tomlStringify } from "https://deno.land/std@0.218.2/toml/mod.ts";

export type Task = {
  projectId: string;
  taskId: string;
  title: string;
  body: string;
  status: string;
};

export type ActionData = Task & {
  type: "DraftIssue" | "Issue" | "PullRequest";
  fields: GHProjectTaskField[];
};

type Params = Record<never, never>;

type BufInfo = {
  bufnr: number;
  bufname: string;
};

function createTomlData(action: ActionData): string[] {
  /**
   * 特定のプロパティを上書きする型関数
   * Reference: https://qiita.com/ibaragi/items/2a6412aeaca5703694b1
   */
  type Overwrite<T, U extends { [Key in keyof T]?: unknown }> =
    & Omit<
      T,
      keyof U
    >
    & U;

  const task: Overwrite<Omit<Task, "status">, { body: string[] }> = {
    projectId: action.projectId,
    taskId: action.taskId,
    title: action.title,
    body: action.body.split(/\n/),
  };

  const commentOutToml = (status: string): string => {
    if (action.status === status) {
      return "";
    } else {
      return "# ";
    }
  };
  const toml: string[] = tomlStringify(task).split(/\n/);
  const fields: string[] = [];
  for (const field of action.fields) {
    fields.push(`[field.${field.name}]`);
    fields.push(`fieldId = "${field.id}"`);
    fields.push(`fieldName = "${field.name}"`);
    if (!field.options) fields.push(`fieldText = ""`);
    fields.push("");
    if (field.options) {
      for (const option of field.options) {
        fields.push(
          `${commentOutToml(option.name)}optionId = "${option.id}"`,
        );
        fields.push(
          `${commentOutToml(option.name)}optionName = "${option.name}"`,
        );
        fields.push("");
      }
    }
  }

  return [
    ...toml,
    ...fields,
  ];
}

export class Kind extends BaseKind<Params> {
  override actions: Record<
    string,
    (args: ActionArguments<Params>) => Promise<ActionFlags>
  > = {
    echo: (args: { items: DduItem[] }) => {
      for (const item of args.items) {
        const action = item.action as ActionData;
        console.log(`title: "${action.title}"`);
      }
      return Promise.resolve(ActionFlags.None);
    },
    edit: async (args: { items: DduItem[]; denops: Denops }) => {
      const denops = args.denops;
      const action = args.items[0].action as ActionData;
      const { bufnr, bufname } = await denops.call(
        "gh_project#create_scratch_buffer",
        action.taskId,
      ) as BufInfo;
      await fn.appendbufline(denops, bufname, 0, createTomlData(action));

      denops.call(
        "gh_project#open_buffer",
        bufnr,
        "horizontal",
      ) as Promise<void>;
      return Promise.resolve(ActionFlags.None);
    },
  };

  // override getPreviewer(args: {
  //   denops: Denops;
  //   item: DduItem;
  //   actionParams: unknown;
  //   previewContext: PreviewContext;
  // }): Promise<Previewer | undefined> {
  //   const action = args.item.action as ActionData;
  //   if (!action) {
  //     return Promise.resolve(undefined);
  //   }

  //   return Promise.resolve({
  //     kind: "buffer",
  //     path: action.title,
  //   });
  // }

  override params(): Params {
    return {};
  }
}
