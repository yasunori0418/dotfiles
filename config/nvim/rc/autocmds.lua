local vimrc = vim.api.nvim_create_augroup("vimrc", { clear = true })

require("user.utils").autocmds_set({
    {
        events = { "BufNewFile", "BufRead" },
        group = vimrc,
        pattern = { ".textlintrc" },
        callback = function()
            vim.opt_local.filetype = "json"
        end,
    },
    {
        events = { "BufNewFile", "BufRead" },
        group = vimrc,
        pattern = { "*.blade.*" },
        callback = function()
            vim.opt_local.filetype = "html"
        end,
    },
    {
        events = { "BufNewFile", "BufRead" },
        group = vimrc,
        pattern = { "*.uml" },
        callback = function()
            vim.opt_local.filetype = "plantuml"
        end,
    },
    {
        events = { "BufNewFile", "BufRead" },
        group = vimrc,
        pattern = { "*/i3/config" },
        callback = function()
            vim.opt_local.filetype = "i3config"
        end,
    },
    {
        events = { "FileType" },
        group = vimrc,
        pattern = { "gin-*" },
        callback = function()
            vim.opt_local.buflisted = false
        end,
    },
    {
        events = { "QuickFixCmdPost" },
        group = vimrc,
        pattern = { "*grep*" },
        callback = function()
            vim.cmd([[cwindow]])
        end,
    },
    {
        events = { "WinEnter" },
        group = vimrc,
        pattern = "*",
        callback = function()
            vim.cmd.checktime("%")
        end,
    },
})
