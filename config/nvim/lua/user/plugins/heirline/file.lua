local conditions = require("heirline.conditions")
-- local utils = require("heirline.utils")

local icon = {
    provider = function(self)
        return self.icon
    end,
    hl = function(self)
        return { fg = self.icon_color }
    end,
}

local name = {
    provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then
            return " [No Name]"
        end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename
    end,
}

local flags = {
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

return {
    condition = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return vim.fn.empty(vim.fn.fnamemodify(filename, "%:t")) == 0
    end,
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
    icon,
    name,
    flags,
}
