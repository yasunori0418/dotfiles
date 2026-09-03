#!/usr/bin/env bash

# `make nput-recopy` を実行したら ~/.claude/settings.json がどう変わるかを、
# JSON のキーパス単位で事前に確認する。
#
# settings.json は home-manager/claudeSettings.nix から生成した JSON を nput が
# method = "copy"（place-once）で配置する。copy 済みの target に `nput apply` は
# 触れないため、Nix 側を編集しただけでは反映されず `nput apply --recopy` が要る。
# 逆に recopy は Claude Code の TUI が settings.json へ書き戻した項目
# （outputStyle・effortLevel・enabledPlugins 等）を Nix 生成の内容へ巻き戻す。
# その巻き戻しで何が消えるのかを、実行前に見えるようにするのがこのスクリプト。
#
# 比較するのは以下の 2 つ。
#
#   現行      : ${CLAUDE_SETTINGS_FILE}（既定 ~/.claude/settings.json）
#   recopy 後 : Nix 生成 JSON に ~/.claude/inject/*.json を重ねたもの
#
# 後者に inject を重ねるのは、make nput-recopy が recopy に続けて
# claude-settings-inject を流すため。素の Nix 生成 JSON と比べると、
# 実際には注入で戻ってくる値まで「消える」と表示されてしまう。
# マージ規則（辞書順・`*` による再帰マージ・object でないファイルはスキップ）は
# scripts/claude-settings-inject.sh と揃えてある。
#
# 出力は 1 行 1 キーパスで、記号は git diff と同じ向き（現行 → recopy 後）。
#
#   -  現行にしか無い    → recopy で消える
#   +  recopy 後にしか無い → recopy で追加される
#   ~  値が変わる
#
# 配列は、要素がすべてスカラーなら集合として比較して添字を出さない
# （permissions.allow に 1 つ足しただけで以降の全要素が「変更」に見えるのを避ける）。
# object を含む配列（hooks.* など）は添字付きのキーパスで比較する。
#
# 終了コードは diff(1) に倣う（0 = 差分なし / 1 = 差分あり / 2 = エラー）。

set -euo pipefail

SETTINGS_FILE="${CLAUDE_SETTINGS_FILE:-${HOME}/.claude/settings.json}"
readonly SETTINGS_FILE

INJECT_DIR="${CLAUDE_INJECT_DIR:-${HOME}/.claude/inject}"
readonly INJECT_DIR

die() {
    echo "claude-settings-diff: $1" >&2
    exit 2
}

command -v jq >/dev/null 2>&1 || die "jq not found"
command -v nix >/dev/null 2>&1 || die "nix not found"
command -v git >/dev/null 2>&1 || die "git not found"
[[ -f ${SETTINGS_FILE} ]] || die "${SETTINGS_FILE} not found"

# リポジトリ root は git に解決させる（`git root` エイリアスの定義そのもの）。
# エイリアス自体は個人の gitconfig にしか無いため、activation や CI から
# 実行しても壊れないよう展開して埋める。--show-superproject-working-tree を
# 先に置くのはサブモジュール内から叩いたときに親の root を拾うためで、
# 通常は空行なので head -1 が --show-toplevel の結果を取る。
# CWD に依存させないよう、スクリプト自身のあるディレクトリで実行する。
# BSD/GNU で挙動の割れる readlink -f は避ける。
REPO_ROOT="$(
    cd "$(dirname "${BASH_SOURCE[0]}")" &&
        git rev-parse --show-superproject-working-tree --show-toplevel 2>/dev/null |
        head -1
)"
readonly REPO_ROOT

[[ -n ${REPO_ROOT} ]] || die "failed to resolve repository root via git rev-parse"

system="$(nix config show system)"

# nput manifest をビルドして、.claude/settings.json エントリの src（Nix 生成 JSON の
# store path）を引く。nput apply が実際に copy してくるのと同じ実体。
manifest_dir="$(nix build --no-link --print-out-paths "${REPO_ROOT}#nput.${system}.default")" ||
die "failed to build nput.${system}.default"

nix_json="$(jq -r '
    .entries[]
    | select(.target == ".claude/settings.json")
    | .src
' "${manifest_dir}/manifest.json")"

[[ -n ${nix_json} && -f ${nix_json} ]] ||
die "no .claude/settings.json entry in ${manifest_dir}/manifest.json"

# inject の断片を集める（inject を持たないマシンでは 0 件。それでも比較は行う）。
fragments=()
if [[ -d ${INJECT_DIR} ]]; then
    shopt -s nullglob
    fragments=("${INJECT_DIR}"/*.json)
    shopt -u nullglob
fi

# 壊れた JSON や object でない断片は inject 側も適用しないので、ここでも除外する。
valid_fragments=()
for fragment in "${fragments[@]}"; do
    if jq -e 'type == "object"' "${fragment}" >/dev/null 2>&1; then
        valid_fragments+=("${fragment}")
    else
        echo "claude-settings-diff: ${fragment} is not a JSON object; ignored" >&2
    fi
done

expected="$(jq -s 'reduce .[] as $item ({}; . * $item)' \
    "${nix_json}" ${valid_fragments+"${valid_fragments[@]}"})"

if [[ -t 1 ]]; then
    c_del=$'\033[31m' c_add=$'\033[32m' c_mod=$'\033[33m' c_dim=$'\033[2m' c_off=$'\033[0m'
else
    c_del='' c_add='' c_mod='' c_dim='' c_off=''
fi

# 現行 / recopy 後をそれぞれ「キーパス → 値」の平坦な写像へ潰してから比較する。
#
# - object は再帰的に降りる
# - 要素がすべてスカラー（object / array を含まない）の配列は集合として扱い、
#   キーパスを `<path>[]`、値を要素そのものにして 1 要素 1 エントリで出す。
#   → 並び替えただけなら差分にならず、追加・削除だけが出る
# - それ以外の配列は添字付きのキーパスで降りる
diff_output="$(
    jq -n -r \
        --argjson current "$(jq '.' "${SETTINGS_FILE}")" \
        --argjson expected "${expected}" \
        --arg c_del "${c_del}" --arg c_add "${c_add}" --arg c_mod "${c_mod}" \
        --arg c_dim "${c_dim}" --arg c_off "${c_off}" '
        def is_scalar_array: type == "array" and (all(.[]; type != "object" and type != "array"));

        def flatten($prefix):
            . as $node
            | if ($node | type) == "object" then
                  reduce ($node | keys_unsorted[]) as $k
                      ({}; . + ($node[$k] | flatten(if $prefix == "" then $k else "\($prefix).\($k)" end)))
              elif ($node | is_scalar_array) then
                  # 集合として扱う。キーに値そのものを埋めることで、並び替えを
                  # 差分にせず追加・削除だけを拾う。同値要素は 1 エントリに畳む。
                  reduce ($node[]) as $v ({}; . + { "\($prefix)[] = \($v | tojson)": { "__set_member__": true } })
              elif ($node | type) == "array" then
                  reduce range($node | length) as $i
                      ({}; . + ($node[$i] | flatten("\($prefix)[\($i)]")))
              else
                  { ($prefix): $node }
              end;

        ($current | flatten("")) as $cur
        | ($expected | flatten("")) as $exp
        | [($cur | keys[]), ($exp | keys[])] | flatten | unique
        | map(
            . as $k
            | if ($cur | has($k)) and ($exp | has($k)) then
                  if ($cur[$k]) == ($exp[$k]) then empty
                  else "\($c_mod)~ \($k): \($cur[$k] | tojson) -> \($exp[$k] | tojson)\($c_off) \($c_dim)(recopy で変更)\($c_off)"
                  end
              elif ($cur | has($k)) then
                  "\($c_del)- \($k)\(if ($cur[$k]) == { "__set_member__": true } then "" else ": \($cur[$k] | tojson)" end)\($c_off) \($c_dim)(現行のみ / recopy で消える)\($c_off)"
              else
                  "\($c_add)+ \($k)\(if ($exp[$k]) == { "__set_member__": true } then "" else ": \($exp[$k] | tojson)" end)\($c_off) \($c_dim)(recopy 後のみ / recopy で追加される)\($c_off)"
              end
          )
        | .[]
    '
)"

if [[ -z ${diff_output} ]]; then
    echo "claude-settings-diff: 差分なし（${SETTINGS_FILE} は recopy 後と一致）"
    exit 0
fi

echo "claude-settings-diff: 現行 → recopy 後（${SETTINGS_FILE}）"
echo "  現行      : ${SETTINGS_FILE}"
echo "  recopy 後 : ${nix_json}${valid_fragments:+ + ${#valid_fragments[@]} inject file(s)}"
echo
printf '%s\n' "${diff_output}"
exit 1
