-- lua_source {{{
-- The following settings must be made in nvim-ufo.
vim.opt.foldmethod = "manual"
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

local ufo = require("ufo")

local opt = { noremap = true, silent = true }
require("user.utils").keymaps_set({
  { -- zR
    mode = "n",
    lhs = [[zR]],
    rhs = ufo.openAllFolds,
    opts = opt,
  },
  { -- zM
    mode = "n",
    lhs = [[zM]],
    rhs = ufo.closeAllFolds,
    opts = opt,
  },
  { -- zr
    mode = "n",
    lhs = [[zr]],
    rhs = ufo.openFoldsExceptKinds,
    opts = opt,
  },
  { -- zm
    mode = "n",
    lhs = [[zm]],
    rhs = ufo.closeFoldsWith,
    opts = opt,
  },
  { -- <Tab> folded contents preview
    mode = "n",
    lhs = [[<Tab>]],
    rhs = function()
      local winid = ufo.peekFoldedLinesUnderCursor()
      if not winid then
        vim.api.nvim_feedkeys([[<Tab>]], "n", true)
      end
    end,
    opts = opt,
  },
})

local filetype_foldmethod = {
  toml = "", -- foldmethod = marker
  help = "", -- foldmethod = marker
}

ufo.setup({
  open_fold_hl_timeout = 150,
  close_fold_kinds = {'imports', 'comment'},
  preview = {
    win_config = {
      border = {'', '─', '', '', '', '─', '', ''},
      winhighlight = 'Normal:Folded',
      winblend = 0
    },
    mappings = {
      scrollU = '<C-u>',
      scrollD = '<C-d>',
      scrollE = '<C-e>',
      scrollY = '<C-y>',
      jumpTop = '[',
      jumpBot = ']'
    }
  },
  provider_selector = function(_, filetype, _) -- (bufnr, filetype, buftype)
    return filetype_foldmethod[filetype] or {'lsp', 'treesitter', 'indent'}
  end
})

-- }}}
