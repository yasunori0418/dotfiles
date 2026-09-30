#!/usr/bin/env bash

# サイドバー相当の一覧（workspace とその配下の agent）を fzf で出し、
# 選んだ先へ移動する。config.toml の [[keys.command]]（type = "popup"）から呼ばれる。
#
# サイドバーは普段 hidden で運用しており、組み込みの navigate mode では
# 切り替え先の選択が見えない。herdr には navigate mode 中だけサイドバーを
# 開く設定も、サイドバーを開閉する API も無いため、popup で代替する。
#
#   workspace 行を選ぶ → herdr workspace focus
#   agent 行を選ぶ     → herdr agent focus（その pane へ直接移動）
#
# preview には pane の現在の画面を出す。workspace 行はアクティブタブで
# フォーカスされている pane、agent 行はその agent の pane。
#
# usage: sidebar-pick.sh                  一覧を出して選ぶ
#        sidebar-pick.sh list             一覧の行だけを出す（fzf の reload 用）
#        sidebar-pick.sh preview <pane>   pane の画面を出す（fzf の preview 用）

set -euo pipefail

# 状態アイコン。色は ANSI で付け、fzf 側は --ansi で解釈させる。
icon() {
    case "$1" in
        working) printf '\e[33m●\e[0m' ;;
        blocked) printf '\e[31m▲\e[0m' ;;
    done) printf '\e[32m✓\e[0m' ;;
    idle) printf '\e[34m○\e[0m' ;;
    *) printf '\e[90m·\e[0m' ;;
esac
}

# 1 行 = "<kind>\t<id>\t<preview pane>\t<表示文字列>"。先頭 3 列は fzf では隠し、
# 選択後の分岐と preview に使う。
list() {
# snapshot 1 回で workspace / tab / pane / agent が全部取れる。
# jq は素材を US(\x1f)区切りで吐くだけにし、整形（アイコン・branch）は shell 側で行う。
herdr api snapshot |
jq -r '
            .result.snapshot as $s
            | ($s.tabs | map({(.tab_id): .}) | add // {}) as $tabs
            | ($s.layouts | map({(.tab_id): .focused_pane_id}) | add // {}) as $focus
            | $s.workspaces | sort_by(.number)[]
            | . as $w
            # branch 表示用の cwd。workspace 自体は cwd を持たないので
            # アクティブタブの先頭 pane から借りる。
            | ([$s.panes[] | select(.tab_id == $w.active_tab_id)][0].foreground_cwd // "") as $cwd
            | (["ws", $w.workspace_id, $w.agent_status, ($w.focused | tostring), $w.label, $cwd,
                ($focus[$w.active_tab_id] // "")] | join("\u001f")),
              ([$s.agents[] | select(.workspace_id == $w.workspace_id)]
               | sort_by($tabs[.tab_id].number)[]
               | ["agent", .pane_id, .agent_status, (.focused | tostring),
                  ($tabs[.tab_id].label // ""), .agent, (.terminal_title_stripped // "")]
               | join("\u001f"))
        ' |
# タブは IFS 上「空白」扱いで連続すると空フィールドが潰れるため、
# 非空白の US を区切りに使う。
while IFS=$'\x1f' read -r kind id status focused f5 f6 f7; do
    # workspace 行は f7 にアクティブタブのフォーカス pane、agent 行は自分の pane。
    mark=' '
    [[ ${focused} == true ]] && mark='*'
    case "${kind}" in
        ws)
            branch=''
            if [[ -n ${f6} ]]; then
                branch=$(git -C "${f6}" branch --show-current 2>/dev/null || true)
            fi
            printf 'ws\t%s\t%s\t%s %s \e[1m%s\e[0m  \e[36m%s\e[0m\n' \
            "${id}" "${f7}" "${mark}" "$(icon "${status}")" "${f5}" "${branch}"
                ;;
            agent)
                printf 'agent\t%s\t%s\t%s   %s %s \e[90m[%s]\e[0m %s\n' \
                "${id}" "${id}" "${mark}" "$(icon "${status}")" "${f6}" "${f5}" "${f7}"
                    ;;
            esac
        done
    }

    preview() {
        local pane=$1
        [[ -n ${pane} ]] || exit 0
        # pane read は CRLF で返すので CR を落とす（残すと fzf の preview が崩れる）。
        herdr pane read "${pane}" --source visible --format ansi 2>/dev/null | tr -d '\r'
    }

    case "${1:-}" in
        list)
            list
            exit 0
            ;;
        preview)
            preview "${2:-}"
            exit 0
            ;;
    esac

    lines=$(list)

    # 初期カーソルを現在の workspace 行に合わせる（fzf の pos は 1 始まり）。
    start=$(printf '%s\n' "${lines}" | awk -F'\t' '$1 == "ws" && $4 ~ /^\*/ { print NR; exit }')

    selected=$(
        printf '%s\n' "${lines}" |
        fzf --ansi --layout=reverse --no-sort \
            --delimiter=$'\t' --with-nth=4.. \
            --preview="$0 preview {3}" \
            --preview-window='down,65%,border-top,follow' \
            --prompt='sidebar> ' \
            --header='enter: focus / ctrl-r: reload / esc: close' \
            --bind="load:pos(${start:-1})" \
            --bind="ctrl-r:reload($0 list)"
    ) || true

    if [[ -z ${selected} ]]; then
        exit 0
    fi

    IFS=$'\t' read -r kind id _ <<<"${selected}"

    case "${kind}" in
        ws) herdr workspace focus "${id}" >/dev/null ;;
        agent) herdr agent focus "${id}" >/dev/null ;;
    esac
