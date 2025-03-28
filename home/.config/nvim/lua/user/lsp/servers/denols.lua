local utils = require("user.utils")
local lsp_utils = require("user.lsp.utils")
local ft = lsp_utils.ft

-- Refer:
-- https://github.com/ryoppippi/dotfiles/blob/e6e0f02/nvim/lua/plugin/nvim-lspconfig/servers/denols.lua#L5-L49
---@param path string
---@return string|nil
local function find_root(path)
    ---@type string|nil
    local project_root = vim.fs.root(path, vim.iter({ ".git", ft.deno_files }):flatten(math.huge):totable())
    project_root = project_root or vim.env.PWD --[[@as string]]

    -- when node files found, not launch denols.
    if utils.is_files_found(project_root, ft.node_specific_files) then
        return nil
    end

    -- when node files not found, launch denols
    local deps_path = vim.fs.joinpath(project_root, "deps.ts")
    if vim.uv.fs_stat(deps_path) ~= nil then
        vim.b[vim.fn.bufnr()].deno_deps_candidate = deps_path
    end
    return project_root
end

require("lspconfig").denols.setup({
    root_dir = function(bufnr)
        local file_path = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":p")
        return find_root(vim.fs.dirname(file_path))
    end,
    settings = {
        deno = {
            enable = true,
            unstable = true,
            lint = true,
            suggest = {
                completeFunctionCalls = true,
                autoImports = false,
                imports = {
                    hosts = {
                        ["https://deno.land"] = true,
                        ["https://denopkg.com"] = true,
                        ["https://crux.land"] = true,
                        ["https://x.nest.land"] = true,
                        ["https://jsr.io"] = true,
                    },
                },
            },
        },
    },
} --[[@as vim.lsp.Config]])
