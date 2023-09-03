local command = vim.api.nvim_create_user_command
local dein = require("dein")

command("JY", function(opts)
  if not dein.is_sourced("jsonyaml.vim") then
    dein.source("jsonyaml.vim")
  end
  vim.fn["denops#request"]("jsonyaml", "jsonYAML", { opts.line1, opts.line2 })
end, { range = "%" })

command("YJ", function(opts)
  if not dein.is_sourced("jsonyaml.vim") then
    dein.source("jsonyaml.vim")
  end
  vim.fn["denops#request"]("jsonyaml", "yamlJSON", { opts.line1, opts.line2 })
end, { range = "%" })

command("JT", function(opts)
  if not dein.is_sourced("jsontoml.vim") then
    dein.source("jsontoml.vim")
  end
  vim.fn["denops#request"]("jsontoml", "jsonTOML", { opts.line1, opts.line2 })
end, { range = "%" })

command("TJ", function(opts)
  if not dein.is_sourced("jsontoml.vim") then
    dein.source("jsontoml.vim")
  end
  vim.fn["denops#request"]("jsontoml", "tomlJSON", { opts.line1, opts.line2 })
end, { range = "%" })
