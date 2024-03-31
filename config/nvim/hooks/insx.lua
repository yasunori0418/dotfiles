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

local insx_helper = require("user.plugins.insx")

---@type { open: string, close: string, options?: WithOptions, fast_break?: FastBreakOption }[]
local auto_pairs = {
    {
        open = [[(]],
        close = [[)]],
        options = {
            undopoint = true,
            priority = 10,
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

for _, auto_pair in ipairs(auto_pairs) do
    local rule = insx_helper.auto_pair.new(auto_pair)
    insx_helper.auto_pair.apply(rule)
end

-- }}}
