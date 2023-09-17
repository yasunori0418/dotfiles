-- lua_add {{{
require('user.utils').autocmd_set("CmdlineEnter", "*", function()
  require('user.plugins.ddc').cmdline_completion()
end)
-- }}}

-- lua_source {{{

-- Source options.
local global_source = { "vsnip", "around", "file", "rg" }

local joinpath = vim.fs.joinpath
local ddc_hooks = joinpath(vim.g.hooks_dir, "ddc")
vim.fn["ddc#custom#load_config"](
-- $HOOKS_DIR/ddc/config.ts
  joinpath(ddc_hooks, "config.ts")
)

-- filetype settings
vim.fn["ddc#custom#patch_filetype"]({ "python", "php", "typescript" }, {
  sources = vim.fn.extendnew(global_source, { "nvim-lsp" }, 0),
})

vim.fn["ddc#custom#patch_filetype"]("lua", {
  sources = vim.fn.extendnew(global_source, { "nvim-lua", "nvim-lsp" }, 0),
})

vim.fn["ddc#custom#patch_filetype"]({ "vim", "toml" }, {
  sources = vim.fn.extendnew(global_source, { "necovim" }, 0),
})

vim.fn["ddc#custom#patch_filetype"]({ "ddu-ff-filter" }, {
  keywordPattern = [=[[0-9a-zA-Z_:#-]*]=],
  sources = { "line", "buffer" },
  specialBufferCompletion = true,
})

vim.fn["ddc#custom#patch_filetype"]({ "deol" }, {
  keywordPattern = [[\w*]],
  sources = { "shell-history" },
  specialBufferCompletion = true,
  sourceOptions = {
    matchers = { "matcher_head" },
    sorters = { "sorter_rank" },
  },
})

---ddc手動補完のソース指定を楽チンにするやつ
-- https://github.com/4513ECHO/dotfiles/blob/73f2f46/config/nvim/dein/settings/ddc.vim#L163-L175
---@param ... string ddc-source name
local ddc_complete = function(...)
  vim.fn["ddc#map#manual_complete"]({ sources = { ... } })
end

-- Keymaping
-- Insert-Mode
local expr_opt = { expr = true, noremap = true }
local opt = { noremap = true, silent = true }
require("user.utils").keymaps_set({
  { -- {i, c}_<C-n>
    mode = { "i", "c" },
    lhs = [[<C-n>]],
    rhs = function()
      if vim.fn["pum#visible"]() then
        vim.fn["pum#map#insert_relative"](1)
      else
        return [[<Down>]]
      end
    end,
    opts = expr_opt,
  },
  { -- {i, c}_<C-p>
    mode = { "i", "c" },
    lhs = [[<C-p>]],
    rhs = function()
      if vim.fn["pum#visible"]() then
        vim.fn["pum#map#insert_relative"](-1)
      else
        return [[<Up>]]
      end
    end,
    opts = expr_opt,
  },
  { -- {i, c}_<C-y>
    mode = { "i", "c" },
    lhs = [[<C-y>]],
    rhs = vim.fn["pum#map#confirm"],
    opts = opt,
  },
  { -- i_<C-e>
    mode = "i",
    lhs = [[<C-e>]],
    rhs = function()
      if vim.fn["pum#visible"]() then
        vim.fn["pum#map#cancel"]()
      else
        return [[<C-G>U<End>]]
      end
    end,
    opts = expr_opt,
  },
  { -- c_<C-e>
    mode = "c",
    lhs = [[<C-e>]],
    rhs = function()
      if vim.fn["pum#visible"]() then
        vim.fn["pum#map#cancel"]()
      else
        return [[<END>]]
      end
    end,
    opts = expr_opt,
  },
  { -- i_<C-x><C-l> manual_complete line
    mode = "i",
    lhs = [[<C-x><C-l>]],
    rhs = function()
      ddc_complete("line")
    end,
    opts = opt,
  },
  { -- i_<C-x><C-n> manual_complete around, rg, buffer
    mode = "i",
    lhs = [[<C-x><C-n>]],
    rhs = function()
      ddc_complete("around", "rg", "buffer")
    end,
    opts = opt,
  },
  { -- i_<C-x><C-f> manual_complete file
    mode = "i",
    lhs = [[<C-x><C-f>]],
    rhs = function()
      ddc_complete("file")
    end,
    opts = opt,
  },
  { -- i_<C-x><C-d> manual_complete lsp
    mode = "i",
    lhs = [[<C-x><C-d>]],
    rhs = function()
      ddc_complete("nvim-lsp")
    end,
    opts = opt,
  },
  { -- i_<C-x><C-v> manual_complete necovim, nvim-lua, cmdline
    mode = "i",
    lhs = [[<C-x><C-v>]],
    rhs = function()
      ddc_complete("necovim", "nvim-lua", "cmdline")
    end,
    opts = opt,
  },
  { -- i_<C-x><C-f> manual_complete vsnip
    mode = "i",
    lhs = [[<C-x><C-s>]],
    rhs = function()
      ddc_complete("vsnip")
    end,
    opts = opt,
  },
  { -- i_<C-x><C-u> manual_complete
    mode = "i",
    lhs = [[<C-x><C-u>]],
    rhs = function()
      vim.fn["ddc#map#manual_complete"]()
    end,
    opts = opt,
  },
})

vim.fn["ddc#enable"]({ context_filetype = [[treesitter]] })
-- }}}