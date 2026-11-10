
## 追補: textlint の併用（この環境のみ）

この節は配布元の SKILL.md にはなく、dotfiles 側で末尾に足したもの。

textlint MCP の `mcp__textlint__lintFile` を、yomiyasu の lint と同じ時点で回す（下書きをファイルにしていなければ `mcp__textlint__lintText`）。有効なルールは textlint-rule-preset-ai-words-ja で、AI が書いた文章に多い語や言い回しを形態素単位で拾う。yomiyasu の lint と一部重なるが、拾う語の一覧が違う。

- Step 2 の前: 原文に `yomiyasu_lint.py` をかけるとき、同じ原文を textlint にも渡し、書き直しの手がかりに加える
- Step 3: 最終稿を `yomiyasu_check.py run` にかけるとき、同じ最終稿を textlint にも渡す
- Step 4: textlint の指摘も run の候補と同じく疑いの提示として扱い、直すものは Step 4 の 1 回の修正にまとめる。直したら Step 3 の run をやり直すときに textlint も回し直す。残した指摘は理由を添えて「残したAIっぽいところ」か「変えたところ」に `textlint:<ruleId>` の形で書く
- Step 5 の verify のあとは、textlint の指摘を理由に本文を変えない。変えたら yomiyasu の決まりどおり run と verify をやり直す

MCP のツールが見つからないときは、CLI の `textlint --config ~/.config/textlint/.textlintrc.json <file>` で代用する。textlint は設定ファイルを XDG から探さないので、`--config` は省略できない。SKILL.md の決まりに合わせ、このコマンドにも `cd`、`&&`、リダイレクトを付けない。
