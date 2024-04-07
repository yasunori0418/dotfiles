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

---@type { rules: AutoPairRuleTable[], keymaps: AutoPairKeymaps }
local auto_pair_config = {
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
}

helper.auto_pairs_apply(auto_pair_config)

local endwise = require("insx.recipe.endwise")
insx.add("<CR>", endwise(endwise.builtin))

local altercmd = require("user.plugins.insx.substitute").altercmd
altercmd([=[si\%[licon]]=], [[Silicon]], [[<Space>]], [[c]])
altercmd([=[r\%[run]]=], [[QuickRun]], [[<Space>]], [[c]])
altercmd([=[ma\%[son]]=], [[Mason]], [[<Space>]], [[c]])
altercmd([[di]], [[DppInstall]], [[<Space>]], [[c]])
altercmd([[du]], [[DppUpdate]], [[<Space>]], [[c]])
altercmd([[dc]], [[DppClear]], [[<Space>]], [[c]])
altercmd([[ej]], [[Translate]], [[<Space>]], [[c]]) -- 英語から日本語へ
altercmd([[je]], [[Translate!]], [[<Space>]], [[c]]) -- 日本語から英語へ
altercmd([[gcf]], [[GinChaperon %]], [[<Space>]], [[c]])
altercmd([[cal]], [[Calendar]], [[<Space>]], [[c]])

-- }}}
