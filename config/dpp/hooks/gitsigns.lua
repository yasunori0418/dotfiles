-- lua_add {{{
local dein = require("dein")
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufWritePost" }, {
    pattern = "*",
    callback = function(args)
        if dein.is_sourced("gitsigns.nvim") then
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
            dein.source("gitsigns.nvim")
            vim.api.nvim_del_autocmd(args.id)
        end
    end,
})
-- }}}

-- lua_source {{{
local gitsigns = require("gitsigns")

gitsigns.setup({
    signs = {
        add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        untracked = { hl = "GitSignsAdd", text = "┆", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    },

    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        interval = 1000,
        follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
    yadm = {
        enable = false,
    },

    on_attach = function(bufnr)
        local keymap = vim.keymap.set
        local keymap_options = { noremap = true, buffer = bufnr, expr = true }

        -- Navigation
        keymap("n", "[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gitsigns.prev_hunk()
            end)
            return "<Ignore>"
        end, keymap_options)

        keymap("n", "]c", function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                gitsigns.next_hunk()
            end)
            return "<Ignore>"
        end, keymap_options)

        keymap("n", "ghs", "<Cmd>Gitsigns stage_hunk<CR>")
        keymap("n", "ghr", "<Cmd>Gitsigns reset_hunk<CR>")
        keymap("n", "ghu", "<Cmd>Gitsigns undo_stage_hunk<CR>")
        keymap("x", "ghs", ":Gitsigns stage_hunk<CR>")
        keymap("x", "ghr", ":Gitsigns reset_hunk<CR>")
        keymap("x", "ghu", ":Gitsigns undo_stage_hunk<CR>")
        keymap("n", "gbs", "<Cmd>Gitsigns stage_buffer<CR>")
        keymap("n", "gbr", "<Cmd>Gitsigns reset_buffer<CR>")
        keymap("n", "gbu", "<Cmd>Gitsigns undo_stage_hunk<CR>")
    end,
})
-- }}}
