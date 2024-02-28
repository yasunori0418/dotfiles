import {
  ActionArguments,
  ActionFlags,
  BaseKind,
  DduItem,
  // PreviewContext,
  // Previewer,
} from "https://deno.land/x/ddu_vim@v3.10.2/types.ts";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v3.10.2/deps.ts";

export type ActionData = {
  title: string;
  taskId: string;
  status: string;
  type:
  | "DraftIssue"
  | "Issue"
  | "PullRequest";
};

type Params = Record<never, never>;

type BufInfo = {
  bufnr: number;
  bufname: string;
};

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
      await fn.appendbufline(denops, bufname, 0, [
        `task_id = '${action.taskId}'`,
        `title = '${action.title}'`,
        `status = '${action.status}'`,
      ]);
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
