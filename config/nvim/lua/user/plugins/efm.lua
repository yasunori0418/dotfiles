local M = {}
local utils = require('user.utils')
M.tools = {}
M.languages = {}

---@alias kind
---| "formatters" # `require('efmls-configs.formatters')`
---| "linters" # `require('efmls-configs.linters')`

---@class ToolConfig
---@field kind kind # Which select of formatters or linters
---@field name string # Tool name for supported by efmls-configs.

---@class EfmConfig
---@field filetype string
---@field tool_configs ToolConfig[]

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

---@param tool_config ToolConfig
local function register_tool(tool_config)
  table.insert(M.tools, tool_config)
end

---make filetype config.
---@param efm_config EfmConfig
---@return table # tool config for efm-langserver.
local function filetype_config(efm_config)
  local result = {}
  local filetype = efm_config.filetype
  for _, tool_config in ipairs(efm_config.tool_configs) do
    result[filetype] = config_require(tool_config)
    register_tool(tool_config)
  end
  return result
end

M.languages = {
  python = {
    config_require("formatters", "black"),
    config_require("linters", "flake8"),
  },
  lua = {
    config_require("formatters", "stylua"),
    config_require("linters", "luacheck"),
  },
  markdown = {
    config_require("linters", "textlint"),
    config_require("linters", "markdownlint"),
  },
  vim = {
    config_require("linters", "vint"),
  },
  json = {
    config_require("formatters", "jq"),
    config_require("linters", "jq"),
  },
  yaml = {
    config_require("linters", "yamllint"),
    config_require("formatters", "yq"),
  },
  php = {
    config_require("linters", "phpstan"),
    config_require("formatters", "pint"),
  },
  dockerfile = {
    config_require("linters", "hadolint"),
  },
  gitcommit = {
    config_require("linters", "gitlint"),
  },
}

return M
