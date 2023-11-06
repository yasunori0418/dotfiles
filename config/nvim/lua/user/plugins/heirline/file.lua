local M = {}
local devicons = require("nvim-web-devicons")
-- local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local init = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
        self.extension = vim.fn.fnamemodify(self.filename, ":e")
        self.icon, self.icon_color = devicons.get_icon_color(self.filename, self.extension, { default = true })
    end,
}

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
        if filename == "" or filename == nil then
            return "[No Name]"
        end
        return filename
    end,
    hl = { fg = "bg0" },
}

M.NameBlock = utils.insert(
    init,
    utils.surround({ "\u{e0b6}", "\u{e0b4}" }, "fg2", {
        icon,
        name,
    })
)

local type = {
    provider = function()
        return " ft=" .. vim.bo.filetype
    end,
}

local encoding = {
    provider = function()
        local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
        return ":enc=" .. enc
    end,
}

local format = {
    provider = function()
        return ":ff=" .. vim.bo.fileformat
    end,
}

M.InfoBlock = {
    type,
    encoding,
    format,
}

return M
