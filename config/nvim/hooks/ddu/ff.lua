-- lua_ddu-ff {{{
local ddu_helper = require("user.plugins.ddu")
local do_action = vim.fn["ddu#ui#do_action"]
local line = vim.fn.line

local ff_opt = { silent = true, buffer = true, noremap = true }
require("user.utils").keymaps_set({
    -- dummy source jump of cursor
    { -- j
        mode = "n",
        lhs = [[j]],
        rhs = function()
            if line(".") == line("$") then
                vim.cmd("normal! gg")
            else
                ddu_helper.move_ignore_dummy(1)
            end
        end,
        opts = ff_opt,
    },
    { -- k
        mode = "n",
        lhs = [[k]],
        rhs = function()
            if line(".") == 1 then
                vim.cmd("normal! G")
            else
                ddu_helper.move_ignore_dummy(-1)
            end
        end,
        opts = ff_opt,
    },

    -- Open
    { -- defaultAction
        mode = "n",
        lhs = [[<CR>]],
        rhs = function()
            do_action("itemAction")
        end,
        opts = ff_opt,
    },
    { -- expand directory at selected.
        mode = "n",
        lhs = [[o]],
        rhs = function()
            do_action([[expandItem]], { mode = [[toggle]] })
        end,
        opts = ff_opt,
    },
    { -- expand all directories recursively
        mode = "n",
        lhs = [[O]],
        rhs = function()
            do_action([[expandItem]], { maxLevel = -1 })
        end,
        opts = ff_opt,
    },
    { -- :split
        mode = "n",
        lhs = [[s]],
        rhs = function()
            do_action("itemAction", {
                name = [[open]],
                params = { command = [[split]] },
            })
        end,
        opts = ff_opt,
    },
    { -- :vsplit
        mode = "n",
        lhs = [[v]],
        rhs = function()
            do_action("itemAction", {
                name = [[open]],
                params = { command = [[vsplit]] },
            })
        end,
        opts = ff_opt,
    },
    { -- :tabedit
        mode = "n",
        lhs = [[t]],
        rhs = function()
            do_action("itemAction", {
                name = [[open]],
                params = { command = [[tabedit]] },
            })
        end,
        opts = ff_opt,
    },

    -- Support
    { -- toggleSelectItem
        mode = "n",
        lhs = [[  ]],
        rhs = function()
            do_action("toggleSelectItem")
        end,
        opts = ff_opt,
    },
    { -- toggleAllItems
        mode = "n",
        lhs = [[*]],
        rhs = function()
            do_action("toggleAllItems")
        end,
        opts = ff_opt,
    },
    { -- chooseAction
        mode = "n",
        lhs = [[a]],
        rhs = function()
            do_action("chooseAction")
        end,
        opts = ff_opt,
    },
    { -- openFilterWindow
        mode = "n",
        lhs = [[i]],
        rhs = function()
            do_action("openFilterWindow")
        end,
        opts = ff_opt,
    },
    { -- refreshItems
        mode = "n",
        lhs = [[<C-l>]],
        rhs = function()
            do_action("refreshItems")
        end,
        opts = ff_opt,
    },
    { -- preview
        mode = "n",
        lhs = [[p]],
        rhs = function()
            do_action("togglePreview")
        end,
        opts = ff_opt,
    },
    { -- quit
        mode = "n",
        lhs = [[q]],
        rhs = function()
            do_action("quit")
        end,
        opts = ff_opt,
    },
    { -- quit
        mode = "n",
        lhs = [[<ESC>]],
        rhs = function()
            do_action("quit")
        end,
        opts = ff_opt,
    },
    { -- 全てをquickfix送り
        mode = "n",
        lhs = [[<C-q>]],
        rhs = function()
            do_action("toggleAllItems")
            do_action("itemAction", { name = [[quickfix]] })
        end,
        opts = ff_opt,
    },
    { -- 対象のパスをyankする
        mode = "n",
        lhs = [[y]],
        rhs = function()
            do_action("yank")
            print('Yank path the "' .. vim.fn.getreg("+") .. '"')
        end,
        opts = ff_opt,
    },
    { -- debug print of current item.
        mode = "n",
        lhs = [[<F2>]],
        rhs = function()
            vim.print(vim.fn["ddu#ui#get_item"]())
        end,
        opts = ff_opt,
    },
})
-- }}}
