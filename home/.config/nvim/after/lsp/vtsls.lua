local utils = require("user.utils")
local lsp_utils = require("user.lsp.utils")
local ft = lsp_utils.ft

-- Refer:
-- https://github.com/ryoppippi/dotfiles/blob/e6e0f02/nvim/lua/plugin/nvim-lspconfig/servers/vtsls.lua#L44-L70
---@param path string|nil
---@return string|nil
local function find_root(path)
    if path == nil then
        return nil
    end

    local project_root =
        vim.fs.root(path, vim.iter({ ".git", ft.node_specific_files }):flatten(math.huge --[[@as number]]):totable())

    if project_root == nil or project_root == vim.fn.expand("$HOME") then
        return nil
    end

    if utils.is_files_found(project_root, ft.node_files) then
        return project_root
    end

    if utils.is_files_found(project_root, ft.deno_files) then
        return nil
    end
end

---@type vim.lsp.Config
return {
    filetypes = ft.js_like,
    single_file_support = false,
    root_dir = function(bufnr, on_dir)
        local file_path = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":p")
        local root_dir = find_root(vim.fs.dirname(file_path))
        if root_dir then
            on_dir(root_dir)
        end
    end,
    settings = {
        typescript = {
            format = {
                enable = false,
            },
        },
        javascript = {
            format = {
                enable = false,
            },
        },
    },
}
