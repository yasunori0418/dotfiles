-- lua_source {{{

-- require("insx.preset.standard").setup({
--     cmdline = {
--         enabled = true,
--     },
--     fast_break = {
--         enabled = true,
--     },
--     fast_wrap = {
--         enabled = true,
--     },
--     spacing = {
--         enabled = true,
--     },
-- })

local auto_pairs = {
    {
        open = [[(]],
        close = [[)]],
        options = {
            undopoint = true,
            nomatch = [[\%#\w]],
        },
        fast_break = {
            arguments = true,
            html_attrs = true,
            html_tags = true,
        }
    },
    {
        open = [[{]],
        close = [[}]],
        options = {
            undopoint = true,
            nomatch = [[\%#\w]],
        },
        fast_break = {
            arguments = true,
            html_attrs = true,
            html_tags = true,
        }
    },
    {
        open = [=[[]=],
        close = [=[]]=],
        options = {
            undopoint = true,
            nomatch = [[\%#\w]],
        },
        fast_break = {
            arguments = true,
            html_attrs = true,
            html_tags = true,
        }
    },
}

local auto_pair_helper = require('user.plugins.insx.auto_pair')
for _, auto_pair in ipairs(auto_pairs) do
    local rule = auto_pair_helper.new(auto_pair)
    auto_pair_helper.apply(rule)
end

-- }}}
