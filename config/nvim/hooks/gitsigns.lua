-- lua_source {{{
local gitsigns = require("gitsigns")

gitsigns.setup({
  signs = {
    add =           { hl = "GitSignsAdd",     text = "+", numhl = "GitSignsAddNr",    linehl = "GitSignsAddLn"    },
    change =        { hl = "GitSignsChange",  text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete =        { hl = "GitSignsDelete",  text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete =     { hl = "GitSignsDelete",  text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete =  { hl = "GitSignsChange",  text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    untracked =     { hl = "GitSignsAdd",     text = "┆", numhl = "GitSignsAddNr",    linehl = "GitSignsAddLn"    },
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

    keymap({"n", "v"}, "ghs", "<Cmd>Gitsigns stage_hunk<CR>")
    keymap({"n", "v"}, "ghr", "<Cmd>Gitsigns reset_hunk<CR>")
    keymap("n", "gbs", "<Cmd>Gitsigns stage_buffer<CR>")
    keymap("n", "gbu", "<Cmd>Gitsigns undo_stage_hunk<CR>")
  end,
})
-- }}}
