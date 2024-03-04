import { Denops } from "https://deno.land/x/denops_std@v6.3.0/mod.ts";
import { ensure, is } from "https://deno.land/x/unknownutil@v3.16.3/mod.ts";
import { parse as tomlParse } from "https://deno.land/std@0.218.2/toml/mod.ts";
import { TaskEdit } from "../@ddu-kinds/gh_project_task.ts";

export function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async send(buflines: unknown): Promise<void> {
      const tomlString = ensure(buflines, is.ArrayOf(is.String)).join("\n");
      const taskData = tomlParse(tomlString) as TaskEdit;
      console.log(taskData);
      return await Promise.resolve();
    },
  };

  return Promise.resolve();
}
