-- lua_dockerfile {{{
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
-- }}}

-- lua_sshconfig {{{
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 0
vim.opt_local.shiftwidth = 0
vim.opt_local.expandtab = false
-- }}}

-- lua_gitconfig {{{
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 0
vim.opt_local.shiftwidth = 0
vim.opt_local.expandtab = false
-- }}}

-- lua_make {{{
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 0
vim.opt_local.shiftwidth = 0
vim.opt_local.expandtab = false
-- }}}

-- lua_markdown {{{
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
-- }}}

-- lua_php {{{
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
-- }}}

-- lua_lua {{{
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
-- }}}

-- lua_python {{{
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
-- }}}

-- lua_help {{{
vim.opt_local.conceallevel = 0
vim.opt_local.foldmethod = "marker"
vim.opt_local.foldenable = true

-- lexima altercmdで範囲選択した後のコマンド展開で、
-- <C-w>で選択マーカー('<,'>)が飲み込まれてしまう問題を回避する。
-- iskeywordに">"を含まないようにする。
vim.opt_local.iskeyword:append([[^>]])
-- }}}

-- lua_toml {{{
vim.opt_local.foldmethod = "marker"
vim.opt_local.foldenable = true
-- }}}

-- lua_qf {{{
vim.opt_local.number = true
vim.opt_local.relativenumber = false
vim.keymap.set("n", "R", function()
    vim.cmd([[Qfreplace topleft vsplit]])
end, { silent = true, noremap = true })
-- }}}
