# textlint に AI っぽい日本語表現を検出する preset（textlint-rule-preset-ai-words-ja）を
# 同梱したもの。applications.nix（PATH 用）と claudeSettings.nix（MCP サーバー用の
# 絶対パス）の両方から callPackage して同一 derivation を共有する。
#
# 設定ファイルは ~/.config/textlint/.textlintrc.json に置くが、textlint は cwd から
# 上方向に .textlintrc を探すだけで XDG を見ないため、実行時は `--config` で明示する。
{ textlint, textlint-rule-preset-ai-words-ja }:

textlint.withPackages [ textlint-rule-preset-ai-words-ja ]
