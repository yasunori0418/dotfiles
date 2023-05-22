local command = vim.api.nvim_create_user_command

command('DeinDelete',
  function()
    vim.fn['vimrc#dein_check_uninstall']()
  end,
  {})

command('DeinRecache',
  function()
    vim.fn['dein#recache_runtimepath']()
    vim.cmd 'qall'
  end,
  {})

command('DDCFuzzyFilter',
  function(opts)
    vim.fn['vimrc#ddc_change_filter'](opts.bang, 'fuzzy')
  end,
  { bang = true })

command('DDCNormalFilter',
  function(opts)
    vim.fn['vimrc#ddc_change_filter'](opts.bang, 'normal')
  end,
  { bang = true })

command('DDCEchoFilter',
  function()
    vim.fn['vimrc#ddc_change_filter'](1, '')
  end,
  {})
