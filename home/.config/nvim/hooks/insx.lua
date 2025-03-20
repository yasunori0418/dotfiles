-- lua_source {{{
local ifx = require("user.utils").ifx
local insx = require("insx")
local helper = require("user.plugins.insx.helper")
local pair_setup = require("user.plugins.insx.pair")
local quote_setup = require("user.plugins.insx.quote")

require("insx.preset.standard").setup({
    cmdline = { enabled = true },
    fast_break = { enabled = true, arguments = true, html_attrs = true },
    fast_wrap = { enabled = true },
    spacing = { enabled = true },
})

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
    pair_setup.delete_pair([[<BS>]], open, close, overrides)
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
    quote_setup.delete_quote([[<BS>]], quote)
    quote_setup.delete_quote([[<C-h>]], quote)
    quote_setup.jump_quote_next(quote, quote)
    quote_setup.jump_quote_next([[<Tab>]], quote)
    helper.fast_wrap([[<C-]>]], quote)
end)

-- }}}
