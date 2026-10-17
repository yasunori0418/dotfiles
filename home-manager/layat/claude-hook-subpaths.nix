# yasunori0418/skills が配布する Claude Code hook の、リポジトリ内 subpath 一覧
# （<hook 名> = "<plugin>/hooks/<hook 名>"）。
#
# profiles/claude.nix がこれを ~/.claude/hooks/<hook 名> へ symlink 配置し、
# profiles/claude-settings.nix が同じ一覧を claudeHooks.nix に渡して settings.json の
# hook command を `$HOME/.claude/hooks/<hook 名>/main.sh` へ読み替える。
# 両 profile で一覧がずれると配置と参照が食い違うため、ここで 1 つに持つ。
{
  # keep-sorted start
  askuserquestion-guard = "hooks/askuserquestion/hooks/askuserquestion-guard";
  askuserquestion-notify = "hooks/askuserquestion/hooks/askuserquestion-notify";
  askuserquestion-toggle = "hooks/askuserquestion/hooks/askuserquestion-toggle";
  fabricated-toolcall-guard = "hooks/fabricated-toolcall-guard-plugin/hooks/fabricated-toolcall-guard";
  git-guard = "skills/git/hooks/git-guard";
  noclobber-guard = "hooks/noclobber-guard-plugin/hooks/noclobber-guard";
  notify-stop = "hooks/notify-stop-plugin/hooks/notify-stop";
  permission-gate = "hooks/permission-gate-plugin/hooks/permission-gate";
  rm-split-hint = "hooks/permission-gate-plugin/hooks/rm-split-hint";
  sudo-guard = "hooks/sudo-guard-plugin/hooks/sudo-guard";
  task-boundary = "hooks/task-boundary-plugin/hooks/task-boundary";
  teammate-leak-guard = "hooks/teammate-leak-guard-plugin/hooks/teammate-leak-guard";
  webfetch-github-guard = "hooks/webfetch-github-guard-plugin/hooks/webfetch-github-guard";
  # keep-sorted end
}
