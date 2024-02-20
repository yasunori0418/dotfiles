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
  id: string;
  status: string;
};

type Params = Record<never, never>;

async function createScratchBuffer(
  denops: Denops,
  name: string,
): Promise<{ bufnr: number; bufname: string }> {
  const bufnr: number = await fn.bufadd(denops, `gh_project://${name}`);
  const bufname: string = await fn.bufname(denops, bufnr);
  await fn.bufload(denops, bufnr);
  await fn.setbufvar(denops, bufname, "&buftype", "nofile");
  await fn.setbufvar(denops, bufname, "&bufhidden", "hide");
  await fn.setbufvar(denops, bufname, "&swapfile", false);
  return {
    bufnr,
    bufname,
  };
}

async function openBuffer(
  denops: Denops,
  bufnr: number,
  openKind: "horizontal" | "vertical",
): Promise<void> {
  if (openKind === "horizontal") {
    await denops.cmd(`split +buffer${bufnr}`);
  } else if (openKind === "vertical") {
    await denops.cmd(`vsplit +buffer${bufnr}`);
  }
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
      const action = args.items[0].action as ActionData;
      const { bufnr } = await createScratchBuffer(args.denops, action.id);
      await openBuffer(args.denops, bufnr, "horizontal");
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
