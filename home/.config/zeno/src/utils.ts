import $ from "jsr:@david/dax@0.45.0";
import * as R from "jsr:@remeda/remeda@2.33.6";

/**
 * `gh run list --json` に渡すフィールド。
 * この順序がそのままタブ区切りの列順になる（`--preview` の `{1}` が先頭列に依存）。
 */
export const GITHUB_RUN_FIELDS = [
  "databaseId",
  "status",
  "conclusion",
  "workflowName",
  "headBranch",
  "displayTitle",
] as const;

/**
 * `conclusion` は実行中の run では null になる（REST API の workflow-run スキーマ準拠）。
 * 未知フィールドの追加に備え、値は nullable として扱う。
 */
type GitHubRun = Record<
  (typeof GITHUB_RUN_FIELDS)[number],
  string | number | null
>;

export const formatGitHubRun = (run: GitHubRun): string =>
  GITHUB_RUN_FIELDS.map((field) => run[field] ?? "").join("\t");

/** `gh run list --json` の出力を fzf 用のタブ区切り行へ整形する。 */
export const listGitHubRuns = (json: string): string[] =>
  R.pipe(JSON.parse(json) as GitHubRun[], R.map(formatGitHubRun));

export const fetchGitHubRuns = async (): Promise<string[]> => {
  const output = await $`gh run list --json ${GITHUB_RUN_FIELDS.join(",")}`
    .text();

  return listGitHubRuns(output);
};

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
