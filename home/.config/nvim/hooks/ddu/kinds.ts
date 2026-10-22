// 以下の kind は jsr に公開されておらず、URL での型 import は各リポジトリの
// import map が効かず解決できないため、使う ActionData の型だけを写して持つ。

// https://github.com/kyoh86/ddu-source-git_log/blob/main/denops/%40ddu-kinds/git_commit/main.ts
export type GitCommitActionData = {
  kind: "commit";
  cwd: string;
  graph: string;
  hash: string;
  author: string;
  authDate: string;
  committer: string;
  commitDate: string;
  subject: string;
} | {
  kind: "graph";
  graph: string;
};

// https://github.com/yuki-yano/ddu-source-nvim-notify/blob/main/denops/%40ddu-kinds/nvim-notify.ts
export type Notification = {
  icon: string;
  id: number;
  level: string;
  message: Array<string>;
  render: unknown;
  time: number;
  title: [text: string, time: string];
};

export type NvimNotifyActionData = {
  id: number;
  notification: Notification;
};
