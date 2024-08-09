local M = {}
local wezterm = require("wezterm")

function M.setup(config)
    -- HackGen好き
    config.font = wezterm.font("HackGen35 Console NF")
    -- config.font = wezterm.font("Moralerspace Neon NF")
    -- config.font = wezterm.font("Moralerspace Argon NF")
    -- config.font = wezterm.font("Moralerspace Xenon NF")
    -- config.font = wezterm.font("Moralerspace Radon NF")
    -- config.font = wezterm.font("Moralerspace Krypton NF")

    -- フォントサイズは偶数でないと変になる。
    config.font_size = 16.0

    -- If you use a tiling window manager then you may wish to set this to `false`.
    config.adjust_window_size_when_changing_font_size = false

    -- disable ligatures
    config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

    return config
end

return M
