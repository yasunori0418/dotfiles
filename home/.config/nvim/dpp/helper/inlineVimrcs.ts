export type VimrcSkipRule = {
  name: string; // file name
  condition: boolean; // skip target by condition
};

export function gatherVimrcs(
  path: string,
  vimrcSkipRules: VimrcSkipRule[],
): string[] {
  if (path === null) throw `failure read directory in ${path}`;
  return Array.from(Deno.readDirSync(path))
    .filter(
      (dirEntry) =>
        !vimrcSkipRules.find((skipRule) => dirEntry.name === skipRule.name)
          ?.condition,
    )
    .map(({ name }: Deno.DirEntry) => `${path}/${name}`);
}
