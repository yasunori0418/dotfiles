-- lua_add {{{
vim.opt.showmode = false
vim.opt.laststatus = 0
-- }}}

-- lua_source {{{
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.g.heirline_indicator_type = "simple"

-- $BASE_DIR/lua/user/plugins/heirline
require("user.plugins.heirline").setup()
-- }}}
