import {
  ActionArguments,
  ActionFlags,
  BaseKind,
  DduItem,
  PreviewContext,
} from "https://deno.land/x/ddu_vim@v3.10.2/types.ts";
import { Denops, fn, vars } from "https://deno.land/x/ddu_vim@v3.10.2/deps.ts";

export type ActionData = {
  path: string;
};

type Params = Record<never, never>;

export class Kind extends BaseKind<Params> {
  override actions: Record<
    string,
    (args: ActionArguments<Params>) => Promise<ActionFlags>
  > = {
    echo: async (args: { denops: Denops; items: DduItem[] }) => {
      for (const item of args.items) {
        console.log(item.action.path);
      }
      return Promise.resolve(ActionFlags.None);
    },
  };

  override async getPreviewer(args: {
    denops: Denops;
    item: DduItem;
    actionParams: unknown;
    previewContext: PreviewContext;
  }): Promise<Previewer | undefined> {
    const action = args.item.action as ActionData;
    if (!action) {
      return undefined;
    }

    return {
      kind: "buffer",
      path: action.path,
    };
  }

  override params(): Params {
    return {};
  }
}
