local devicons = require("nvim-web-devicons")
local utils = require("heirline.utils")

local tabline_bufnr = {
    provider = function(self)
        return tostring(self.bufnr) .. ". "
    end,
    hl = "comment",
}

-- this is the default function used to retrieve buffers
local get_bufs = function()
    return vim.tbl_filter(function(bufnr)
        return vim.api.nvim_get_option_value("buflisted", {
            buf = bufnr,
        })
    end, vim.api.nvim_list_bufs())
end

-- initialize the buflist cache
local buflist_cache = {}

-- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
    callback = function()
        vim.schedule(function()
            local buffers = get_bufs()
            for index, value in ipairs(buffers) do
                buflist_cache[index] = value
            end
            for i = #buffers + 1, #buflist_cache do
                buflist_cache[i] = nil
            end
        end)
    end,
})

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
    { -- modified
        condition = function(self)
            return vim.api.nvim_get_option_value("modified", {
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
    tabline_bufnr,
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
    { -- left truncation, optional (defaults to "<")
        provider = "",
        hl = { fg = "black_bright", bg = "bg0" },
    },
    { -- right trunctation, also optional (defaults to ...... yep, ">")
        provider = "",
        hl = { fg = "black_bright", bg = "bg0" },
    },
    -- by the way, open a lot of buffers and try clicking them ;)
    function()
        return buflist_cache
    end,
    -- no cache, as we're handling everything ourselves
    false
)

local Tabpage = {
    provider = function(self)
        return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
    end,
    hl = function(self)
        if self.is_active then
            return "TabLineSel"
        else
            return "TabLine"
        end
    end,
}

local Tabpages = {
    -- only show this component if there's 2 or more tabpages
    condition = function()
        return #vim.api.nvim_list_tabpages() >= 2
    end,
    { provider = "%=" },
    utils.make_tablist(Tabpage),
}

local TabLineOffset = {
    condition = function(self)
        local win = vim.api.nvim_tabpage_list_wins(0)[1]
        local bufnr = vim.api.nvim_win_get_buf(win)
        self.winid = win

        if vim.bo[bufnr].filetype == "NvimTree" then
            self.title = "NvimTree"
            return true
        end
    end,

    provider = function(self)
        local title = self.title
        local width = vim.api.nvim_win_get_width(self.winid)
        local pad = math.ceil((width - #title) / 2)
        return string.rep(" ", pad) .. title .. string.rep(" ", pad)
    end,

    hl = function(self)
        if vim.api.nvim_get_current_win() == self.winid then
            return "TablineSel"
        else
            return "Tabline"
        end
    end,
}

return {
    TabLineOffset,
    BufferLine,
    Tabpages,
}
