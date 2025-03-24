-- lua_add {{{

-- }}}

-- lua_source {{{
vim.g.gin_proxy_apply_without_confirm = 1
vim.g.gin_log_default_args = {
    "++emojify",
    "++opener=tabedit",
    "--graph",
    "--all",
    "--abbrev-commit",
    "--pretty=format:%C(bold yellow)%h%Creset -> %s%C(auto)%d%Creset %C(dim green)(%cr)%Creset%C(dim blue)<%an>%Creset",
}
-- }}}

-- lua_gin-log {{{
vim.opt_local.number = false
vim.opt_local.relativenumber = false
-- }}}

-- lua_gin-status {{{
vim.opt_local.number = false
vim.opt_local.relativenumber = false
-- }}}

-- lua_gin-branch {{{
vim.opt_local.number = false
vim.opt_local.relativenumber = false
-- }}}
