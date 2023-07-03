-- lua_source {{{
local c3 = require("ccc")

c3.setup({
  win_opts = {
    border = 'single',
  },
  preserv = true,
  hightlighter = {
    auto_enable = true,
  },
})
-- }}}

-- lua_source_post {{{
vim.cmd([[CccHighlighterEnable]])
-- }}}
