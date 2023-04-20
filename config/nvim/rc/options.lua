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
    undodir = vim.fn.stdpath('cache') .. '/undo',
    undofile = true,

    -- East asia ambiguous character width problem.
    ambiwidth = 'single',

    autoread = true,

    -- Use the clipboard on linux systems.
    clipboard = 'unnamedplus',

    -- Open diff mode vertically
    diffopt = 'vertical',

    -- For pum.vim
    shortmess = 'c',

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

local option_array_pattern = [[fileencodings\|fileformats\|listchars]]
local option_append_pattern = [[diffopt\|shortmess]]

for _, option_table in pairs(option_tables) do
  for option_key, option_value in pairs(option_table) do
    if type(option_value) == 'table' then
      if vim.regex(option_array_pattern):match_str(option_key) then
        vim.opt[option_key] = option_value
      end
    else
      if vim.regex(option_append_pattern):match_str(option_key) then
        vim.opt[option_key]:append(option_value)
      else
        vim.opt[option_key] = option_value
      end
    end
  end
end

-- Disable default plugins
-- Fast Startup Settings!!

-- Disable TOhtml.
-- vim.g.loaded_2html_plugin       = true

-- Disable archive file open and browse.
-- vim.g.loaded_gzip               = true
-- vim.g.loaded_tar                = true
-- vim.g.loaded_tarPlugin          = true
-- vim.g.loaded_zip                = true
-- vim.g.loaded_zipPlugin          = true

-- Disable vimball.
-- vim.g.loaded_vimball            = true
-- vim.g.loaded_vimballPlugin      = true

-- Disable netrw plugins.
-- vim.g.loaded_netrw              = true
-- vim.g.loaded_netrwPlugin        = true
-- vim.g.loaded_netrwSettings      = true
-- vim.g.loaded_netrwFileHandlers  = true

-- Disable `GetLatestVimScript`.
-- vim.g.loaded_getscript          = true
-- vim.g.loaded_getscriptPlugin    = true

-- Disable other plugins
-- vim.g.loaded_man                = true
-- vim.g.loaded_matchit            = true
-- vim.g.loaded_matchparen         = true
-- vim.g.loaded_shada_plugin       = true
-- vim.g.loaded_spellfile_plugin   = true
-- vim.g.loaded_tutor_mode_plugin  = true
-- vim.g.did_install_default_menus = true
-- vim.g.did_install_syntax_menu   = true
-- vim.g.skip_loading_mswin        = true
-- vim.g.did_indent_on             = true
-- vim.g.loaded_rrhelper           = true
