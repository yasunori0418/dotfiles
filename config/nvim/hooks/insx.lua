-- lua_source {{{
local insx = require("insx")
local with = insx.with
local helper = require("user.plugins.insx")
local endwise = require("insx.recipe.endwise")
insx.add("<CR>", endwise(endwise.builtin))

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
            mode_list = { 'c', 'i' },
            with_option = {
                with.undopoint(false),
                with.nomatch([[\%#\w]]),
                with.priority(10),
            },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [[{]],
            close = [[}]],
            mode_list = { 'c', 'i' },
            with_option = {
                with.undopoint(true),
                with.nomatch([[\%#\w]]),
                with.priority(10),
            },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [=[[]=],
            close = [=[]]=],
            mode_list = { 'c', 'i' },
            with_option = {
                with.undopoint(true),
                with.nomatch([[\%#\w]]),
                with.priority(10),
            },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [[']],
            close = [[']],
            mode_list = { 'c', 'i' },
            with_option = {
                with.undopoint(true),
                with.nomatch([[\%#\w]]),
                with.priority(10),
            },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [["]],
            close = [["]],
            mode_list = { 'c', 'i' },
            with_option = {
                with.undopoint(true),
                with.nomatch([[\%#\w]]),
                with.priority(10),
            },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [[`]],
            close = [[`]],
            mode_list = { 'c', 'i' },
            with_option = {
                with.undopoint(true),
                with.nomatch([[\%#\w]]),
                with.priority(10),
            },
            fast_break = { arguments = true, html_attrs = true, html_tags = true },
        },
        {
            open = [[<]],
            close = [[>]],
            mode_list = { 'i' },
            with_option = {
                with.undopoint(true),
                with.nomatch([[\%#\w]]),
                with.priority(10),
                with.filetype({ "html", "markdown" }),
            },
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

helper.auto_pairs_apply(auto_pair_config)

-- }}}
