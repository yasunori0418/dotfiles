-- Fast startup hack of vim...
vim.cmd[[filetype off]]
vim.cmd[[filetype plugin indent off]]
vim.cmd[[syntax off]]

-- Enables the experimental Lua module loader
if vim.loader then
  vim.loader.enable()
end

-- dein base directory.
local dein_dir = vim.env.HOME .. "/.cache/dein"

-- dein.vim repository.
local dein_repo = dein_dir .. "/repos/github.com/Shougo/dein.vim"

-- my neovim config directory.
vim.g.base_dir = vim.fn.fnamemodify(vim.env.MYVIMRC, ":h")
vim.env.BASE_DIR = vim.g.base_dir

-- vimrc files written by lua script.
local vimrcs_dir = vim.g.base_dir .. "/rc/"
local inline_vimrcs = {
  "options.lua",
  "keymap.lua",
  "commands.lua",
  "autocmds.lua",
}

-- toml management by dein.
local toml_dir = vim.g.base_dir .. "/toml/"
local toml_files = {
  "ddc.toml",
  "ddu.toml",
  "dein.toml",
  "denops.toml",
  "git.toml",
  "lazy.toml",
  "lsp.toml",
  "tools.toml",
  "treesitter.toml",
}

if not vim.regex("/dein.vim"):match_str(vim.o.runtimepath) then
  if vim.fn.isdirectory(dein_repo) ~= 1 then
    os.execute("git clone https://github.com/Shougo/dein.vim " .. dein_repo)
  end
  vim.opt.runtimepath:prepend(dein_repo)
end

-- loading dein module
local dein = require("dein")

if vim.g.neovide then
  table.insert(inline_vimrcs, "neovide.lua")
end

for index, inline_vimrc in pairs(inline_vimrcs) do
  inline_vimrcs[index] = vimrcs_dir .. inline_vimrc
end

-- dein options
dein.setup({
  install_progress_type = "none",
  enable_notification = true,
  auto_recache = true,
  lazy_rplugins = true,
  install_check_diff = true,
  -- Strict check updated plugins yesterday
  install_check_remote_threshold = 24 * 60 * 60,
  inline_vimrcs = inline_vimrcs,
})

if dein.load_state(dein_dir) == 1 then
  dein.begin(dein_dir)
  for _, toml_file in pairs(toml_files) do
    local lazy_flag = true
    if toml_file == "dein.toml" then
      lazy_flag = false
    end
    dein.load_toml(toml_dir .. toml_file, { lazy = lazy_flag })
  end
  dein.end_()
  dein.save_state()
end

if dein.check_install() then
  dein.install()
end

vim.cmd[[filetype plugin indent on]]
vim.cmd[[syntax enable]]
