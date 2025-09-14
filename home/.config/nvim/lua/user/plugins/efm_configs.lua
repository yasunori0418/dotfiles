local M = {}

---@type string[]
M.tools = {}

---@type string[]
M.filetypes = {}

---@type boolean
M.all_installs = true

M.languages = {}

---@alias User.Plugins.efm_configs.kind
---| "formatters" # `require('efmls-configs.formatters')`
---| "linters" # `require('efmls-configs.linters')`

---@class User.Plugins.efm_configs.ToolConfig
---@field kind User.Plugins.efm_configs.kind # Which select of formatters or linters
---@field name string # Tool name for supported by efmls-configs.

---@class User.Plugins.efm_configs.EfmConfigSetup
---@field filetypes table<string, User.Plugins.efm_configs.ToolConfig[]>

---get any configs from efmls-configs-nvim
---@param tool_config User.Plugins.efm_configs.ToolConfig
---@return table # tool config for efm-langserver.
local function config_require(tool_config)
    return require(vim.iter({ "efmls-configs", tool_config.kind, tool_config.name }):join("."))
end

---make filetype config.
---@param tool_configs User.Plugins.efm_configs.ToolConfig[]
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
---@param options User.Plugins.efm_configs.EfmConfigSetup
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
