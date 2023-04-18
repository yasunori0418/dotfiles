
local option_tables = {

  encoding_options = {
    -- Use utf-8 to overall encoding.
    encoding = 'utf-8',

    -- Use utf-8 when file write.
    fileencoding = 'utf-8',

    -- Use file encodings when loaded.
    fileencodings = { 'utf-8', 'sjis', 'iso-2022-jp', 'euc-jp' },

    -- Automatic line feed code recognition.
    fileformats = { 'unix', 'dos', 'mac' },
  },

  editor_options = {
    -- Disable backup.
    backup = false,

    -- Don't make swapfile.
    swapfile = false,

    -- UNDOをどうぞ
    undodir = '/home/yasunori/.cache/undo',--vim.fn.stdpath('cache') .. '/undo',
    undofile = true,

    -- East asia ambiguous character width problem.
    ambiwidth = 'single',

    autoread = true,

    -- Use the clipboard on linux systems.
    clipboard = { append = 'unnamedplus' },

    -- Open diff mode vertically
    diffopt = { append = 'vertical' },

    -- For pum.vim
    shortmess = { append = 'c' },

    -- jump momentarily to a matching parenthesis
    showmatch = true,
    matchtime = 1,
  },

  display_options = {
    -- Display rows number.
    number = true,

    -- Display relative rows number.
    relativenumber = true,

    -- Display current row cursorline.
    cursorline = true,
  },

  indent_options = {
    -- Smart indent.
    smartindent = true,
    autoindent = true,

    -- Insert tab with half-width space.
    expandtab = true,

    -- The amount of blank space to insert with each command or smart indent.
    shiftwidth = 2,

    -- Tab width with 2 spaces.
    tabstop = 2,

    -- Insert a tab with 2 minutes of half-width space.
    softtabstop = 2,
  },

  search_options = {
    -- Highlight search results
    hlsearch = true,

    -- Incremental search.
    -- Search starts when you enter the first character of the search word.
    incsearch = true,

    -- Search is not case sensitive
    ignorecase = true,

    -- Searching in lowercase ignores uppercase and lowercase
    smartcase = true,

    -- When the search progresses to the end of the file, search again from the beginning of the file.
    wrapscan = true,
  },

  invisible_chars_option = {

    -- Invisible characters
    list = true,

    -- Tab/End line Space/End line/No brake space.
    listchars = {
      tab = '»-',
      space = '･',
      trail = '･',
      nbsp = '%',
      eol = '↲',
      extends = '»',
      precedes = '«',
    },
  },

}

--[[
-- local options = {}
for _, option_table in pairs(option_tables) do
  for option_key, option_value in pairs(option_table) do
    -- print('option_key: ' .. option_key)
    if type(option_value) == 'table' then
      for key, value in pairs(option_value) do
        -- print(key .. ' => ' .. value)
      end
    else
      -- print(option_value)
    end
  end
end
--]]

-- Use utf-8 to overall encoding.
vim.opt.encoding = 'utf-8'

-- Use utf-8 when file write.
vim.opt.fileencoding = 'utf-8'

-- Use file encodings when loaded.
vim.opt.fileencodings = { 'utf-8', 'sjis', 'iso-2022-jp', 'euc-jp' }

-- Automatic line feed code recognition.
vim.opt.fileformats = { 'unix', 'dos', 'mac' }

-- Disable backup.
vim.opt.backup = false

-- Don't make swapfile.
vim.opt.swapfile = false

-- UNDOをどうぞ
vim.opt.undodir = vim.fn.stdpath('cache') .. '/undo'
vim.opt.undofile = true

-- East asia ambiguous character width problem.
vim.opt.ambiwidth = 'single'

vim.opt.autoread = true

-- Use the clipboard on linux systems.
vim.opt.clipboard:append('unnamedplus')

-- Open diff mode vertically
vim.opt.diffopt:append('vertical')

-- For pum.vim
vim.opt.shortmess:append('c')

-- jump momentarily to a matching parenthesis
vim.opt.showmatch = true
vim.opt.matchtime = 1

-- Display rows number.
vim.opt.number = true

-- Display relative rows number.
vim.opt.relativenumber = true

-- Display current row cursorline.
vim.opt.cursorline = true

-- Highlight search results
vim.opt.hlsearch = true

-- Incremental search.
-- Search starts when you enter the first character of the search word.
vim.opt.incsearch = true

-- Search is not case sensitive
vim.opt.ignorecase = true

-- Searching in lowercase ignores uppercase and lowercase
vim.opt.smartcase = true

-- When the search progresses to the end of the file, search again from the beginning of the file.
vim.opt.wrapscan = true

-- Smart indent.
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Insert tab with half-width space.
vim.opt.expandtab = true

-- The amount of blank space to insert with each command or smart indent.
vim.opt.shiftwidth = 2

-- Tab width with 2 spaces.
vim.opt.tabstop = 2

-- Insert a tab with 2 minutes of half-width space.
vim.opt.softtabstop = 2

-- Invisible characters
vim.opt.list = true

-- Tab/End line Space/End line/No brake space.
vim.opt.listchars = {
  tab = '»-',
  space = '･',
  trail = '･',
  nbsp = '%',
  eol = '↲',
  extends = '»',
  precedes = '«',
}

-- Disable default plugins
-- Fast Startup Settings!!

-- Disable TOhtml.
vim.g.loaded_2html_plugin       = true

-- Disable archive file open and browse.
vim.g.loaded_gzip               = true
vim.g.loaded_tar                = true
vim.g.loaded_tarPlugin          = true
vim.g.loaded_zip                = true
vim.g.loaded_zipPlugin          = true

-- Disable vimball.
vim.g.loaded_vimball            = true
vim.g.loaded_vimballPlugin      = true

-- Disable netrw plugins.
vim.g.loaded_netrw              = true
vim.g.loaded_netrwPlugin        = true
vim.g.loaded_netrwSettings      = true
vim.g.loaded_netrwFileHandlers  = true

-- Disable `GetLatestVimScript`.
vim.g.loaded_getscript          = true
vim.g.loaded_getscriptPlugin    = true

-- Disable other plugins
vim.g.loaded_man                = true
vim.g.loaded_matchit            = true
vim.g.loaded_matchparen         = true
vim.g.loaded_shada_plugin       = true
vim.g.loaded_spellfile_plugin   = true
vim.g.loaded_tutor_mode_plugin  = true
vim.g.did_install_default_menus = true
vim.g.did_install_syntax_menu   = true
vim.g.skip_loading_mswin        = true
vim.g.did_indent_on             = true
--vim.g.did_load_filetypes        = true
--vim.g.did_load_ftplugin         = true
vim.g.loaded_rrhelper           = true
