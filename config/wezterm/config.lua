local config = {}

local wezterm = require("wezterm")
local keybinds = require("configs.keybinds")

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config = require("configs.font").setup(config)
config = require("configs.appearance").setup(config)

--vimで日本語入力するときは、skkeletonを使っているから問題無い
config.use_ime = false

-- Configures the boundaries of a word,
-- thus what is selected when doing a word selection with the mouse.
config.selection_word_boundary = [=[ \t\n{}[]()"'`.,;:]=]

config.scrollback_lines = 5000

config.disable_default_key_bindings = true
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

local machine_type = io.popen("uname -s"):read("*l")
if machine_type == "Linux" then
    config.front_end = [[OpenGl]]
elseif machine_type == "Darwin" then
    config.front_end = [[WebGpu]]
end

return config
