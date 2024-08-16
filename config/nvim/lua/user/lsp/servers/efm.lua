local efm_configs = require("user.plugins.efm_configs")

efm_configs.setup({
    all_installs = false,
    filetypes = {
        python = {
            { kind = "formatters", name = "ruff" },
            { kind = "linters", name = "ruff" },
        },
        lua = {
            { kind = "formatters", name = "stylua" },
            { kind = "linters", name = "luacheck" },
        },
        markdown = {
            { kind = "linters", name = "textlint", auto_install = false },
            { kind = "linters", name = "markdownlint" },
        },
        make = {
            { kind = "linters", name = "checkmake" },
        },
        json = {
            { kind = "formatters", name = "jq" },
            { kind = "linters", name = "jq" },
        },
        jsonc = {
            { kind = "formatters", name = "jq" },
            { kind = "linters", name = "jq" },
        },
        yaml = {
            { kind = "linters", name = "yamllint" },
            { kind = "linters", name = "actionlint" },
        },
        php = {
            { kind = "linters", name = "phpcs" },
            { kind = "formatters", name = "phpcbf" },
        },
        dockerfile = {
            { kind = "linters", name = "hadolint" },
        },
        javascript = {
            { kind = "linters", name = "eslint_d" },
            { kind = "formatters", name = "biome" },
        },
        javascriptreact = {
            { kind = "linters", name = "eslint_d" },
            { kind = "formatters", name = "biome" },
        },
        sh = {
            { kind = "linters", name = "shellcheck" },
            { kind = "formatters", name = "beautysh" },
        },
        bash = {
            { kind = "linters", name = "shellcheck" },
            { kind = "formatters", name = "beautysh" },
        },
        zsh = {
            { kind = "formatters", name = "beautysh" },
        },
        nix = {
            { kind = "formatters", name = "alejandra", auto_install = false },
        },
        sql = {
            { kind = "formatters", name = "sql-formatter" },
        },
    },
})

return function()
    require("lspconfig").efm.setup({
        filetypes = efm_configs.filetypes,
        init_options = {
            documentFormatting = true,
            rangeFormatting = true,
            hover = true,
            documentSymbol = true,
            codeAction = true,
            completion = false,
        },
        capabilities = require("user.lsp.utils").capabilities,
        settings = {
            rootMarkers = { ".git/" },
            languages = efm_configs.languages,
        },
    })
end
