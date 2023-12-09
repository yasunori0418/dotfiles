-- lua_add {{{
require("user.utils").autocmd_set("CmdlineEnter", "*", function()
    require("user.plugins.ddc").cmdline_completion()
end)
-- }}}

-- lua_source {{{
local pum_insert_relative = vim.fn["pum#map#insert_relative"]
local pum_select_relative = vim.fn["pum#map#select_relative"]
local pum_confirm = vim.fn["pum#map#confirm"]
local pum_cancel = vim.fn["pum#map#cancel"]
local pum_visible = vim.fn["pum#visible"]
local ddc_manual_complete = vim.fn["ddc#map#manual_complete"]
local ddc_hide = vim.fn["ddc#hide"]

-- Source options.
local joinpath = vim.fs.joinpath
local ddc_hooks = joinpath(vim.g.hooks_dir, "ddc")
vim.fn["ddc#custom#load_config"](
    -- $HOOKS_DIR/ddc/config.ts
    joinpath(ddc_hooks, "config.ts")
)

---ddc手動補完のソース指定を楽チンにするやつ
-- https://github.com/4513ECHO/dotfiles/blob/73f2f46/config/nvim/dein/settings/ddc.vim#L163-L175
---@param ... string ddc-source name
local ddc_complete = function(...)
    vim.fn["ddc#map#manual_complete"]({ sources = { ... } })
end

-- Keymaping
local expr_opt = { expr = true, noremap = true }
local opt = { noremap = true }
require("user.utils").keymaps_set({
    { -- i_<C-n>
        mode = "i",
        lhs = [[<C-n>]],
        rhs = function()
            if pum_visible() then
                pum_insert_relative(1)
            end
        end,
        opts = opt,
    },
    { -- i_<C-p>
        mode = "i",
        lhs = [[<C-p>]],
        rhs = function()
            if pum_visible() then
                pum_insert_relative(-1)
            end
        end,
        opts = opt,
    },
    { -- i_<C-y>
        mode = "i",
        lhs = [[<C-y>]],
        rhs = function()
            pum_confirm()
        end,
        opts = opt,
    },
    { -- i_<C-e>
        mode = "i",
        lhs = [[<C-e>]],
        rhs = function()
            if pum_visible() then
                pum_cancel()
            else
                return [[<C-G>U<End>]]
            end
        end,
        opts = expr_opt,
    },
    { -- i_<C-x><C-l> manual_complete line
        mode = "i",
        lhs = [[<C-x><C-l>]],
        rhs = function()
            ddc_complete("line")
        end,
        opts = opt,
    },
    { -- i_<C-x><C-n> manual_complete around, rg, buffer
        mode = "i",
        lhs = [[<C-x><C-n>]],
        rhs = function()
            ddc_complete("around", "rg", "buffer")
        end,
        opts = opt,
    },
    { -- i_<C-x><C-f> manual_complete file
        mode = "i",
        lhs = [[<C-x><C-f>]],
        rhs = function()
            ddc_complete("file")
        end,
        opts = opt,
    },
    { -- i_<C-x><C-d> manual_complete lsp
        mode = "i",
        lhs = [[<C-x><C-d>]],
        rhs = function()
            ddc_complete("nvim-lsp")
        end,
        opts = opt,
    },
    { -- i_<C-x><C-v> manual_complete necovim, nvim-lua, cmdline
        mode = "i",
        lhs = [[<C-x><C-v>]],
        rhs = function()
            ddc_complete("necovim", "nvim-lua", "cmdline")
        end,
        opts = opt,
    },
    { -- i_<C-x><C-s> manual_complete vsnip
        mode = "i",
        lhs = [[<C-x><C-s>]],
        rhs = function()
            ddc_complete("vsnip")
        end,
        opts = opt,
    },
    { -- i_<C-x><C-u> manual_complete
        mode = "i",
        lhs = [[<C-x><C-u>]],
        rhs = function()
            ddc_manual_complete()
        end,
        opts = opt,
    },

    -- commandline completion keymapping
    { -- c_<C-n>
        mode = "c",
        lhs = [[<Tab>]],
        rhs = function()
            if pum_visible() then
                pum_insert_relative(1)
            else
                ddc_manual_complete()
            end
        end,
        opts = opt,
    },
    { -- c_<C-p>
        mode = "c",
        lhs = [[<S-Tab>]],
        rhs = function()
            pum_insert_relative(-1)
        end,
        opts = opt,
    },
    { -- c_<C-y>
        mode = "c",
        lhs = [[<C-y>]],
        rhs = function()
            pum_confirm()
        end,
        opts = opt,
    },
    { -- c_<C-e>
        mode = "c",
        lhs = [[<C-e>]],
        rhs = function()
            if pum_visible() then
                ddc_hide()
            else
                return [[<END>]]
            end
        end,
        opts = expr_opt,
    },

    -- deol completion keymapping
    { -- t_<C-t> これはリファレンス実装。意図は分かっていない…
        mode = "t",
        lhs = [[<C-t>]],
        rhs = [[<Tab>]],
        opts = opt,
    },
    { -- t_<Tab> completion select
        mode = "t",
        lhs = [[<Tab>]],
        rhs = function()
            if pum_visible() then
                pum_select_relative(1)
            else
                return [[<Tab>]]
            end
        end,
        opts = expr_opt,
    },
    { -- t_<S-Tab> completion select with reverse curosor move
        mode = "t",
        lhs = [[<S-Tab>]],
        rhs = function()
            if pum_visible() then
                pum_select_relative(-1)
            else
                return [[<S-Tab>]]
            end
        end,
        opts = expr_opt,
    },
    { -- t_<C-y> completion confirm
        mode = "t",
        lhs = [[<C-y>]],
        rhs = function()
            if pum_visible() then
                pum_confirm()
            else
                return [[<C-y>]]
            end
        end,
        opts = expr_opt,
    },
    { -- t_<C-i> completion cancel
        mode = "t",
        lhs = [[<C-i>]],
        rhs = function()
            if pum_visible() then
                pum_cancel()
            else
                return [[<C-i>]]
            end
        end,
        opts = expr_opt,
    },
})

vim.fn['ddc#enable_terminal_completion']()
vim.fn['ddc#enable']({ context_filetype = [[treesitter]] })
-- }}}
