-- We're getting minimalists here!
local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    provider = "%7(%l/%L%):%2c ",
}

-- I take no credits for this! :lion:
local ScrollBar = {
    static = {
        sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
        -- Another variant, because the more choice the better.
        -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
    },
    provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return string.rep(self.sbar[i], 2) .. " "
    end,
    hl = function(self)
        return { fg = self.mode_colors.base,  bg = "bg0", bold = true }
    end,
}

return {
    Ruler,
    -- ScrollBar,
}
