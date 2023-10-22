-- lua_add {{{
vim.g.lightline_skk_announce = true
-- }}}

-- lua_source {{{
vim.fn["statusline_skk#option"]("display", {
    hiragana = "あぁ󰗧",
    katakana = "アァ󰗧",
    hankaku_katakana = "ｱｧ󰗧",
    zenkaku_alphabet = "Ａａ󰗧",
    alphabet = "Aa󰗧",
})
-- }}}
