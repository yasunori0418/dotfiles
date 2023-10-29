local conditions = require("heirline.conditions")
-- local utils = require("heirline.utils")

local M = {}

M.Icon = {
    provider = function(self)
        return self.padding_char .. self.icon
    end,
    hl = function(self)
        return { fg = self.icon_color }
    end,
}

M.Name = {
    provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then
            return "[No Name]"
        end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return self.padding_char .. filename .. self.padding_char
    end,
}

M.Flags = {
    {
        condition = function()
            return vim.bo.modified
        end,
        provider = "[+]",
    },
    {
        condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "\u{f023}", -- [[]]
    },
}

return M
