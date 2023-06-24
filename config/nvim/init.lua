-- Fast startup hack of vim...
vim.cmd[[filetype off]]
vim.cmd[[filetype plugin indent off]]
vim.cmd[[syntax off]]

-- Enables the experimental Lua module loader
if vim.loader then
  vim.loader.enable()
end

require('user.rc').setup()

vim.cmd[[filetype plugin indent on]]
vim.cmd[[syntax enable]]
