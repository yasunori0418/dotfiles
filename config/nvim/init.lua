-- Enables the experimental Lua module loader
vim.loader.enable()

-- dein base directory.
local dein_dir = vim.env.HOME .. '.cache/dein'

-- dein.vim repository.
local dein_repo = dein_dir .. '/repos/github.com/Shougo/dein.vim'

-- my neovim config directory.
vim.g.base_dir = vim.fn.fnamemodify(vim.env.MYVIMRC, ':h')
local vimrcs_dir = vim.g.base_dir .. '/rc/'
local toml_dir = vim.g.base_dir .. '/toml/'

if string.match(vim.opt.runtimepath, '/dein.vim') then
  if vim.fn.isdirectory(dein_repo) ~= 1 then
    os.execute('git clone https://github.com/Shougo/dein.vim ' .. dein_repo)
  end
  vim.opt.runtimepath:prepend(dein_repo)
end

-- loading dein module
local dein = require('dein')

local inline_vimrcs = {
  'options.lua',
  'keymap.lua',
  'commands.lua',
  'autocmds.lua',
}

if vim.g.neovide then
  table.insert(inline_vimrcs, 'neovide.vim')
end

-- dein options
dein.setup {
  install_progress_type = 'floating',
  enable_notification = true,
  auto_recache = true,
  lazy_rplugins = true,
  install_check_diff = true,
  -- Strict check updated plugins yesterday
  install_check_remote_threshold = 24 * 60 * 60,
}
