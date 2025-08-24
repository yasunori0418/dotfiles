local vimrc = vim.api.nvim_create_augroup("vimrc", { clear = true })

require("user.utils").autocmds_set({
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
    {
        events = { "CursorHold" },
        group = vimrc,
        pattern = "*",
        callback = function()
            vim.opt.cursorline = true
        end,
    },
    {
        events = { "CursorMoved" },
        group = vimrc,
        pattern = "*",
        callback = function()
            vim.opt.cursorline = false
        end,
    },
})
