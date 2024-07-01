local M = {}

function M.setup(config)
    config.color_scheme = "nordfox"
    config.window_background_opacity = 0.8
    config.window_padding = {
        left = 5,
        top = 5,
        right = 0,
        bottom = 0,
    }
    -- If set to true, when there is only a single tab, the tab bar is hidden from the display.
    -- If a second tab is created, the tab will be shown.
    config.hide_tab_bar_if_only_one_tab = true

    config.use_fancy_tab_bar = false

    config.native_macos_fullscreen_mode = true

    return config
end

return M
