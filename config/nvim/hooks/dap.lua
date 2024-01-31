-- lua_add {{{
local opt = { noremap = false }
require("user.utils").keymaps_set({
    {
        mode = "n",
        lhs = [[ r]],
        rhs = [[<Plug>(dap)]],
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<Plug>(dap)b]],
        rhs = function()
            require("dap").toggle_breakpoint()
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<Plug>(dap)B]],
        rhs = function()
            require("dap").set_breakpoint()
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<Plug>(dap)lp]],
        rhs = function()
            require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<Plug>(dap)C]],
        rhs = function()
            require("dap").clear_breakpoints()
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<Plug>(dap)L]],
        rhs = function()
            require("dap").list_breakpoints()
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<Plug>(dap)dr]],
        rhs = function()
            require("dap").repl.toggle()
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<Plug>(dap)dl]],
        rhs = function()
            require("dap").run_last()
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<F5>]],
        rhs = function()
            require("dap").continue()
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<F10>]],
        rhs = function()
            require("dap").step_over()
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<F11>]],
        rhs = function()
            require("dap").step_into()
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<F12>]],
        rhs = function()
            require("dap").step_out()
        end,
        opts = opt,
    },
    {
        mode = "n",
        lhs = [[<F3>]],
        rhs = function()
            require("dapui").toggle()
        end,
        opts = opt,
    },
})
-- }}}

-- lua_source {{{

-- }}}
