-- lua_source {{{
local insx_helper = require("user.plugins.insx")

require("insx.preset.standard").setup({
    cmdline = { enabled = true },
    fast_break = { enabled = true, arguments = true, html_attrs = true },
    fast_wrap = { enabled = true },
    spacing = { enabled = true },
})

---@type { rules: AutoPairRuleTable[], keymaps: AutoPairKeymaps }
local auto_pair_config = {
    rules = {
        {
            open = [[(]],
            close = [[)]],
            options = { undopoint = true, nomatch = [[\%#\w]], priority = 50 },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [[{]],
            close = [[}]],
            options = { undopoint = true, nomatch = [[\%#\w]], priority = 50 },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [=[[]=],
            close = [=[]]=],
            options = { undopoint = true, nomatch = [[\%#\w]], priority = 50 },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [[']],
            close = [[']],
            options = { undopoint = true, nomatch = [[\%#\w]], priority = 50 },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [["]],
            close = [["]],
            options = { undopoint = true, nomatch = [[\%#\w]], priority = 50 },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [[`]],
            close = [[`]],
            options = { undopoint = true, nomatch = [[\%#\w]], priority = 50 },
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
