import $ from "jsr:@david/dax@0.43.2";

export const findDirectories = async (path: string): Promise<string[]> =>
  (await $`fd --hidden --exclude '.git' --color=never --type d --full-path ${path}`
    .text())
    .split("\n");
