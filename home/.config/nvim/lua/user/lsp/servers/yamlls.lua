require("user.lsp.utils").config("yamlls", {
    settings = {
        yaml = {
            format = {
                enable = true,
                singleQuote = false,
                bracketSpacing = true,
                proseWrap = "Never",
            },
            validate = true,
            hover = true,
            completion = true,
            schemaStore = {
                enable = true,
            },
            customTags = {
                "!fn",
                "!And",
                "!If",
                "!Not",
                "!Equals",
                "!Or",
                "!FindInMap sequence",
                "!Base64",
                "!Cidr",
                "!Ref",
                "!Ref Scalar",
                "!Sub",
                "!GetAtt",
                "!GetAZs",
                "!ImportValue",
                "!Select",
                "!Split",
                "!Join sequence",
            },
            schemas = {
                ["https://json.schemastore.org/hugo.json"] = "hugo.yaml",
            },
        },
    },
})
