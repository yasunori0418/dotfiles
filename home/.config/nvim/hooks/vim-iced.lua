-- lua_add {{{
local uv = vim.uv
local vim_iced_path = require("dpp" ).get("vim-iced").path
uv.os_setenv("PATH", vim.fn.join({uv.os_getenv("PATH"), vim.fs.joinpath(vim_iced_path, "bin")}, ":"))
-- }}}

-- lua_source {{{
vim.g.iced_enable_default_key_mappings = true
-- }}}
