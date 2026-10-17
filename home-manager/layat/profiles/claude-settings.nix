# profile `claude-settings`: ~/.claude/settings.json（method = "copy"）だけ。
# `layat apply claude-settings --recopy` の影響範囲をこの 1 ファイルに閉じる。
{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  /*
    ~/.claude/settings.json は Nix attrset から生成した JSON を copy で配置する。

    symlink（store 直結）だと Claude Code の TUI / `/config` による書き戻し
    （effortLevel・outputStyle・enabledPlugins 等）が read-only で失敗するため
    method = "copy" にする。layat の copy は store の read-only モードに
    owner-write を加えて配置するので書き戻せる。

    copy は place-once なので、claudeSettings.nix を編集しただけでは
    switch で反映されない。反映には `make layat-recopy`
    （`layat apply claude-settings --recopy` + inject）が要る。
  */
  claudeSettingsEntry = isDarwin: {
    ".claude/settings.json" = {
      src = import ../../claudeSettings.nix {
        inherit pkgs isDarwin;
        hooks = import ../../claudeHooks.nix {
          inherit lib;
          skills = inputs.yasunori-skills;
          # hook の配置（profiles/claude.nix）と同じ一覧を渡す。
          hookSubpaths = import ../claude-hook-subpaths.nix;
        };
      };
      method = "copy";
    };
  };
in
{
  common = { };
  MacOS = claudeSettingsEntry true;
  Linux = claudeSettingsEntry false;
}
