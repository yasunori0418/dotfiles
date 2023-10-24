--- この設定は良い…
--- https://github.com/kyoh86/dotfiles/blob/dd84787/nvim/lua/kyoh86/plug/heirline/mode.lua
--- Statuslineのmodeに関する設定
local indicator = { -- see :help mode(1)
    n = "\u{E7C5}  ", --[[                   x : ノーマル ]]
    no = "\u{E7C5}\u{F01D8} ", --[[        󰇘 x : オペレータ待機 ]]
    nov = "\u{E7C5}\u{F01D8} ", --[[       󰇘 x : オペレータ待機（強制文字単位） ]]
    noV = "\u{E7C5}\u{F01D8} ", --[[       󰇘 x : オペレータ待機（強制行単位） ]]
    ["no"] = "\u{E7C5}\u{F01D8} ", --[[  󰇘 x : オペレータ待機（強制ブロック単位） ]]
    niI = "\u{F246}\u{E7C5}", --[[         x : Insert-mode で i_CTRL-O を使用したノーマル ]]
    niR = "\u{F027C} \u{E7C5}", --[[       󰉼 x : Replace-mode で i_CTRL-O を使用したノーマル ]]
    niV = "\u{F027C} \u{E7C5}", --[[       󰉼 x : Virtual-Replace-mode で i_CTRL-O を使用したノーマル ]]
    nt = "\u{F120}\u{E7C5}", --[[          x : 端末ノーマル ]]

    v = "\u{F09A8}   ", --[[               󰦨   x : 文字単位ビジュアル ]]
    vs = "\u{F09A8}   ", --[[              󰦨   x : 選択モードで v_CTRL-O を利用した時の文字単位ビジュアル ]]
    V = "\u{F039}  ", --[[                   x : 行単位ビジュアル ]]
    Vs = "\u{F039}  ", --[[                  x : 選択モードで v_CTRL-O を利用した時の行単位ビジュアル ]]
    [""] = "\u{F0FE6}   ", --[[          󰿦   x : 矩形ビジュアル ]]
    ["s"] = "\u{F0FE6}   ", --[[         󰿦   x : 選択モードで v_CTRL-O を利用した時の矩形ビジュアル ]]

    s = "\u{F45A}  ", --[[                   x : 文字単位選択 ]]
    S = "\u{F45A}  ", --[[                   x : 行単位選択 ]]
    [""] = "\u{F45A}  ", --[[              x : 矩形選択 ]]

    i = "\u{F246}  ", --[[                   x : 挿入 ]]
    ic = "\u{F246}\u{F01D8} ", --[[        󰇘 x : 挿入モード補完 ]]
    ix = "\u{F246}\u{F01D8} ", --[[        󰇘 x : 挿入モード i_CTRL-X 補完 ]]

    R = "\u{F027C}   ", --[[               󰉼   x : 置換 ]]
    Rc = "\u{F027C} \u{F01D8} ", --[[      󰉼 󰇘 x : 置換モード補完 compl-generic ]]
    Rv = "\u{F027C}   ", --[[              󰉼   x : 仮想置換 gR ]]
    Rvc = "\u{F027C} \u{F01D8} ", --[[     󰉼 󰇘 x : 補完での仮想置換モード compl-generic ]]
    Rvx = "\u{F027C} \u{F01D8} ", --[[     󰉼 󰇘 x : i_CTRL-X 補完での仮想置換モード ]]

    c = "\u{F423}  ", --[[                   x : コマンドライン編集 ]]
    cv = "\u{F423}  ", --[[                  x : Vim Ex モード gO ]]
    ce = "\u{F423}  ", --[[                  x : ノーマル Ex モード Q ]]

    r = "\u{F071}  ", --[[                   x : 未使用（StatusLineが表示されない）; Hit-Enter プロンプト ]]
    rm = "\u{F071}  ", --[[                  x : 未使用（StatusLineが表示されない）; -- more -- プロンプト ]]
    ["r?"] = "\u{F059}  ", --[[              x : 未使用（StatusLineが表示されない）; ある種の :conrifm 問い合わせ ]]

    t = "\u{F120}  ", --[[                   x : 端末モード ]]
    ["!"] = "\u{F070E}   ", --[[           󰜎   x : 未使用（StatusLineが表示されない）; シェルまたは外部コマンド実行中 ]]
}

return {
    provider = function()
        return "\u{00A0}" .. indicator[vim.fn.mode(1)]
    end,
}
