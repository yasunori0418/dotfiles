import $ from "jsr:@david/dax@0.45.0";
import * as R from "jsr:@remeda/remeda@2.33.4";

export const findDirectories = async (path: string): Promise<string[]> => {
  const output =
    await $`fd --hidden --exclude '.git' --color=never --type d --full-path ${path}`
      .text();

  return R.pipe(
    output,
    R.split("\n"),
    R.filter((line) => line.length > 0),
    R.map((line) =>
      line.startsWith(path) ? line.slice(path.length).replace(/^\//, "") : line
    ),
  );
};
