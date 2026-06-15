---@type vim.diagnostic.Opts
local config = {
    underline = true,
    virtual_text = false,
    virtual_lines = {
        current_line = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
    float = {
        border = "rounded",
        severity_sort = true,
    },
    severity_sort = true,
    jump = {
        on_jump = function(_, bufnr)
            vim.diagnostic.open_float({
                bufnr = bufnr,
                scope = "cursor",
                focus = false,
            })
        end,
    },
}

vim.diagnostic.config(config)
