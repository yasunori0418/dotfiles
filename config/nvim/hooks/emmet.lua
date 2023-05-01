-- lua_add {{{

vim.g.user_emmet_install_global = false
-- vim.g.user_emmet_leader_key = "<C-y>"

vim.api.nvim_create_autocmd('FileType', {
  group = require('user.utils').vimrc_augroup,
  pattern = {'html', 'css', 'scss'},
  callback = function()
    vim.cmd[[EmmetInstall]]
  end,
})

local html5 = [[
<!DOCTYPE html>
<html lang="${lang}">
  <head>
    <meta charset="${charset}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title></title>
    <link rel="stylesheet" href="css/style.css">
  </head>
  <body>
    ${child}|
  </body>
</html>
]]

vim.g.user_emmet_settings = {
  variables = {
    lang = "ja",
  },
  html = {
    snippets = {
      html_5 = html5,
      lrl_s = [[{{ | }}]],
      lrl_e = [[{!! | !!}]],
    },
  },
}
-- }}}
