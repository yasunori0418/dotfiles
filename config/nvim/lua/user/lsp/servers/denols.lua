local lsp_utils = require("user.lsp.utils")
local ft = lsp_utils.ft

-- Refer:
-- https://github.com/ryoppippi/dotfiles/blob/e6e0f02/nvim/lua/plugin/nvim-lspconfig/servers/denols.lua#L5-L49
---@param path string
---@return string|nil
local function find_root(path)
    ---@type string|nil
    local project_root =
        vim.fs.root(path, vim.iter({ ".git", ft.deno_files, ft.node_specific_files }):flatten(math.huge):totable())
    project_root = project_root or vim.env.PWD

    -- when node files not found, lauch denols
    if not lsp_utils.is_node_files_found(project_root) then
        local deps_path = vim.fs.joinpath(project_root, "deps.ts")
        if vim.uv.fs_stat(deps_path) ~= nil then
            vim.b[vim.fn.bufnr()].deno_deps_candidate = deps_path
        end
        return project_root
    end

    return nil
end

---If the environment runs deno lsp, stop the another node lsp
---@param path string|nil
local function stop_lsp_clients(path)
    lsp_utils.on_attach(function(_, buffer)
        if buffer == nil then
            return
        end

        local deno_lsp_client = lsp_utils.deno_lsp_client(buffer)
        if deno_lsp_client == nil then
            return
        end
        local is_denols_attached = vim.lsp.buf_is_attached(buffer, deno_lsp_client.id) and path ~= nil

        if not is_denols_attached then
            vim.lsp.stop_client(deno_lsp_client.id, true)
        end

        local node_lsp_clients = lsp_utils.node_lsp_clients(buffer)
        if is_denols_attached and #node_lsp_clients > 0 then
            for _, node_lsp_client in pairs(node_lsp_clients) do
                vim.lsp.stop_client(node_lsp_client.id, true)
            end
        end
    end)
end

return function()
    require("lspconfig").denols.setup({
        single_file_support = true,
        root_dir = function(path)
            local root_dir = find_root(vim.fs.dirname(path))
            stop_lsp_clients(root_dir)
            return root_dir
        end,
        capabilities = require("user.lsp.utils").capabilities,
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
                        },
                    },
                },
            },
        },
    })
end
