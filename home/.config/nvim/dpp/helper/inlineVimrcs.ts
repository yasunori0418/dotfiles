export type VimrcSkipRule = {
  name: string; // file name
  condition: boolean; // skip target by condition
};

export function gatherVimrcs(
  path: string,
  vimrcSkipRules: VimrcSkipRule[],
): string[] {
  const inlineVimrcs: string[] = [];
  if (path === null) throw `failure read directory in ${path}`;
  for (const dirEntry of Deno.readDirSync(path)) {
    if (typeof dirEntry == "undefined") continue;

    const vimrcSkipRule = vimrcSkipRules.find((skipRule) => {
      return dirEntry.name == skipRule.name;
    }) as VimrcSkipRule | undefined;

    if (vimrcSkipRule?.condition) continue;

    inlineVimrcs.push(`${path}/${dirEntry.name}`);
  }
  return inlineVimrcs;
}
