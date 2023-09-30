-- lua_source {{{
require("fidget").setup({
    text = {
        spinner = "dots",
    },
    window = {
        border = "single",
        relative = "editor",
    },
    sources = {
        ["null-ls"] = {
            ignore = true,
        },
    },
})
-- }}}
