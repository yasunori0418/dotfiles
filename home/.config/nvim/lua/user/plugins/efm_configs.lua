local M = {}
local utils = require("user.utils")

---@type string[]
M.tools = {}

---@type string[]
M.filetypes = {}

---@type boolean
M.all_installs = true

M.languages = {}

---@diagnostic disable-next-line: duplicate-doc-alias
---@alias efm_configs_kind
---| "formatters" # `require('efmls-configs.formatters')`
---| "linters" # `require('efmls-configs.linters')`

---@class ToolConfig
---@diagnostic disable: duplicate-doc-field
---@field kind efm_configs_kind # Which select of formatters or linters
---@field name string # Tool name for supported by efmls-configs.

---@class EfmConfigSetup
---@field filetypes table<string, ToolConfig[]>

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
    end
end

---setup of efm-langserver.
---@param options EfmConfigSetup
function M.setup(options)
    setmetatable(options, {
        __index = {
            all_installs = true,
        },
    })
    M.filetypes = vim.tbl_keys(options.filetypes)
    for _, filetype in ipairs(M.filetypes) do
        filetype_config(filetype, options.filetypes[filetype])
    end
end

return M
