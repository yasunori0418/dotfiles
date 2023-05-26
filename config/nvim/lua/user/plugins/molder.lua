local M = {}

M.init = function()
  if vim.fn.isdirectory(vim.fn.expand('%:p')) ~= 0 then
    require('dein').source('vim-molder')
    vim.fn['molder#init']()
    vim.api.nvim_del_augroup_by_name('vimrc_molder')
  end
end


M.cd = function()
  if vim.opt.filetype:get() == 'molder' then
    local molder_cwd = vim.fn.substitute(
      vim.fn.bufname(vim.fn.bufnr()),
      vim.env.HOME, '~', '')
    molder_cwd = vim.fn.substitute(molder_cwd, '/$', '', '')
    vim.fn.chdir(molder_cwd)
    vim.print('Change current working directory to [' .. molder_cwd .. ']')
  end
end

return M
