-- lua_source {{{
local navic = require("nvim-navic")
local user_lsp_utils = require("user.lsp.utils")

navic.setup({
    icons = {
        File = " ",
        Module = " ",
        Namespace = " ",
        Package = " ",
        Class = " ",
        Method = " ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = " ",
        Interface = " ",
        Function = " ",
        Variable = " ",
        Constant = " ",
        String = " ",
        Number = " ",
        Boolean = " ",
        Array = " ",
        Object = " ",
        Key = " ",
        Null = " ",
        EnumMember = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
    },
    lsp = {
        auto_attach = false,
        preference = { "lua_ls", "pyright" },
    },
    highlight = false,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
    safe_output = true,
    lazy_update_context = false,
    click = false,
})

user_lsp_utils.on_attach(function(client, buffer)
    if client.server_capabilities.documentSymbolProvider then
        if client.name ~= "efm" then
            navic.attach(client, buffer)
        end
    end
end)
-- }}}
