-- lua_source {{{
-- local insx = require("insx")
-- local with = insx.with

require("insx.preset.standard").setup({
    cmdline = { enabled = true },
    fast_break = { enabled = true, arguments = true, html_attrs = true },
    fast_wrap = { enabled = true },
    spacing = { enabled = true },
})

-- }}}
