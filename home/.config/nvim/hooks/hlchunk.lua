-- lua_source {{{
-- local utils = require("user.utils")

-- local red = utils.get_color_code("Error")
-- local yellow = utils.get_color_code("Type")
-- local blue = utils.get_color_code("Title")
-- local orange = utils.get_color_code("Boolean")
-- local green = utils.get_color_code("String")
-- local cyan = utils.get_color_code("Keyword")
-- local light_gray = utils.get_color_code("Whitespace")

local exclude_filetypes = {
    ["ddu-ff"] = true,
    ["ddu-filer"] = true,
    ["deol"] = true,
}

require("hlchunk").setup({
    chunk = {
        enable = true,
        notify = false,
        use_treesitter = true,
        exclude_filetypes = exclude_filetypes,
        duration = 0,
    },
    indent = {
        enable = true,
        exclude_filetypes = exclude_filetypes,
    },
    line_num = {
        enable = false,
    },
    blank = {
        enable = false,
    },
})
-- }}}
