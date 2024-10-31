---@type vim.keymap.set.Opts
local opt = { silent = true, noremap = true }

require("user.utils").keymaps_set({
    ---disable keymaps
    -- `s` and `S` same is `cl`, `cc` and `C` "
    {
        mode = { "n", "x" },
        lhs = [[s]],
        rhs = [[<Nop>]],
        opts = opt,
    },
    {
        mode = { "n", "x" },
        lhs = [[S]],
        rhs = [[<Nop>]],
        opts = opt,
    },

    -- unuse marker
    {
        mode = { "n", "x" },
        lhs = [[m]],
        rhs = [[<Nop>]],
        opts = opt,
    },
    {
        mode = { "n", "x" },
        lhs = [[']],
        rhs = [[<Nop>]],
        opts = opt,
    },
    {
        mode = { "n", "x" },
        lhs = [[`]],
        rhs = [[<Nop>]],
        opts = opt,
    },

    { -- disable move left after space
        mode = { "n", "x" },
        lhs = [[<Space>]],
        rhs = [[<Nop>]],
        opts = opt,
    },

    ---Window control keymaps
    {
        mode = { "n" },
        lhs = [[<Space>w]],
        rhs = [[<Plug>(Window)]],
        opts = { noremap = true },
    },

    -- Commands of move between window.
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)h]],
        rhs = [[<C-W>h]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)j]],
        rhs = [[<C-W>j]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)k]],
        rhs = [[<C-W>k]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)l]],
        rhs = [[<C-W>l]],
        opts = opt,
    },

    -- Commands of move window.
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)H]],
        rhs = [[<C-W>H]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)J]],
        rhs = [[<C-W>J]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)K]],
        rhs = [[<C-W>K]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)L]],
        rhs = [[<C-W>L]],
        opts = opt,
    },

    -- Tab page controls.
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)tn]],
        rhs = function()
            vim.cmd.tabnew()
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)tT]],
        rhs = [[<C-W>T]],
        opts = opt,
    },

    { -- Commands of close window.
        mode = { "n" },
        lhs = [[<Plug>(Window)q]],
        rhs = [[<C-W>q]],
        opts = opt,
    },
    { -- easy save. save file only when changed.
        mode = { "n" },
        lhs = [[<Plug>(Window)w]],
        rhs = function()
            vim.cmd.update()
        end,
        opts = opt,
    },

    -- Commands of Window split.
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)s]],
        rhs = [[<C-W>s]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)v]],
        rhs = [[<C-W>v]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)n]],
        rhs = [[<C-W>n]],
        opts = opt,
    },

    -- Window size controls.
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)|]],
        rhs = [[<C-W>|]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)_]],
        rhs = [[<C-W>_]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<Plug>(Window)=]],
        rhs = [[<C-W>=]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<S-Left>]],
        rhs = [[<C-W><]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<S-Right>]],
        rhs = [[<C-W>>]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<S-Up>]],
        rhs = [[<C-W>-]],
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [[<S-Down>]],
        rhs = [[<C-W>+]],
        opts = opt,
    },

    -- QuickFix
    {
        mode = { "n" },
        lhs = [=[[q]=],
        rhs = function()
            vim.cmd.cprevious()
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [=[]q]=],
        rhs = function()
            vim.cmd.cnext()
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [=[[Q]=],
        rhs = function()
            vim.cmd.cfirst()
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [=[]Q]=],
        rhs = function()
            vim.cmd.clast()
        end,
        opts = opt,
    },

    -- Buffer
    {
        mode = { "n" },
        lhs = [=[[b]=],
        rhs = function()
            vim.cmd.bprevious()
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [=[]b]=],
        rhs = function()
            vim.cmd.bnext()
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [=[[B]=],
        rhs = function()
            vim.cmd.bfirst()
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [=[]B]=],
        rhs = function()
            vim.cmd.blast()
        end,
        opts = opt,
    },

    -- Tab
    {
        mode = { "n" },
        lhs = [=[[t]=],
        rhs = function()
            vim.cmd.tabprevious()
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [=[]t]=],
        rhs = function()
            vim.cmd.tabnext()
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [=[[T]=],
        rhs = function()
            vim.cmd.tabfirst()
        end,
        opts = opt,
    },
    {
        mode = { "n" },
        lhs = [=[]T]=],
        rhs = function()
            vim.cmd.tablast()
        end,
        opts = opt,
    },

    -- Do not save the things erased by x and c in the register.
    {
        mode = { "n", "x" },
        lhs = [[x]],
        rhs = [["_x]],
        opts = opt,
    },
    {
        mode = { "n", "x" },
        lhs = [[X]],
        rhs = [["_X]],
        opts = opt,
    },
    {
        mode = { "n", "x" },
        lhs = [[c]],
        rhs = [["_c]],
        opts = opt,
    },
    {
        mode = { "n", "x" },
        lhs = [[C]],
        rhs = [["_C]],
        opts = opt,
    },
    -- Macro record keymap.
    {
        mode = { "n", "x" },
        lhs = [[<C-q>]],
        rhs = [[q]],
        opts = opt,
    },
    {
        mode = { "n", "x" },
        lhs = [[q]],
        rhs = [[<Nop>]],
        opts = opt,
    },

    -- Utils
    {
        mode = { "n" },
        lhs = [[gf]],
        rhs = [[gF]],
        opts = opt,
    },
    {
        mode = { "x" },
        lhs = [[P]],
        rhs = [[p]],
        opts = opt,
    },
    {
        mode = { "x" },
        lhs = [[p]],
        rhs = [[P]],
        opts = opt,
    },
    {
        mode = { "i" },
        lhs = [[jj]],
        rhs = [[<ESC><C-l>]],
        opts = opt,
    },
    {
        mode = { "c" },
        lhs = [[jj]],
        rhs = [[<ESC><C-l>]],
        opts = { noremap = true },
    },
    {
        mode = { "i" },
        lhs = [[<C-l>]],
        rhs = [[<Del>]],
        opts = opt,
    },
    {
        mode = { "c" },
        lhs = [[<C-l>]],
        rhs = [[<Del>]],
        opts = { noremap = true },
    },
    {
        mode = { "i" },
        lhs = [[<C-a>]],
        rhs = [[<C-g>U<Home>]],
        opts = opt,
    },

    -- Cmdline mode cursor move emacs like {{{
    {
        mode = { "c" },
        lhs = [[<C-a>]],
        rhs = [[<Home>]],
        opts = { noremap = true },
    },
    {
        mode = { "c" },
        lhs = [[<C-e>]],
        rhs = [[<End>]],
        opts = { noremap = true },
    },
    {
        mode = { "c" },
        lhs = [[<C-f>]],
        rhs = [[<Right>]],
        opts = { noremap = true },
    },
    {
        mode = { "c" },
        lhs = [[<C-b>]],
        rhs = [[<Left>]],
        opts = { noremap = true },
    },

    -- Operator
    {
        mode = { "o", "x" },
        lhs = [[a']],
        rhs = [[2i']],
        opts = opt,
    },
    {
        mode = { "o", "x" },
        lhs = [[a"]],
        rhs = [[2i"]],
        opts = opt,
    },
    {
        mode = { "o", "x" },
        lhs = [[a`]],
        rhs = [[2i`]],
        opts = opt,
    },
    {
        mode = { "o", "x" },
        lhs = [[a<Space>]],
        rhs = [[aW]],
        opts = opt,
    },
    {
        mode = { "o", "x" },
        lhs = [[i<Space>]],
        rhs = [[iW]],
        opts = opt,
    },
})
