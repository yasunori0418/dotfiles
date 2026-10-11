# natural-japanese スキル（coji/natural-japanese）の SKILL.md 末尾に、textlint MCP を
# 併用する手順（natural-japanese-textlint.md）を足した版を組み立てる。
#
# layat の配置先は store 直結の read-only なので SKILL.md を直接は編集できない。
# 上流の本文には手を入れず末尾に節を足すだけにして、flake input を更新しても
# 衝突しないようにしている。
{ runCommand, src }:

runCommand "natural-japanese-skill" { } ''
  cp -r ${src}/skills/natural-japanese $out
  chmod -R u+w $out
  cat ${./natural-japanese-textlint.md} >> $out/SKILL.md
''
