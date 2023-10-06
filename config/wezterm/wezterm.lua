local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

--vimで日本語入力するときは、skkeletonを使っているから問題無い
config.use_ime = false

-- HackGen好き
config.font = wezterm.font("HackGen35 Console NF")

-- フォントサイズは偶数でないと変になる。
config.font_size = 16.0

-- If you use a tiling window manager then you may wish to set this to `false`.
config.adjust_window_size_when_changing_font_size = false

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
