local config = {}

local wezterm = require("wezterm")

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config = require("configs.font").setup(config)

--vimで日本語入力するときは、skkeletonを使っているから問題無い
config.use_ime = false

-- If set to true, when there is only a single tab, the tab bar is hidden from the display.
-- If a second tab is created, the tab will be shown.
config.hide_tab_bar_if_only_one_tab = true

config.color_scheme = "nordfox"

config.window_background_opacity = 0.8

config.window_padding = {
    left = 5,
    top = 5,
    right = 0,
    bottom = 0,
}

-- Configures the boundaries of a word,
-- thus what is selected when doing a word selection with the mouse.
config.selection_word_boundary = [=[ \t\n{}[]()"'`.,;:]=]

config.scrollback_lines = 5000

return config
