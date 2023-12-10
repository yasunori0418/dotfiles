-- lua_add {{{
local utils = require("user.utils")

---@alias deol_split_kinds
---| "" # No split
---| "floating" # Use neovim floating window feature
---| "vertical" # Split buffer vertically
---| "farleft" # Split buffer far left, like |CTRL-W_H|
---| "farright" # Split buffer far right, like |CTRL-W_L|
---| "horizontal" # Split buffer horizontally

---@param path? string default: require("user.utils").search_repo_root()
---@param split? deol_split_kinds default: 'floating'
---@param magnification? integer default: 1
local function deol_open(path, split, magnification)
    path = path or utils.search_repo_root()
    split = split or "floating"
    magnification = magnification or 1

    local winheight = ""
    if vim.regex([[floating\|horizontal]]):match_str(split) then
        winheight = vim.fn.float2nr(vim.opt.lines:get() / magnification)
    end

    local winwidth = ""
    if vim.regex([[floating\|vertical\|farleft\|farright]]):match_str(split) then
        winwidth = vim.fn.float2nr(vim.opt.columns:get() / magnification)
    end

    local options = {
        auto_cd = false,
        cwd = path,
        dir_changed = false,
        edit = false,
        split = split,
        start_insert = false,
        toggle = true,
        winheight = winheight,
        winwidth = winwidth,
    }

    vim.fn["deol#start"](options)
end

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
            deol_open()
        end,
        opts = opt,
    },
    { -- current buffer term
        mode = "n",
        lhs = [[<Plug>(term)c]],
        rhs = function()
            deol_open(vim.fn.fnamemodify(tostring(vim.fn.expand("%")), ":h"))
        end,
        opts = opt,
    },
    { -- $HOME term
        mode = "n",
        lhs = [[<Plug>(term)~]],
        rhs = function()
            deol_open("~")
        end,
        opts = opt,
    },
    { -- tab term
        mode = "n",
        lhs = [[<Plug>(term)t]],
        rhs = function()
            vim.cmd.tabnew()
            deol_open(nil, "")
        end,
        opts = opt,
    },
})
-- }}}

-- lua_source {{{
vim.g["deol#external_history_path"] = vim.fn.expand("~/.zhistory")
vim.g["deol#nvim_server"] = "~/.cache/nvim/server.pipe"
vim.g["deol#custom_map"] = { edit = "" }
vim.g["deol#floating_border"] = "single"
vim.g["deol#enable_dir_changed"] = false
vim.g["deol#prompt_pattern"] = "❯ "
-- }}}
