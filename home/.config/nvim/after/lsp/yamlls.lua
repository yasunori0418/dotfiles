local hugo_schema = "https://json.schemastore.org/hugo.json"
-- luacheck: ignore 631
local markdownlint_schema =
    "https://raw.githubusercontent.com/DavidAnson/markdownlint/refs/heads/main/schema/markdownlint-config-schema.json"

---@type vim.lsp.Config
return {
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
                [hugo_schema] = "hugo.yaml",
                [markdownlint_schema] = ".markdownlint.yaml",
            },
        },
    },
}
