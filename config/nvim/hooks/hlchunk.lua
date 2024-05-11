-- lua_source {{{
local utils = require("user.utils")

local red = utils.get_color_code("Error")
-- local yellow = utils.get_color_code("Type")
local blue = utils.get_color_code("Title")
-- local orange = utils.get_color_code("Boolean")
-- local green = utils.get_color_code("String")
local cyan = utils.get_color_code("Keyword")
local light_gray = utils.get_color_code("Whitespace")

local ft = require("hlchunk.utils.filetype")
ft.exclude_filetypes["ddu-ff"] = true
ft.exclude_filetypes["ddu-filer"] = true
ft.exclude_filetypes["deol"] = true

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
            left_top = "┌",
            left_bottom = "└",
            right_arrow = "─",
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
        notify = true,
        support_filetypes = ft.support_filetypes,
        exclude_filetypes = ft.exclude_filetypes,
        chars = {
            "│",
        },
        style = {
            "#FF0000",
            "#FF7F00",
            "#FFFF00",
            "#00FF00",
            "#00FFFF",
            "#0000FF",
            "#8B00FF",
        },
    },

    line_num = {
        enable = true,
        use_treesitter = true,
        notify = true,
        support_filetypes = ft.support_filetypes,
        exclude_filetypes = ft.exclude_filetypes,
        style = cyan,
    },

    blank = {
        enable = false,
        use_treesitter = true,
        chars = {
            ".",
        },
        style = {
            { fg = light_gray },
        },
    },

    context = {
        enable = true,
        notify = true,
        use_treesitter = false,
        support_filetypes = ft.support_filetypes,
        exclude_filetypes = ft.exclude_filetypes,
        chars = {
            "┃", -- Box Drawings Heavy Vertical
        },
        style = {
            blue,
        },
    },
})
-- }}}