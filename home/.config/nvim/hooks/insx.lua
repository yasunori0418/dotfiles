-- lua_source {{{
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
    pair_setup.auto_pair(open, open, close)
    pair_setup.delete_pair([[<BS>]], open, close)
    pair_setup.delete_pair([[<C-h>]], open, close)
    pair_setup.jump_pair_next(close, close)
    pair_setup.jump_pair_next([[<Tab>]], close)
    helper.fast_wrap([[<C-]>]], close)
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
