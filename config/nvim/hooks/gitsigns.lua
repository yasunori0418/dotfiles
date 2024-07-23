-- lua_add {{{
local dpp = require("dpp")
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufWritePost" }, {
    pattern = "*",
    callback = function(args)
        if dpp.get("gitsigns.nvim").sourced then
            vim.api.nvim_del_autocmd(args.id)
            return
        end

        local current_file = vim.fn.fnamemodify(args.file, ":p")
        local is_diff_file = false
        local repo_root = require("user.utils").search_repo_root()
        local diff_files = vim.fn.systemlist("git diff --name-only 2> /dev/null")
        for _, diff_file in pairs(diff_files) do
            if repo_root .. "/" .. diff_file == current_file then
                is_diff_file = true
            end
        end

        if vim.wo.diff or is_diff_file then
            dpp.source("gitsigns.nvim")
            vim.api.nvim_del_autocmd(args.id)
        end
    end,
})
-- }}}

-- lua_source {{{
local gitsigns = require("gitsigns")
local helper = require("user.plugins.gitsigns")

gitsigns.setup({
    signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },
    signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },
    signs_staged_enable = true,

    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    show_deleted = false,
    watch_gitdir = {
        enable = true,
        follow_files = true,
    },
    diff_opts = {
        algorithm = "histogram",
        internal = true,
        indent_heuristic = true,
        vertical = true,
        linematch = 60,
    },
    auto_attach = true,
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
        delay = 3000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = function(name, blame_info)
        return helper.blame_line_formatter(name, blame_info)
    end,
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 10000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },

    on_attach = function(bufnr)
        helper.keymaps_set(bufnr)
    end,
})
-- }}}
