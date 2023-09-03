-- lua_source {{{
local command = vim.api.nvim_create_user_command

command("JY", function(opts)
  vim.fn["denops#request"]("jsonyaml", "jsonYAML", { opts.line1, opts.line2 })
end, { range = "%" })

command("YJ", function(opts)
  vim.fn["denops#request"]("jsonyaml", "yamlJSON", { opts.line1, opts.line2 })
end, { range = "%" })
-- }}}
