local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local user_filename_filetype = augroup('user_filename_filetype', {clear = true})
local user_nolisted_buffer = augroup('user_nolisted_buffer', {clear = true})
local user_quickfix = augroup('user_quickfix', {clear = true})

local autocmds = {
  {
    events = {'BufNewFile', 'BufRead'},
    group = user_filename_filetype,
    pattern = {'.textlintrc'},
    callback = function()
      vim.opt_local.filetype = 'json'
    end
  },
  {
    events = {'BufNewFile', 'BufRead'},
    group = user_filename_filetype,
    pattern = {'*.blade.*'},
    callback = function()
      vim.opt_local.filetype = 'html'
    end
  },
  {
    events = {'BufNewFile', 'BufRead'},
    group = user_filename_filetype,
    pattern = {'*.uml'},
    callback = function()
      vim.opt_local.filetype = 'plantuml'
    end
  },
  {
    events = {'BufNewFile', 'BufRead'},
    group = user_filename_filetype,
    pattern = {'*/i3/config'},
    callback = function()
      vim.opt_local.filetype = 'i3config'
    end
  },
  {
    events = {'FileType'},
    group = user_nolisted_buffer,
    pattern = {'gin-*'},
    callback = function()
      vim.opt_local.buflisted = true
    end
  },
  {
    events = {'QuickFixCmdPost'},
    group = user_quickfix,
    pattern = {'*grep*'},
    callback = function()
      vim.cmd [[cwindow]]
    end
  },
}

for _, item in pairs(autocmds) do
  autocmd(item.events, {
    group = item.group,
    pattern = item.pattern,
    callback = item.callback,
  })
end
