-- lua_source {{{
local command = vim.api.nvim_create_user_command

command("JT", function(opts)
    vim.fn["denops#request"]("jsontoml", "jsonTOML", { opts.line1, opts.line2 })
end, { range = "%" })

command("TJ", function(opts)
    vim.fn["denops#request"]("jsontoml", "tomlJSON", { opts.line1, opts.line2 })
end, { range = "%" })
-- }}}
