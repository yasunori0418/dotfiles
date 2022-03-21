local wezterm = require('wezterm')

return {
    font = wezterm.font("Cica"),
    use_ime = false, --vimで日本語入力するときは、skkeletonを使っているから問題無い
    fot_size = 10.0,
    hide_tab_bar_if_only_one_tab = true,
    color_scheme = 'duskfox',
    color_scheme_dirs = { "$HOME/.config/wezterm/colors/" },
    window_background_opacity = 0.8,
}
