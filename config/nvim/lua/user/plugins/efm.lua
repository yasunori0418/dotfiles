local M = {}
local utils = require('user.utils')

---@type string[]
M.tools = {}

---@type string[]
M.filetypes = {}

M.languages = {}

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
    table.insert(M.tools, tool_config.name)
  end
  return result
end

---mason ensure_installed
local function ensure_installed()
  local registry = require("mason-registry")
  registry.refresh(function()
    for _, tool in ipairs(M.tools) do
      local pkg = registry.get_package(tool)
      if not pkg:is_installed() then
        pkg:install()
      end
    end
  end)
end

---setup of efm-langserver.
---@param options table
function M.setup(options)
  M.filetypes = vim.tbl_keys(options)
  for _, filetype in pairs(M.filetypes) do
    table.insert(
      M.languages,
      filetype_config(filetype, options[filetype])
    )
  end
  ensure_installed()
end

return M
