-- lua_source {{{
require("mason-null-ls").setup({
  ensure_installed = nil,
  automatic_installation = {
    exclude = {
      "textlint",
    },
  },
  automatic_setup = false,
})
-- }}}
