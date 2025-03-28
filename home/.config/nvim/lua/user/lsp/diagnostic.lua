local diagnostic = vim.diagnostic

diagnostic.config({
    underline = true,
    virtual_text = false,
    virtual_lines = {
        current_line = true,
    },
    signs = {
        text = {
            [diagnostic.severity.ERROR] = "",
            [diagnostic.severity.WARN] = "",
            [diagnostic.severity.INFO] = "",
            [diagnostic.severity.HINT] = "",
        },
    },
    float = {
        border = "rounded",
        severity_sort = true,
    },
    severity_sort = true,
    jump = {
        float = true,
    },
})
