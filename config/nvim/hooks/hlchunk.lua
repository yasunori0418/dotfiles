-- lua_source {{{

---get color code from hlGroup
---@param hl_name string
---@param type? "fg" | "bg"
---@param mode? "gui" | "cterm" | "term"
---@return string
local function get_color_code(hl_name, type, mode)
    type = type or "fg"
    mode = mode or "gui"
    return vim.fn.synIDattr(
        vim.fn.synIDtrans(vim.fn.hlID(hl_name)),
        type,
        mode
    )
end

local red = get_color_code("Error")
-- local yellow = get_color_code("Type")
local blue = get_color_code("Title")
-- local orange = get_color_code("Boolean")
-- local green = get_color_code("String")
local cyan = get_color_code("Keyword")
local light_gray = get_color_code("Whitespace")

local ft = require("hlchunk.utils.filetype")
require("hlchunk").setup({
    chunk = {
        enable = true,
        notify = true,
        use_treesitter = true,
        -- details about support_filetypes and exclude_filetypes in
        -- https://github.com/shellRaining/hlchunk.nvim/blob/main/lua/hlchunk/utils/filetype.lua
        support_filetypes = ft.support_filetypes,
        exclude_filetypes = ft.exclude_filetypes,
        chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = ">",
        },
        style = {
            { fg = cyan },
            { fg = red }, -- this fg is used to highlight wrong chunk
        },
        textobject = "",
        max_file_size = 1024 * 1024,
        error_sign = true,
    },

    indent = {
        enable = true,
        use_treesitter = true,
        chars = {
            "│",
            "¦",
            "┆",
            "┊",
        },
        style = {
            { fg = get_color_code("Whitespace") },
        },
    },

    line_num = {
        enable = true,
        use_treesitter = true,
        style = cyan,
    },

    blank = {
        enable = true,
        use_treesitter = true,
        chars = {
            " ",
        },
        style = {
            { fg = light_gray },
        },
    },

    context = {
        enable = true,
        notify = true,
        use_treesitter = false,
        chars = {
            "┃", -- Box Drawings Heavy Vertical
        },
        style = {
            blue,
        },
        exclude_filetypes = ft.exclude_filetypes,
    },
})
-- }}}
