-- lua_source {{{

vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.laststatus = 3

vim.g.lightline = {
  colorscheme = 'nordfox',
  active = {
    left = {
      {'mode', 'paste', 'skk_mode'},
      {'relativepath', 'modified'},
    },
    right = {
      {'percent', 'lineinfo'},
      {'fileformat', 'fileencoding', 'filetype'},
    },
  },
  inactive = {
    left = {
      {'filename'}
    },
    right = {
      {'lineinfo'},
      {'percent'},
    },
  },
  tabline = {
    left = {
      {'tabs'},
    },
    right = {
      {'git_branch'},
    },
  },
  tab = {
    active = {'tabnum', 'filename', 'modified'},
    inactive = {'tabnum', 'filename'},
  },
  separator = {
    left = '',
    right = '',
  },
  subseparator = {
    left = '',
    right = ' ',
  },
  component_function = {
    git_branch = 'vimrc#lightline_git_branch',
    mode = 'vimrc#lightline_custom_mode',
    skk_mode = 'lightline_skk#mode',
  },
}

-- command! -bar LightlineUpdate call lightline#init()| call lightline#colorscheme()| call lightline#update()

-- }}}
