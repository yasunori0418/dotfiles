local M = {}
local utils = require('user.utils')
M.tools = {}
M.languages = {}

---@alias kind
---| "formatters" # `require('efmls-configs.formatters')`
---| "linters" # `require('efmls-configs.linters')`

---get any configs from efmls-configs-nvim
---@param kind kind # Which select of formatters or linters
---@param name string # Tool name for supported by efmls-configs.
---@return table # tool config for efm-langserver.
local function config_require(kind, name)
  return require(
    utils.resolve_module_namespace("efmls-configs", kind, name)
  )
end

---@param kind kind # Which select of formatters or linters
---@param name string # Tool name for supported by efmls-configs.
local function register_tools(kind, name)
  table.insert(M.tools, {
    kind = kind,
    name = name,
  })
end

---make filetype config.
---@param filetype string
---@param kind kind # Which select of formatters or linters
---@param name string # Tool name for supported by efmls-configs.
---@return table # tool config for efm-langserver.
local function filetype_config(filetype, kind, name)
  local result = {}
  result[filetype] = config_require(kind, name)
  register_tools(kind, name)
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
