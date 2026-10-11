
## 追補: textlint の併用（この環境のみ）

この節は配布元の SKILL.md にはなく、dotfiles 側で末尾に足したもの。

「3. 検査(1)」で `lint.py` を回すとき、textlint MCP の `mcp__textlint__lintFile` にも同じファイルを渡す（下書きをファイルにしていなければ `mcp__textlint__lintText`）。有効なルールは textlint-rule-preset-ai-words-ja で、AI が書いた文章に多い語や言い回しを形態素単位で拾う。`lint.py` は文長や体言止め率など文章全体の傾向を見るので、両者は検出の対象が重ならない。

textlint の指摘も `lint.py` の findings と同じく疑いの提示として扱い、「4. 検査(2)」の判断台帳に `textlint:<ruleId>` の形で載せて「直した／残す（理由）」を書く。収束ループで `lint.py` を回し直すときは、textlint も一緒に回す。

MCP のツールが見つからないときは、CLI の `textlint --config ~/.config/textlint/.textlintrc.json <file>` で代用する。textlint は設定ファイルを XDG から探さないので、`--config` は省略できない。
