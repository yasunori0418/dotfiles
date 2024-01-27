-- lua_add {{{
local opt = { noremap = false }
require("user.utils").keymaps_set({
    -- {
    --     mode = "n",
    --     lhs = [[ r]],
    --     rhs = [[<Plug>(dap)]],
    --     opts = opt,
    -- },
    -- {
    --     mode = "n",
    --     lhs = [[<Plug>(dap)]],
    --     rhs = function()
    --         -- various
    --     end,
    --     opts = opt,
    -- },
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
