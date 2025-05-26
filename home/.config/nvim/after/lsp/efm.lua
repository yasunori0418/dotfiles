local efm_configs = require("user.plugins.efm_configs")

efm_configs.setup({
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
            { kind = "linters", name = "textlint" },
            { kind = "linters", name = "markdownlint" },
            { kind = "formatters", name = "mdformat" },
        },
        make = {
            { kind = "linters", name = "checkmake" },
        },
        json = {
            { kind = "formatters", name = "jq" },
            { kind = "linters", name = "jq" },
        },
        json5 = {
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
        blade = {
            { kind = "formatters", name = "blade_formatter" },
        },
        dockerfile = {
            { kind = "linters", name = "hadolint" },
        },
        javascript = {
            { kind = "linters", name = "eslint_d" },
            { kind = "formatters", name = "prettier_d" },
        },
        javascriptreact = {
            { kind = "linters", name = "eslint_d" },
            { kind = "formatters", name = "prettier_d" },
        },
        typescript = {
            { kind = "linters", name = "eslint_d" },
            { kind = "formatters", name = vim.env.NVIM_EFM_LS_FORMATTERS_TYPESCRIPT or "prettier_d" },
        },
        typescriptreact = {
            { kind = "linters", name = "eslint_d" },
            { kind = "formatters", name = vim.env.NVIM_EFM_LS_FORMATTERS_TYPESCRIPT or "prettier_d" },
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
            { kind = "linters", name = "statix" },
        },
        sql = {
            { kind = "formatters", name = "sql-formatter" },
        },
    },
})

---@type vim.lsp.Config
return {
    filetypes = efm_configs.filetypes,
    init_options = {
        documentFormatting = true,
        rangeFormatting = true,
        hover = true,
        documentSymbol = true,
        codeAction = true,
        completion = false,
    },
    settings = {
        rootMarkers = { ".git/" },
        languages = efm_configs.languages,
    },
}
