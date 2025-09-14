-- Enables the experimental Lua module loader
vim.loader.enable()

require("user.rc").setup()

vim.cmd([[filetype plugin indent on]])
vim.cmd([[syntax enable]])
