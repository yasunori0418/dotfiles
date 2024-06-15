local lsp_utils = require("user.lsp.utils")
local ft = lsp_utils.ft

-- Refer:
-- https://github.com/ryoppippi/dotfiles/blob/e6e0f02/nvim/lua/plugin/nvim-lspconfig/servers/vtsls.lua#L44-L70
---@param path string|nil
---@return string|nil
local function find_root(path)
    if path == nil or path == "" then
        return nil
    end

    local project_root = vim.fs.root(path, vim.iter({ ".git", ft.node_files }):flatten(math.huge):totable())

    if project_root == nil then
        return nil
    end

    if lsp_utils.is_node_files_found(project_root) then
        return project_root
    end

    if vim.uv.fs_stat(vim.fs.joinpath(project_root, ".git")) ~= nil then
        return nil
    end
end

return function()
    require("lspconfig").vtsls.setup({
        filetype = ft.js_like,
        single_file_support = false,
        root_dir = function(path)
            return find_root(vim.fs.dirname(path))
        end,
        capabilities = require("user.lsp.utils").capabilities,
    })
end
