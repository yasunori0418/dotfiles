local wezterm = require('wezterm')

return {
    use_ime = false, --vimで日本語入力するときは、skkeletonを使っているから問題無い

    font = wezterm.font("Cica"),
    fot_size = 10.0,
    adjust_window_size_when_changing_font_size = false,

    hide_tab_bar_if_only_one_tab = true,

    color_scheme = 'duskfox',
    color_scheme_dirs = { "$HOME/.config/wezterm/colors/" },

    window_background_opacity = 0.8,
    window_padding = {
        left = 2,
        right = 2,
        top = 0,
        bottom = 0,
    },

    selection_word_boundary = " \t\n{}[]()\"'`,;:",

    disable_default_key_bindings = true,
}
