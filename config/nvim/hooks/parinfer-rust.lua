-- lua_source {{{
vim.g.parinfer_force_balance = true
-- }}}
-- lua_post_source {{{
vim.cmd("ParinferOn")
-- }}}
-- lua_post_update {{{
vim.cmd("!cargo build --release")
-- }}}
