import { type UserCompletionSource } from "@yuki-yano/zeno";

export const define: UserCompletionSource[] = [
  {
    name: "change directory.",
    patterns: ["^cd $"],
    sourceCommand: "fd . --hidden --type d --exclude '.git' --color always",
    options: {
      "--preview": "cd {} && ls -a | sed '/^[.]*$/d'",
      "--prompt": "'cd> '",
    },
  },
  {
    name: "gist edit",
    patterns: ["^gh gist edit $"],
    sourceCommand: "gh gist list",
    callback: "awk -F ' ' '{print $1}'",
    options: {
      "--prompt": "'gist> '",
      "--preview": "gh gist view {}",
    },
  },
  {
    name: "gist view",
    patterns: ["^gh gist view $"],
    sourceCommand: "gh gist list",
    callback: "awk -F ' ' '{print $1}'",
    options: {
      "--prompt": "'gist> '",
    },
  },
  {
    name: "ghq remove project",
    patterns: ["^ghq rm $"],
    sourceCommand: "ghq list",
    options: {
      "--prompt": "'ghq remove> '",
      "--preview": "glow $(git config --global --get ghq.root)/{}/README.md",
    },
  },
];
