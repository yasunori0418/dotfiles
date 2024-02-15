import {
  ActionArguments,
  ActionFlags,
  BaseKind,
  DduItem,
  PreviewContext,
  Previewer,
} from "https://deno.land/x/ddu_vim@v3.10.2/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v3.10.2/deps.ts";

export type ActionData = {
  title: string;
  id: string;
};

type Params = Record<never, never>;

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
  };

  override getPreviewer(args: {
    denops: Denops;
    item: DduItem;
    actionParams: unknown;
    previewContext: PreviewContext;
  }): Promise<Previewer | undefined> {
    const action = args.item.action as ActionData;
    if (!action) {
      return Promise.resolve(undefined);
    }

    return Promise.resolve({
      kind: "buffer",
      path: action.title,
    });
  }

  override params(): Params {
    return {};
  }
}
