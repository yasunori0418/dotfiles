-- lua_add {{{
local utils = require("user.utils")
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
      require(dial_map).manipulate("increment", "gnormal")
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
    mode = "v",
    lhs = [[<C-a>]],
    rhs = function()
      require(dial_map).manipulate("increment", "visual")
    end,
    opts = opt,
  },
  {
    mode = "v",
    lhs = [[<C-x>]],
    rhs = function()
      require(dial_map).manipulate("decrement", "visual")
    end,
    opts = opt,
  },
  {
    mode = "v",
    lhs = [[g<C-a>]],
    rhs = function()
      require(dial_map).manipulate("increment", "gvisual")
    end,
    opts = opt,
  },
  {
    mode = "v",
    lhs = [[g<C-x>]],
    rhs = function()
      require(dial_map).manipulate("decrement", "gvisual")
    end,
    opts = opt,
  },
})
-- }}}

-- lua_source {{{
local augend = require("dial.augend")
require("dial.config").augends:register_group({
  default = {
    augend.constant.new({
      elements = { "true", "false" },
      word = true,
      cyclic = true,
    }),
  },
})
-- }}}
