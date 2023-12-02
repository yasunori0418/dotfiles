local M = {}

function M.init()
    if vim.fn.isdirectory(vim.fn.expand("%:p")) ~= 0 then
        require("dein").source("vim-molder")
        vim.fn["molder#init"]()
        vim.api.nvim_del_augroup_by_name("vimrc_molder")
    end
end

return M
