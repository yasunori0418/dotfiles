local joinpath = vim.fs.joinpath
local cache = vim.fn.stdpath("cache") --[[@as string]]
-- Use utf-8 to overall encoding.
vim.opt.encoding = "utf-8"

-- Use utf-8 when file write.
vim.opt.fileencoding = "utf-8"

-- Use file encodings when loaded.
vim.opt.fileencodings = { "utf-8", "sjis", "iso-2022-jp", "euc-jp" }

-- Automatic line feed code recognition.
vim.opt.fileformats = { "unix", "dos", "mac" }

-- backup.
vim.opt.backup = true
vim.opt.backupdir = joinpath(cache, "backup")

-- swapfile.
vim.opt.swapfile = true
vim.opt.directory = joinpath(cache, "swap")

-- UNDOをどうぞ
vim.opt.undodir = joinpath(cache, "undo")
vim.opt.undofile = true

-- shada(viminfo)
vim.opt.shada = {
    [[!]],
    [['100]],
    [[<50]],
    [[s10]],
    [[h]],
    [[n]] .. joinpath(cache, "shada"),
}

vim.opt.grepprg = [[rg --vimgrep --no-heading $*]]
vim.opt.grepformat = [[%f:%l:%c:%m]]

-- 早くなるんか…？
vim.opt.ttyfast = true

-- East asia ambiguous character width problem.
vim.opt.ambiwidth = "single"

vim.opt.autoread = true

-- Use the clipboard on linux systems.
vim.opt.clipboard = {
    "unnamed",
    "unnamedplus",
}

vim.opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "vertical",
    "algorithm:histogram",
    "indent-heuristic",
    "linematch:60",
    "iwhiteall",
    "iblank",
}

-- For pum.vim
vim.opt.shortmess = {
    a = true, --[[filmnrwx]]
    o = true,
    O = true,
    s = true,
    t = true,
    T = true,
    W = true,
    I = true,
    c = true,
    C = true,
    F = true,
}

-- jump momentarily to a matching parenthesis
vim.opt.showmatch = true
vim.opt.matchtime = 1

-- disable wildmode
vim.opt.wildchar = 0
vim.opt.wildcharm = 0
vim.opt.wildmenu = false

-- Display rows number.
vim.opt.number = true

-- Display relative rows number.
vim.opt.relativenumber = false

-- Display current row cursorline.
vim.opt.cursorline = false

-- disable ruler display.
vim.opt.ruler = false

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

vim.opt.history = 100

-- Invisible characters
vim.opt.list = true

vim.opt.virtualedit = "block"

-- Tab/End line Space/End line/No brake space.
vim.opt.listchars = {
    tab = "»-",
    space = "･",
    trail = "･",
    nbsp = "%",
    eol = "↲",
    extends = "»",
    precedes = "«",
}

-- Disable default plugins
-- Fast Startup Settings!!
-- Disable TOhtml.
vim.g.loaded_2html_plugin = true

-- Disable archive file open and browse.
vim.g.loaded_gzip = true
vim.g.loaded_tar = true
vim.g.loaded_tarPlugin = true
vim.g.loaded_zip = true
vim.g.loaded_zipPlugin = true

-- Disable vimball.
vim.g.loaded_vimball = true
vim.g.loaded_vimballPlugin = true

-- Disable netrw plugins.
vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true
vim.g.loaded_netrwSettings = true
vim.g.loaded_netrwFileHandlers = true

-- Disable `GetLatestVimScript`.
vim.g.loaded_getscript = true
vim.g.loaded_getscriptPlugin = true

-- Disable other plugins
vim.g.loaded_matchit = true
vim.g.loaded_matchparen = true
vim.g.loaded_shada_plugin = true
vim.g.loaded_spellfile_plugin = true
vim.g.loaded_tutor_mode_plugin = true
vim.g.did_install_default_menus = true
vim.g.did_install_syntax_menu = true
vim.g.skip_loading_mswin = true
vim.g.did_indent_on = true
vim.g.loaded_rrhelper = true

-- Disable neovim language api providers
vim.g.loaded_python3_provider = true
vim.g.loaded_node_provider = true
vim.g.loaded_perl_provider = true
vim.g.loaded_ruby_provider = true

vim.filetype.add({
    extension = {
        jsonc = "jsonc",
        json5 = "json5",
        uml = "plantuml",
    },
    filename = {
        [".env"] = "conf",
        [".textlintrc"] = "json",
    },
    pattern = {
        [".*%.blade%.php"] = "blade",
        [".*/i3/.*"] = "i3config",
    },
})
