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
local config = require("dial.config")

config.augends:register_group({
  default = {
    augend.constant.alias.bool,
    augend.constant.alias.ja_weekday_full,
    augend.constant.alias.ja_weekday,
    augend.constant.new({
      elements = { "and", "or" },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { "&&", "||" },
      word = false,
      cyclic = true,
    }),
  },
})
-- }}}
