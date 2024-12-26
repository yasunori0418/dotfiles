-- lua_source {{{
vim.fn["skkeleton_state_popup#config"]({
    labels = {
        input = { hira = "あ", kata = "ア", hankata = "ｶﾅ", zenkaku = "Ａ" },
        ["input:okurinasi"] = { hira = "▽", kata = "▽", hankata = "▽", abbrev = "ab" },
        ["input:okuriari"] = { hira = "▽", kata = "▽", hankata = "▽" },
        henkan = { hira = "▼", kata = "▼", hankata = "▼", abbrev = "ab" },
    },
    opts = { relative = "cursor", col = 5, row = 1, zindex = 5000, anchor = "NW", style = "minimal" },
})
vim.fn["skkeleton_state_popup#enable"]()
-- }}}
