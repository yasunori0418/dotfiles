-- lua_source {{{
-- local utils = require("user.utils")

-- local red = utils.get_color_code("Error")
-- local yellow = utils.get_color_code("Type")
-- local blue = utils.get_color_code("Title")
-- local orange = utils.get_color_code("Boolean")
-- local green = utils.get_color_code("String")
-- local cyan = utils.get_color_code("Keyword")
-- local light_gray = utils.get_color_code("Whitespace")

require("hlchunk").setup({
    chunk = {
        enable = true,
        notify = true,
        use_treesitter = true,
        exclude_filetypes = {
            ["ddu-ff"] = true,
            ["ddu-filer"] = true,
        },
    },
    indent = {
        enable = true,
        use_treesitter = true,
    },
    line_num = {
        enable = true,
        use_treesitter = true,
    },
    blank = {
        enable = false,
    },
})
-- }}}
