-- lua_source {{{
local ifx = require("user.utils").ifx
local insx = require("insx")
local helper = require("user.plugins.insx.helper")
local altercmd = helper.altercmd
local pair_setup = require("user.plugins.insx.pair")
local quote_setup = require("user.plugins.insx.quote")

require("insx.preset.standard").setup({
    cmdline = { enabled = true },
    fast_break = { enabled = true, arguments = true, html_attrs = true },
    fast_wrap = { enabled = true },
    spacing = { enabled = false },
})

insx.add([[<C-g>]], helper.kensaku_search_expand(), { mode = "c" })

altercmd([=[si\%[licon]]=], [[Silicon]])
altercmd([=[r\%[un]]=], [[QuickRun]])
altercmd([[di]], [[DppInstall]])
altercmd([[du]], [[DppUpdate]])
altercmd([[dc]], [[DppClearState]])
altercmd([[ej]], [[Translate]])
altercmd([[je]], [[Translate!]])
altercmd([[gcf]], [[GinChaperon %]])
altercmd([[gc]], [[Gin commit]])
altercmd([[gca]], [[Gin commit --all]])
altercmd([[gcam]], [[Gin commit --amend]])
altercmd([[gsb]], [[Gitsigns blame]])
altercmd([[gsd]], [[Gitsigns diffthis]])
altercmd([[gl]], [[GinLog]])
altercmd([[cal]], [[Calendar]])
altercmd([[mes]], [[Capture mes]])
altercmd([=[c\%[apture]]=], [[Capture ]])

vim.iter({
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ["<"] = ">",
}):each(function(open, close)
    local overrides = ifx(open == "<", {
        insx.with.filetype({
            "lua",
            "vim",
            "typescript",
            "kotlin",
        }),
    }, {})
    pair_setup.auto_pair(open, open, close, overrides)
    pair_setup.delete_pair([[<C-h>]], open, close, overrides)
    pair_setup.jump_pair_next(close, close, overrides)
    pair_setup.jump_pair_next([[<Tab>]], close, overrides)
    helper.fast_wrap([[<C-]>]], close, overrides)
end)

vim.iter({
    [[']],
    [["]],
    [[`]],
}):each(function(quote)
    quote_setup.auto_quote(quote, quote)
    quote_setup.delete_quote([[<C-h>]], quote)
    quote_setup.jump_quote_next(quote, quote)
    quote_setup.jump_quote_next([[<Tab>]], quote)
    helper.fast_wrap([[<C-]>]], quote)
end)

-- }}}
