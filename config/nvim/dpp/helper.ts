import {
  ConfigArguments,
  expandGlobSync,
  Plugin,
} from "./deps.ts";


export async function getExt<T>(
  args: ConfigArguments,
  extName: string,
): Promise<T> {
  return await args.denops.dispatcher.getExt(extName) as T;
}

export async function gatherGhqPlugins(
  args: ConfigArguments,
): Promise<Plugin[]> {
  const [context, options] = await args.contextBuilder.get(args.denops);
  return await args.dpp.extAction(
    args.denops,
    context,
    options,
    "ghq",
    "ghq",
    {
      ghq_root: "~/src",
      repos: ["yasunori0418/ddu-gh_project"],
      hostname: "github.com",
      options: {
        lazy: true,
        merged: false,
        on_source: "ddu.vim",
        hook_add:
          "let g:ddu_gh_project_gh_cmd = '/home/yasunori/src/github.com/yasunori0418/cli/bin/gh'",
      },
    },
  ) as Plugin[];
}

export function gatherCheckFiles(path: string, glob: string): string[] {
  const checkFiles: string[] = [];
  for (
    const file of expandGlobSync(glob, {
      root: path,
      globstar: true,
    })
  ) {
    checkFiles.push(file.path);
  }
  return checkFiles;
}
