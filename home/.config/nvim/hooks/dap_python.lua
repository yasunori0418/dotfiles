-- lua_add {{{

-- }}}

-- lua_source {{{
local venv = os.getenv("VIRTUAL_ENV")
if not venv then
    venv = "/usr"
end
local cmd = string.format("%s/bin/python", vim.fn.expand(venv))

require("dap-python").setup(cmd)
-- }}}
