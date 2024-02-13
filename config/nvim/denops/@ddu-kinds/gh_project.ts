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
  closed: boolean;
  fieldsTotalCount: number;
  id: string;
  itemsTotalCount: number;
  number: number;
  ownerLogin: string;
  ownerType: string;
  isPublic: boolean;
  readme: string;
  shortDescription: string;
  title: string;
  url: string;
};

type Params = Record<never, never>;

export class Kind extends BaseKind<Params> {
  override actions: Record<
    string,
    (args: ActionArguments<Params>) => Promise<ActionFlags>
  > = {
    echo: (args: { denops: Denops; items: DduItem[] }) => {
      for (const item of args.items) {
        const action = item.action as ActionData;
        console.log(`number: "${action.number}", title: "${action.title}"`);
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
      path: action.title,
    };
  }

  override params(): Params {
    return {};
  }
}
