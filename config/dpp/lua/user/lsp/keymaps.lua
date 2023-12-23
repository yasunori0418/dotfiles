local lsp = vim.lsp -- nvim lsp api.
local diagnostic = vim.diagnostic
local user_lsp_util = require("user.lsp.utils")
local utils = require("user.utils")

user_lsp_util.on_attach(function(_, buffer)
    local opt = { noremap = true, silent = true, buffer = buffer }
    utils.keymaps_set({
        { mode = { "n", "x" }, lhs = [[ l]], rhs = [[<Plug>(lsp)]], opts = opt },
        { mode = { "n" }, lhs = [[K]], rhs = lsp.buf.hover, opts = opt },
        { mode = { "n" }, lhs = [[<Plug>(lsp)q]], rhs = user_lsp_util.format, opts = opt },
        { mode = { "n" }, lhs = [[<Plug>(lsp)r]], rhs = lsp.buf.rename, opts = opt },
        { mode = { "n" }, lhs = [[ge]], rhs = diagnostic.open_float, opts = opt },
        { mode = { "n" }, lhs = [=[[d]=], rhs = diagnostic.goto_prev, opts = opt },
        { mode = { "n" }, lhs = [=[]d]=], rhs = diagnostic.goto_next, opts = opt },
        { -- ddu lsp:definition_all
            mode = { "n" },
            lhs = [[<Plug>(lsp)D]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:definition_all",
                })
            end,
            opts = opt,
        },
        { -- ddu lsp:finder
            mode = { "n" },
            lhs = [[<Plug>(lsp)f]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:finder",
                })
            end,
            opts = opt,
        },
        { -- lsp:definition
            mode = { "n" },
            lhs = [[gd]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:definition",
                })
            end,
            opts = opt,
        },
        { -- lsp:declaration
            mode = { "n" },
            lhs = [[gD]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:declaration",
                })
            end,
            opts = opt,
        },
        { -- lsp:typeDefinition
            mode = { "n" },
            lhs = [[gt]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:typeDefinition",
                })
            end,
            opts = opt,
        },
        { -- lsp:implementation
            mode = { "n" },
            lhs = [[gi]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:implementation",
                })
            end,
            opts = opt,
        },
        { -- lsp:references
            mode = { "n" },
            lhs = [[gr]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:references",
                })
            end,
            opts = opt,
        },
        { -- lsp:documentSymbol
            mode = "n",
            lhs = [[<Plug>(lsp)s]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:documentSymbol",
                })
            end,
            opts = opt,
        },
        { -- lsp:workspaceSymbol
            mode = "n",
            lhs = [[<Plug>(lsp)S]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:workspaceSymbol",
                })
            end,
            opts = opt,
        },
        { -- lsp:incomingCalls
            mode = "n",
            lhs = [[<Plug>(lsp)c]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:incomingCalls",
                })
            end,
            opts = opt,
        },
        { -- lsp:outgoingCalls
            mode = "n",
            lhs = [[<Plug>(lsp)C]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:outgoingCalls",
                })
            end,
            opts = opt,
        },
        { -- lsp:supertypes
            mode = "n",
            lhs = [[<Plug>(lsp)t]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:supertypes",
                })
            end,
            opts = opt,
        },
        { -- lsp:subtypes
            mode = "n",
            lhs = [[<Plug>(lsp)T]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:subtypes",
                })
            end,
            opts = opt,
        },
        { -- ddu lsp:codeAction
            mode = { "n", "x" },
            lhs = [[ga]],
            rhs = [[<Cmd>call ddu#start(#{name: "lsp:codeAction"})<CR>]],
            opts = opt,
        },
        { -- ddu lsp:diagnostics
            mode = "n",
            lhs = [[<Plug>(lsp)d]],
            rhs = function()
                vim.fn['ddu#start']({
                    name = "lsp:diagnostics",
                })
            end,
            opts = opt,
        },
    })

    -- pcall(lsp.inlay_hint, buffer, nil)
end)

