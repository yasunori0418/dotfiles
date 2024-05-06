return function()
    require("lspconfig").denols.setup({
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
