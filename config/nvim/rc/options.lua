local joinpath = vim.fs.joinpath
local cache = tostring(vim.fn.stdpath("cache"))
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

vim.opt.grepprg = [[rg --vimgrep --no-heading $*]]
vim.opt.grepformat = [[%f:%l:%c:%m]]

-- 早くなるんか…？
vim.opt.ttyfast = true

-- East asia ambiguous character width problem.
vim.opt.ambiwidth = "single"

vim.opt.autoread = true

-- Use the clipboard on linux systems.
vim.opt.clipboard = "unnamedplus"

vim.opt.diffopt:append({
    "internal",
    "filler",
    "closeoff",
    "vertical",
    "algorithm:histogram",
    "indent-heuristic",
    "linematch:60",
})

-- For pum.vim
vim.opt.shortmess:append("c")

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
vim.opt.relativenumber = true

-- Display current row cursorline.
vim.opt.cursorline = true

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
local disable_pluings = {
    -- Disable TOhtml.
    "loaded_2html_plugin",

    -- Disable archive file open and browse.
    "loaded_gzip",
    "loaded_tar",
    "loaded_tarPlugin",
    "loaded_zip",
    "loaded_zipPlugin",

    -- Disable vimball.
    "loaded_vimball",
    "loaded_vimballPlugin",

    -- Disable netrw plugins.
    "loaded_netrw",
    "loaded_netrwPlugin",
    "loaded_netrwSettings",
    "loaded_netrwFileHandlers",

    -- Disable `GetLatestVimScript`.
    "loaded_getscript",
    "loaded_getscriptPlugin",

    -- Disable other plugins
    "loaded_man",
    "loaded_matchit",
    "loaded_matchparen",
    "loaded_shada_plugin",
    "loaded_spellfile_plugin",
    "loaded_tutor_mode_plugin",
    "did_install_default_menus",
    "did_install_syntax_menu",
    "skip_loading_mswin",
    "did_indent_on",
    "loaded_rrhelper",

    -- Disable neovim language api providers
    "loaded_python3_provider",
    "loaded_node_provider",
    "loaded_perl_provider",
    "loaded_ruby_provider",
}

for _, disable_plugin in pairs(disable_pluings) do
    vim.g[disable_plugin] = true
end
