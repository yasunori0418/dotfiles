--- この設定は良い…
--- https://github.com/kyoh86/dotfiles/blob/dd84787/nvim/lua/kyoh86/plug/heirline/mode.lua
--- Statuslineのmodeに関する設定
local indicator = { -- see :help mode(1)
    emoji = { -- emoji indicator
        n = "\u{E7C5}  ", --[[                     : ノーマル ]]
        no = "\u{E7C5}\u{F01D8} ", --[[        󰇘   : オペレータ待機 ]]
        nov = "\u{E7C5}\u{F01D8} ", --[[       󰇘   : オペレータ待機（強制文字単位） ]]
        noV = "\u{E7C5}\u{F01D8} ", --[[       󰇘   : オペレータ待機（強制行単位） ]]
        ["no"] = "\u{E7C5}\u{F01D8} ", --[[  󰇘   : オペレータ待機（強制ブロック単位） ]]
        niI = "\u{F246}\u{E7C5} ", --[[           : Insert-mode で i_CTRL-O を使用したノーマル ]]
        niR = "\u{F027C} \u{E7C5} ", --[[      󰉼   : Replace-mode で i_CTRL-O を使用したノーマル ]]
        niV = "\u{F027C} \u{E7C5} ", --[[      󰉼   : Virtual-Replace-mode で i_CTRL-O を使用したノーマル ]]
        nt = "\u{F120}\u{E7C5} ", --[[            : 端末ノーマル ]]

        v = "\u{F09A8}  ", --[[                󰦨    : 文字単位ビジュアル ]]
        vs = "\u{F09A8}  ", --[[               󰦨    : 選択モードで v_CTRL-O を利用した時の文字単位ビジュアル ]]
        V = "\u{F039}  ", --[[                     : 行単位ビジュアル ]]
        Vs = "\u{F039}  ", --[[                    : 選択モードで v_CTRL-O を利用した時の行単位ビジュアル ]]
        [""] = "\u{F0FE6}  ", --[[           󰿦    : 矩形ビジュアル ]]
        ["s"] = "\u{F0FE6}  ", --[[          󰿦    : 選択モードで v_CTRL-O を利用した時の矩形ビジュアル ]]

        s = "\u{F45A}  ", --[[                     : 文字単位選択 ]]
        S = "\u{F45A}  ", --[[                     : 行単位選択 ]]
        [""] = "\u{F45A}  ", --[[                : 矩形選択 ]]

        i = "\u{F246}  ", --[[                     : 挿入 ]]
        ic = "\u{F246}\u{F01D8} ", --[[        󰇘   : 挿入モード補完 ]]
        ix = "\u{F246}\u{F01D8} ", --[[        󰇘   : 挿入モード i_CTRL-X 補完 ]]

        R = "\u{F027C}  ", --[[                󰉼    : 置換 ]]
        Rc = "\u{F027C} \u{F01D8} ", --[[      󰉼 󰇘  : 置換モード補完 compl-generic ]]
        Rv = "\u{F027C}  ", --[[               󰉼    : 仮想置換 gR ]]
        Rvc = "\u{F027C} \u{F01D8} ", --[[     󰉼 󰇘  : 補完での仮想置換モード compl-generic ]]
        Rvx = "\u{F027C} \u{F01D8} ", --[[     󰉼 󰇘  : i_CTRL-X 補完での仮想置換モード ]]

        c = "\u{F423}  ", --[[                     : コマンドライン編集 ]]
        cv = "\u{F423}  ", --[[                    : Vim Ex モード gO ]]
        ce = "\u{F423}  ", --[[                    : ノーマル Ex モード Q ]]

        r = "\u{F071}  ", --[[                     : 未使用（StatusLineが表示されない）; Hit-Enter プロンプト ]]
        rm = "\u{F071}  ", --[[                    : 未使用（StatusLineが表示されない）; -- more -- プロンプト ]]
        ["r?"] = "\u{F059}  ", --[[                : 未使用（StatusLineが表示されない）; ある種の :conrifm 問い合わせ ]]

        t = "\u{F120}  ", --[[                     : 端末モード ]]
        ["!"] = "\u{F070E}  ", --[[            󰜎    : 未使用（StatusLineが表示されない）; シェルまたは外部コマンド実行中 ]]
    },
    simple = { -- simple indicator
        n = "N  ",
        no = "N? ",
        nov = "N? ",
        noV = "N? ",
        ["no"] = "N? ",
        niI = "Ni ",
        niR = "Nr ",
        niV = "Nv ",
        nt = "Nt ",
        v = "V ",
        vs = "Vs ",
        V = "V_ ",
        Vs = "Vs ",
        [""] = "^V ",
        ["s"] = "^V ",
        s = "S  ",
        S = "S_ ",
        [""] = "^S ",
        i = "I  ",
        ic = "Ic ",
        ix = "Ix ",
        R = "R  ",
        Rc = "Rc ",
        Rx = "Rx ",
        Rv = "Rv ",
        Rvc = "Rv ",
        Rvx = "Rv ",
        c = "C  ",
        cv = "Ex ",
        r = "...",
        rm = "M  ",
        ["r?"] = "?  ",
        ["!"] = "!  ",
        t = "T  ",
    },
}

local M = {}

M.Vim = {
    provider = function(self)
        return self.padding_char .. indicator[vim.g.heirline_indicator_type][vim.fn.mode(true)]
    end,
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd.redrawstatus()
        end),
    },
}

M.Skk = {
    condition = function()
        if vim.fn["skkeleton#mode"]() ~= "" then
            return true
        end
    end,
    update = {
        "User",
        pattern = "skkeleton-mode-changed",
        callback = vim.schedule_wrap(function()
            vim.cmd.redrawstatus()
        end),
    },
    hl = { bold = false },
    { -- separator.
        provider = function(self)
            return self.separator.sub.left
        end,
    },
    { -- Check skkeleton enable with displayed indicator.
        provider = function(self)
            return self.padding_char .. "SKK "
        end,
    },
    { -- separator.
        provider = function(self)
            return self.separator.sub.left
        end,
    },
    { -- Current skkeleton mode.
        provider = function(self)
            return self.padding_char .. vim.fn["statusline_skk#mode"]()
        end,
    },
}

return M
