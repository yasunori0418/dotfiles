-- lua_add {{{
local utils = require('user.utils')
local opt = { silent = true, noremap = true }
local dial_map = "dial.map"

utils.keymaps_set({
  {
    mode = "n",
    lhs = [[<C-a>]],
    rhs = function()
      require(dial_map).manipulate("increment", "normal")
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[<C-x>]],
    rhs = function()
      require(dial_map).manipulate("decrement", "normal")
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[g<C-a>]],
    rhs = function()
      require(dial_map).manipulate("decrement", "gnormal")
    end,
    opts = opt,
  },
  {
    mode = "n",
    lhs = [[g<C-x>]],
    rhs = function()
      require(dial_map).manipulate("decrement", "gnormal")
    end,
    opts = opt,
  },
  {
    mode = "x",
    lhs = [[<C-a>]],
    rhs = function()
      require(dial_map).manipulate("increment", "visual")
    end,
    opts = opt,
  },
  {
    mode = "x",
    lhs = [[<C-x>]],
    rhs = function()
      require(dial_map).manipulate("decrement", "visual")
    end,
    opts = opt,
  },
  {
    mode = "x",
    lhs = [[g<C-a>]],
    rhs = function()
      require(dial_map).manipulate("decrement", "gvisual")
    end,
    opts = opt,
  },
  {
    mode = "x",
    lhs = [[g<C-x>]],
    rhs = function()
      require(dial_map).manipulate("decrement", "gvisual")
    end,
    opts = opt,
  },
})
-- }}}

-- lua_source {{{

-- }}}
