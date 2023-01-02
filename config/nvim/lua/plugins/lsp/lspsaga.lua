require('lspsaga').init_lsp_saga({
  border_style = 'single',
  finder_action_keys = {
    open = 'o',
    vsplit = 'v',
    split = 's',
    tabe = 't',
    quit = { 'q', '<ESC>' },
  },
  rename_action_quit = '<ESC>',
  rename_in_select = false,
  show_outline = {
    win_width = 40,
    auto_preview = false,
  },
})
