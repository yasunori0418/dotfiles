local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local vimrc = augroup('vimrc', {clear = true})

local autocmds = {
  {
    events = {'BufNewFile', 'BufRead'},
    group = vimrc,
    pattern = {'.textlintrc'},
    callback = function()
      vim.opt_local.filetype = 'json'
    end
  },
  {
    events = {'BufNewFile', 'BufRead'},
    group = vimrc,
    pattern = {'*.blade.*'},
    callback = function()
      vim.opt_local.filetype = 'html'
    end
  },
  {
    events = {'BufNewFile', 'BufRead'},
    group = vimrc,
    pattern = {'*.uml'},
    callback = function()
      vim.opt_local.filetype = 'plantuml'
    end
  },
  {
    events = {'BufNewFile', 'BufRead'},
    group = vimrc,
    pattern = {'*/i3/config'},
    callback = function()
      vim.opt_local.filetype = 'i3config'
    end
  },
  {
    events = {'FileType'},
    group = vimrc,
    pattern = {'gin-*'},
    callback = function()
      vim.opt_local.buflisted = true
    end
  },
  {
    events = {'QuickFixCmdPost'},
    group = vimrc,
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
