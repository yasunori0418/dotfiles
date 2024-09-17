-- lua_source {{{
local insx = require("insx")
local with = insx.with
local helper = require("user.plugins.insx")

require("insx.preset.standard").setup({
    cmdline = { enabled = true },
    fast_break = { enabled = true, arguments = true, html_attrs = true },
    fast_wrap = { enabled = true },
    spacing = { enabled = true },
})

helper.auto_pairs_apply({
    rules = {
        {
            open = [[(]],
            close = [[)]],
            mode_list = { "c", "i" },
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
            mode_list = { "c", "i" },
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
            mode_list = { "c", "i" },
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
            mode_list = { "c", "i" },
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
            mode_list = { "c", "i" },
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
            mode_list = { "c", "i" },
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
            mode_list = { "i" },
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
})

local endwise = require("insx.recipe.endwise")
insx.add("<CR>", endwise(endwise.builtin))

helper.altercmds_apply({
    rules = {
        {
            original = [=[si\%[licon]]=],
            altanative = [[Silicon]],
        },
        {
            original = [=[r\%[un]]=],
            altanative = [[QuickRun]],
        },
        {
            original = [=[ma\%[son]]=],
            altanative = [[Mason]],
        },
        {
            original = [[di]],
            altanative = [[DppInstall]],
        },
        {
            original = [[du]],
            altanative = [[DppUpdate]],
        },
        {
            original = [[dc]],
            altanative = [[DppClearState]],
        },
        {
            original = [[ej]],
            altanative = [[Translate]],
        },
        {
            original = [[je]],
            altanative = [[Translate!]],
        },
        {
            original = [[gcf]],
            altanative = [[GinChaperon %]],
        },
        {
            original = [[cal]],
            altanative = [[Calendar]],
        },
        {
            original = [[mes]],
            altanative = [[Capture mes]],
        },
        {
            original = [=[c\%[apture]]=],
            altanative = [[Capture ]],
        },
    },
    keymaps = {
        expand_keys = {
            space = true,
            cr = true,
        },
    },
})

-- }}}
