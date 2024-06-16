local M = {}

local lsp = vim.lsp

-- Refer:
-- https://github.com/ryoppippi/dotfiles/blob/e6e0f02/nvim/lua/plugin/nvim-lspconfig/utils.lua#L36-L125
M.ft = {}
M.ft.js_like = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
}

M.ft.js_framework_like = vim.iter({
    M.ft.js_like,
    {
        "svelte",
        "astro",
        "vue",
    },
})
    :flatten(math.huge)
    :totable()

M.ft.markdown_like = {
    "markdown",
    "markdown.mdx",
}

M.ft.css_like = {
    "css",
    "scss",
    "less",
}

M.ft.html_like = vim.iter({
    M.ft.markdown_like,
    M.ft.css_like,
    M.ft.js_framework_like,
    { "html", "htmldjango" },
})
    :flatten(math.huge)
    :totable()

M.ft.json_like = {
    "json",
    "jsonc",
    "json5",
}

M.ft.yaml_like = {
    "yaml",
    "yaml.docker-compose",
    "yaml.gitlab",
}

M.ft.config_like = vim.iter({
    M.ft.json_like,
    M.ft.yaml_like,
    { "toml" },
})
    :flatten(math.huge)
    :totable()

M.ft.sh_like = {
    "sh",
    "bash",
    "zsh",
    "fish",
}

M.ft.deno_files = {
    "deno.json",
    "deno.jsonc",
    "denops",
    "package.json",
}

M.ft.node_specific_files = {
    "node_modules",
    "bun.lockb", -- bun
    "package-lock.json", -- npm or bun
    "npm-shrinkwrap.json", -- npm
    "yarn.lock", -- yarn
    "pnpm-lock.yaml", -- pnpm
}

M.ft.node_files = vim.iter({
    M.ft.node_specific_files,
    "package.json",
})
    :flatten(math.huge)
    :totable()

---search node related files in project root
---@param path string
---@return boolean
function M.is_node_files_found(path)
    return vim.iter(M.ft.node_specific_files):any(function(file)
        return vim.uv.fs_stat(vim.fs.joinpath(path, file)) ~= nil
    end)
end

---@param buffer number
---@return vim.lsp.Client[]
function M.node_lsp_clients(buffer)
    return vim.iter({ "vtsls", "tsserver" })
        :map(function(c)
            return vim.lsp.get_clients({ name = c, bufnr = buffer })
        end)
        :flatten()
        :totable()
end

---@param buffer number
---@return vim.lsp.Client|nil
function M.deno_lsp_client(buffer)
    return vim.lsp.get_clients({ name = "denols", bufnr = buffer })[1]
end

---LSPが動くバッファーに対しての設定をするヘルパー
---[参考リンク]:(https://zenn.dev/ryoppippi/articles/8aeedded34c914)
---
---@param on_attach fun(client: vim.lsp.Client|nil, buffer: number|nil)
function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        group = require("user.utils").vimrc_augroup,
        callback = function(args)
            local buffer = nil
            if args.buf ~= nil then
                buffer = args.buf
            end

            local client = nil
            if args.data ~= nil then
                client = vim.lsp.get_client_by_id(args.data.client_id)
            end
            if client ~= nil then
                on_attach(client, buffer)
            end
        end,
        desc = "Execute autocmd on LspAttach",
    })
end

---フォーマット時のtimeout対応
---5000msだけ待ってやる
function M.format()
    lsp.buf.format({ timeout_ms = 5000 })
end

M.capabilities = require("ddc_source_lsp").make_client_capabilities()
M.capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

return M
