-- lua_source {{{
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false

local parser_install_dir = vim.fn.stdpath("data") .. "/parsers"
if vim.fn.isdirectory(parser_install_dir) == 0 then
  vim.fn.mkdir(parser_install_dir, "p")
end

vim.opt.runtimepath:append(parser_install_dir)
require("nvim-treesitter.configs").setup({
  parser_install_dir = parser_install_dir,
  ensure_installed = {
    "bash",
    "diff",
    "dockerfile",
    "git_config",
    "git_rebase",
    "gitcommit",
    "gitignore",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "toml",
    "typescript",
    "vim",
    "yaml",
  },
  ignore_install = {
    "vimdoc",
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  -- Settings for load reduction.
  sync_install = true,
  -- Automatically install missing parsers when entering buffer
  auto_install = true,
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local languages = {
        "vimdoc",
      }
      if vim.iter(languages):find(lang) then
        return true
      end
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
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
