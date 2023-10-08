local efm_configs = require("user.plugins.efm_configs")

efm_configs.setup({
    all_installs = false,
    filetypes = {
        python = {
            { kind = "formatters", name = "black" },
            { kind = "linters", name = "flake8" },
        },
        lua = {
            { kind = "formatters", name = "stylua" },
            { kind = "linters", name = "luacheck" },
        },
        markdown = {
            { kind = "linters", name = "textlint", auto_install = false },
            { kind = "linters", name = "markdownlint" },
        },
        vim = {
            { kind = "linters", name = "vint" },
        },
        json = {
            { kind = "formatters", name = "jq" },
            { kind = "linters", name = "jq" },
        },
        yaml = {
            { kind = "linters", name = "yamllint" },
            { kind = "formatters", name = "yq" },
        },
        php = {
            { kind = "linters", name = "phpstan" },
            { kind = "formatters", name = "pint" },
        },
        dockerfile = {
            { kind = "linters", name = "hadolint" },
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
            completion = true,
        },
        capabilities = require("user.lsp.utils").capabilities,
        settings = {
            rootMarkers = { ".git/" },
            languages = efm_configs.languages,
        },
    })
end

