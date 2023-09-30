-- lua_add {{{
local utils = require("user.utils")
local opt = { silent = true, noremap = true }
local dial_map = "dial.map"

utils.keymaps_set({
    { -- Ctrl-a
        mode = "n",
        lhs = [[<C-a>]],
        rhs = function()
            require(dial_map).manipulate("increment", "normal")
        end,
        opts = opt,
    },
    { -- Ctrl-x
        mode = "n",
        lhs = [[<C-x>]],
        rhs = function()
            require(dial_map).manipulate("decrement", "normal")
        end,
        opts = opt,
    },
    { -- g_Ctrl-a
        mode = "n",
        lhs = [[g<C-a>]],
        rhs = function()
            require(dial_map).manipulate("increment", "gnormal")
        end,
        opts = opt,
    },
    { -- g_Ctrl-x
        mode = "n",
        lhs = [[g<C-x>]],
        rhs = function()
            require(dial_map).manipulate("decrement", "gnormal")
        end,
        opts = opt,
    },
    { -- v_Ctrl-a
        mode = "v",
        lhs = [[<C-a>]],
        rhs = function()
            require(dial_map).manipulate("increment", "visual")
        end,
        opts = opt,
    },
    { -- v_Ctrl-x
        mode = "v",
        lhs = [[<C-x>]],
        rhs = function()
            require(dial_map).manipulate("decrement", "visual")
        end,
        opts = opt,
    },
    { -- v_g_Ctrl-a
        mode = "v",
        lhs = [[g<C-a>]],
        rhs = function()
            require(dial_map).manipulate("increment", "gvisual")
        end,
        opts = opt,
    },
    { -- v_g_Ctrl-x
        mode = "v",
        lhs = [[g<C-x>]],
        rhs = function()
            require(dial_map).manipulate("decrement", "gvisual")
        end,
        opts = opt,
    },
    { -- vimの中でCtrl-cとか使わないよね？(煽り)
        mode = "n",
        lhs = [[<C-c>]],
        rhs = function()
            require(dial_map).manipulate("increment", "normal", "case")
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
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.new({
            pattern = "%Y/%m/%d",
            default_kind = "day",
        }),
        augend.date.new({
            pattern = "%Y-%m-%d",
            default_kind = "day",
        }),
        augend.date.new({
            pattern = "%m/%d",
            default_kind = "day",
            only_valid = true,
        }),
        augend.date.new({
            pattern = "%H:%M",
            default_kind = "day",
            only_valid = true,
        }),
        augend.constant.alias.ja_weekday_full,
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
        augend.constant.new({
            elements = { "yes", "no" },
            word = true,
            cyclic = true,
        }),
    },
    case = {
        augend.case.new({
            types = { "camelCase", "snake_case", "kebab-case", "PascalCase" },
        }),
    },
})
-- }}}
