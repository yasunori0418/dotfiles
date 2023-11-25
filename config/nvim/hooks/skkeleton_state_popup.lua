-- lua_source {{{
vim.fn["skkeleton_state_popup#config"]({
    labels = {
        ["input:okurinasi"] = { hira = "▽", kata = "▽", hankata = "▽", abbrev = "▽" },
        ["input:okuriari"] = { hira = "▽", kata = "▽", hankata = "▽" },
        henkan = { hira = "▼", kata = "▼", hankata = "▼", abbrev = "▼" },
    },
    opts = { relative = "cursor", col = 12, row = 1, anchor = "NW", style = "minimal" },
})
vim.fn["skkeleton_state_popup#run"]()
-- }}}
