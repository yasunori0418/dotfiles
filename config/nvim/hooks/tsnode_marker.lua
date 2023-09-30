-- lua_source {{{
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("tsnode-marker-markdown", {}),
    pattern = "markdown",
    callback = function(ctx)
        require("tsnode-marker").set_automark(ctx.buf, {
            target = { "code_fence_content", "fenced_code_block_delimiter", "language" },
            hl_group = "DiffChange",
        })
    end,
})
-- }}}
