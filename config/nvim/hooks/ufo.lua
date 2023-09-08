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
})

ufo.setup({
  provider_selector = function(_, _, _) -- (bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
})

-- }}}
