-- lua_source {{{
local insx_helper = require("user.plugins.insx")

---@type { rules: AutoPairRuleTable[], keymaps: AutoPairKeymaps }
local auto_pair_config = {
    rules = {
        {
            open = [[(]],
            close = [[)]],
            options = { undopoint = true, nomatch = [[\%#\w]] },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [[{]],
            close = [[}]],
            options = { undopoint = true, nomatch = [[\%#\w]] },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [=[[]=],
            close = [=[]]=],
            options = { undopoint = true, nomatch = [[\%#\w]] },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [[']],
            close = [[']],
            options = { undopoint = true, nomatch = [[\%#\w]] },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [["]],
            close = [["]],
            options = { undopoint = true, nomatch = [[\%#\w]] },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [[`]],
            close = [[`]],
            options = { undopoint = true, nomatch = [[\%#\w]] },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
    },
    keymaps = {
        jump_next_extra = { "<Tab>" },
        delete_pair = { "<BS>", "<C-h>" },
        spacing = { increase = { "<Space>" }, decrease = { "<BS>", "<C-h>" } },
        fast_break = { "<CR>" },
        fast_wrap = { "<C-]>" },
    },
}

insx_helper.auto_pairs_apply(auto_pair_config)

-- }}}
