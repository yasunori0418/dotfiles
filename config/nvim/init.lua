-- Enables the experimental Lua module loader
if vim.loader then
  vim.loader.enable()
end

require('user.rc').setup()

vim.cmd[[filetype plugin indent on]]
vim.cmd[[syntax enable]]
