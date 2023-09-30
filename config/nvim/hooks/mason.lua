-- lua_source {{{
require("mason").setup({
    ui = {
        border = "single",
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "✗ ",
        },
    },
})
-- }}}
