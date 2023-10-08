local M = {}

local utils = require("user.utils")
local create_option = require("user.plugins.deol.utils").create_option

function M.lua_add()
    local opt = { silent = true, noremap = true }
    utils.keymaps_set({
        { -- leave term insert mode.
            mode = "t",
            lhs = [[<Esc><Esc>]],
            rhs = [[<C-\><C-n>]],
            opts = opt,
        },
        { -- term prefix
            mode = "n",
            lhs = [[ s]],
            rhs = [[<Plug>(term)]],
            opts = {},
        },
        { -- project root term
            mode = "n",
            lhs = [[<Plug>(term)a]],
            rhs = function()
                vim.cmd({
                    cmd = "execute",
                    args = create_option(utils.search_repo_root()),
                })
            end,
            opts = opt,
        },
        { -- project root term
            mode = "n",
            lhs = [[<Plug>(term)s]],
            rhs = function()
                vim.cmd({
                    cmd = "execute",
                    args = create_option(utils.search_repo_root(), ""),
                })
            end,
            opts = opt,
        },
        { -- current buffer term
            mode = "n",
            lhs = [[<Plug>(term)c]],
            rhs = function()
                vim.cmd({
                    cmd = "execute",
                    args = create_option(vim.fn.fnamemodify(vim.fn.expand("%"), ":h")),
                })
            end,
            opts = opt,
        },
        { -- $HOME term
            mode = "n",
            lhs = [[<Plug>(term)~]],
            rhs = function()
                vim.cmd({
                    cmd = "execute",
                    args = create_option("~"),
                })
            end,
            opts = opt,
        },
        { -- tab term
            mode = "n",
            lhs = [[<Plug>(term)t]],
            rhs = function()
                vim.cmd.tabnew()
                vim.cmd({
                    cmd = "execute",
                    args = create_option(utils.search_repo_root(), ""),
                })
            end,
            opts = opt,
        },
    })
end

function M.lua_source()
    vim.g["deol#external_history_path"] = vim.fn.expand("~/.zhistory")
    vim.g["deol#nvim_server"] = "~/.cache/nvim/server.pipe"
    vim.g["deol#custom_map"] = { edit = "" }
    vim.g["deol#floating_border"] = "single"
    vim.g["deol#enable_dir_changed"] = false
    vim.g["deol#prompt_pattern"] = "❯ "
end

return M
