-- lua_add {{{
local opt = { silent = false, noremap = true } --[[@as vim.keymap.set.Opts]]
require("user.utils").keymaps_set({
    { -- ddt prefix
        mode = "n",
        lhs = [[ s]],
        rhs = [[<Plug>(ddt)]],
        opts = {},
    },
    { -- experimental ddt-ui-shell
        mode = "n",
        lhs = [[<Plug>(ddt)S]],
        rhs = function()
            vim.fn["ddt#start"]({ ui = "shell" })
        end,
        opts = opt,
    },
    { -- floating window terminal at default
        mode = "n",
        lhs = [[<Plug>(ddt)a]],
        rhs = function()
            vim.fn["ddt#start"]({
                ui = "terminal",
                name = table.concat({ "terminal", "default" }, "-"),
            })
        end,
        opts = opt,
    },
    { -- TODO:open floating terminal from current buffer file directory
        mode = "n",
        lhs = [[<Plug>(ddt)s]],
        rhs = function()
            vim.fn["ddt#start"]({
                ui = "terminal",
                name = table.concat({ "terminal", vim.fn.bufnr("%") }, "-"),
                uiParams = {
                    terminal = {
                        cwd = vim.fn.expand("%:h"),
                    },
                },
            })
        end,
        opts = opt,
    },
    { -- TODO:claude
        mode = "n",
        lhs = [[<Plug>(ddt)c]],
        rhs = function()
            vim.cmd.tabnew()
            local prompt_bufnr = vim.fn.bufadd("prompt://claude.md")
            vim.iter({
                ["&buftype"] = "nofile",
                ["&swapfile"] = false,
                ["&buflisted"] = true,
                ["&filetype"] = "markdown",
            }):each(
                ---@param varname string
                ---@param val any
                function(varname, val)
                    vim.fn.setbufvar(prompt_bufnr, varname, val)
                end
            )
            local current_winid = vim.fn.win_getid()
            vim.api.nvim_win_set_buf(current_winid, prompt_bufnr)
            vim.fn["ddt#start"]({
                ui = "terminal",
                name = "claude",
            })
            vim.cmd("sleep 1")
            vim.api.nvim_set_current_win(current_winid)
        end,
        opts = opt,
    },
})
vim.fn["ddt#custom#load_config"](
    -- $HOOKS_DIR/ddt/config.ts
    vim.fs.joinpath(require("user.rc").hooks_dir, "ddt", "config.ts")
)
vim.api.nvim_create_user_command("Ddt", function()
    vim.fn["ddt#start"]({
        ui = "terminal",
        name = "full-terminal",
    })
end, {})
-- }}}

-- lua_source {{{
-- }}}
