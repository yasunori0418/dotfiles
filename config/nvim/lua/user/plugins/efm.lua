local M = {}
local utils = require('user.utils')
M.tools = {}
M.languages = {}
M.filetypes = {}

---@alias kind
---| "formatters" # `require('efmls-configs.formatters')`
---| "linters" # `require('efmls-configs.linters')`

---@class ToolConfig
---@field kind kind # Which select of formatters or linters
---@field name string # Tool name for supported by efmls-configs.

---get any configs from efmls-configs-nvim
---@param tool_config ToolConfig
---@return table # tool config for efm-langserver.
local function config_require(tool_config)
  return require(
    utils.resolve_module_namespace(
      "efmls-configs",
      tool_config.kind,
      tool_config.name))
end

---make filetype config.
---@param tool_configs ToolConfig[]
---@return table # tool config for efm-langserver.
local function filetype_config(filetype, tool_configs)
  local result = {}
  result[filetype] = {}
  for _, tool_config in ipairs(tool_configs) do
    table.insert(result[filetype], config_require(tool_config))
    table.insert(M.tools, tool_config)
  end
  return result
end

---setup of efm-langserver.
---@param options table
function M.setup(options)
  M.filetypes = vim.tbl_keys(options)
  for _, filetype in pairs(M.filetypes) do
    local config = filetype_config(filetype, options[filetype])
    table.insert(M.languages, config)
  end
end

return M
