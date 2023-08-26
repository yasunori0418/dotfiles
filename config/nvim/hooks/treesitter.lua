-- lua_source {{{
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "git_config",
    "git_rebase",
    "gitcommit",
    "gitignore",
    "lua",
    "luadoc",
    "dockerfile",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "toml",
    "typescript",
    "vim",
    "yaml",
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  -- Settings for load reduction.
  sync_install = true,
  -- Automatically install missing parsers when entering buffer
  auto_install = true,
  highlight = {
    enable = true,
    disable = {
      "vimdoc",
    },
  },
  indent = {
    enable = false,
  },
  yati = {
    enable = true,
    default_lazy = true,
    default_fallback = "auto",
  },
})
-- }}}

-- lua_post_update {{{
vim.opt.more = false
vim.cmd([[TSUpdate]])
vim.opt.more = true
-- }}}
