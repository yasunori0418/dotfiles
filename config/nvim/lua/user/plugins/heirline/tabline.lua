local devicons = require("nvim-web-devicons")
local utils = require("heirline.utils")

local bufnr = {
    provider = function(self)
        return tostring(self.bufnr) .. ". "
    end,
    hl = "comment",
}

local file_icon = {
    provider = function(self)
        return self.icon
    end,
    hl = function(self)
        return { fg = self.icon_color }
    end,
}

local file_name = { -- file_name
    provider = function(self)
        return self.filename == "" and "[No Name]" or vim.fn.fnamemodify(self.filename, ":t")
    end,
    hl = function(self)
        return { bold = self.is_active or self.is_visible, italic = true }
    end,
}

local file_flags = {
    { -- modifiable
        condition = function(self)
            return vim.api.nvim_get_option_value("modifiable", {
                buf = self.bufnr,
            })
        end,
        provider = "[+]",
        hl = { fg = "green_base" },
    },
    { -- readonly or terminal
        condition = function(self)
            local is_modifiable = vim.api.nvim_get_option_value("modifiable", {
                buf = self.bufnr,
            })
            local is_readonly = vim.api.nvim_get_option_value("readonly", {
                buf = self.bufnr,
            })
            return not is_modifiable or is_readonly
        end,
        provider = function(self)
            if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
                return "  "
            else
                return ""
            end
        end,
        hl = { fg = "orange_base" },
    },
}

local file_name_block = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
        self.extension = vim.fn.fnamemodify(self.filename, ":e")
        self.icon, self.icon_color = devicons.get_icon_color(self.filename, self.extension, { default = true })
    end,
    hl = function(self)
        if self.is_active then
            return "TabLineSel"
        else
            return "TabLine"
        end
    end,
    on_click = {
        callback = function(_, minwid, _, _)
            vim.api.nvim_win_set_buf(0, minwid)
        end,
        minwid = function(self)
            return self.bufnr
        end,
        name = "heirline_tabline_buffer_callback",
    },
    bufnr,
    file_icon,
    file_name,
    file_flags,
}

-- The final touch!
local TablineBufferBlock = utils.surround({ "\u{e0ba}", "\u{e0b8}" }, function(self)
    if self.is_active then
        return utils.get_highlight("TabLineSel").bg
    else
        return utils.get_highlight("TabLine").bg
    end
end, { file_name_block })

-- and here we go
local BufferLine = utils.make_buflist(
    TablineBufferBlock,
    { provider = "", hl = { fg = "black_dim" } }, -- left truncation, optional (defaults to "<")
    { provider = "", hl = { fg = "black_dim" } } -- right trunctation, also optional (defaults to ...... yep, ">")
    -- by the way, open a lot of buffers and try clicking them ;)
)

return {
    BufferLine,
}
