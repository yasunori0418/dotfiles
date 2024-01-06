local M = {}
local utils = require("user.utils")

---@type string[]
M.tools = {}

---@type string[]
M.filetypes = {}

---@type boolean
M.all_installs = true

M.languages = {}

---@alias efm_configs_kind
---| "formatters" # `require('efmls-configs.formatters')`
---| "linters" # `require('efmls-configs.linters')`

---@class ToolConfig
---@field kind efm_configs_kind # Which select of formatters or linters
---@field name string # Tool name for supported by efmls-configs.
---@field auto_install boolean # if false not execute ensure_installed. Default: true

---get any configs from efmls-configs-nvim
---@param tool_config ToolConfig
---@return table # tool config for efm-langserver.
local function config_require(tool_config)
    return require(utils.resolve_module_namespace("efmls-configs", tool_config.kind, tool_config.name))
end

---make filetype config.
---@param tool_configs ToolConfig[]
local function filetype_config(filetype, tool_configs)
    M.languages[filetype] = {}
    for _, tool_config in ipairs(tool_configs) do
        setmetatable(tool_config, {
            __index = {
                auto_install = true,
            },
        })
        table.insert(M.languages[filetype], config_require(tool_config))
        if tool_config.auto_install then
            table.insert(M.tools, tool_config.name)
        end
    end
end

---mason ensure_installed
local function ensure_installed()
    local registry = require("mason-registry")
    registry.refresh(function()
        for _, tool in ipairs(M.tools) do
            local pkg = registry.get_package(tool)
            if not pkg:is_installed() and M.all_installs then
                vim.notify('Install tool: "' .. tool .. '"', vim.log.levels.INFO)
                pkg:install()
            end
        end
    end)
end

---setup of efm-langserver.
---@param options table
function M.setup(options)
    setmetatable(options, {
        __index = {
            all_installs = true,
        },
    })
    M.all_installs = options.all_installs
    M.filetypes = vim.tbl_keys(options.filetypes)
    for _, filetype in ipairs(M.filetypes) do
        filetype_config(filetype, options.filetypes[filetype])
    end
    ensure_installed()
end

return M
