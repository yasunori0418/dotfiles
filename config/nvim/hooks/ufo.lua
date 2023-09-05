-- lua_source {{{
-- The following settings must be made in nvim-ufo.
vim.opt.foldmethod = "manual"
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

local ufo = require("ufo")

require("user.utils").keymaps_set({
  { -- zR
    mode = "n",
    lhs = [[zR]],
    rhs = ufo.openAllFolds,
    opts = {},
  },
  { -- zM
    mode = "n",
    lhs = [[zM]],
    rhs = ufo.closeAllFolds,
    opts = {},
  },
  { -- zr
    mode = "n",
    lhs = [[zr]],
    rhs = ufo.openFoldsExceptKinds,
    opts = {},
  },
  { -- zm
    mode = "n",
    lhs = [[zm]],
    rhs = ufo.closeFoldsWith,
    opts = {},
  },
  { -- zj
    mode = "n",
    lhs = [[zj]],
    rhs = ufo.goNextClosedFold,
    opts = {},
  },
  { -- zk
    mode = "n",
    lhs = [[zk]],
    rhs = ufo.goPreviousClosedFold,
    opts = {},
  },
})

ufo.setup({
  provider_selector = function(_, _, _) -- (bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
})

-- }}}
