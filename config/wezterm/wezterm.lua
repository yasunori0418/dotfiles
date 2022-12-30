local wezterm = require('wezterm')

local my_keybinds = {

  -- Keybinds of Copy and Paste.
  {key = "c", mods = "CTRL|SHIFT", action = wezterm.action({CopyTo = "Clipboard"})},
  {key = "v", mods = "CTRL|SHIFT", action = wezterm.action({PasteFrom = "Clipboard"})},
  {key = "Insert", mods = "CTRL", action = wezterm.action({CopyTo = "PrimarySelection"})},
  {key = "Insert", mods = "SHIFT", action = wezterm.action({PasteFrom = "PrimarySelection"})},
  --{key = "c", mods = "ALT", action = wezterm.action({CopyTo = "Clipboard"})},
  --{key = "v", mods = "ALT", action = wezterm.action({PasteFrom = "Clipboard"})},

  -- Copy mode like visual mode of vim.
  {key = "x", mods = "ALT", action = "ActivateCopyMode"},
  {key = " ", mods = "ALT", action = "QuickSelect"},

  -- Reload Configaration.
  {key = "r", mods = "ALT", action = "ReloadConfiguration"},

  -- Keybinds of change font size.
  {key = "-", mods = "CTRL", action = "DecreaseFontSize"},
  {key = "=", mods = "CTRL", action = "IncreaseFontSize"},
  {key = "0", mods = "CTRL", action = "ResetFontSize"},

  -- Keybinds of controlling terminal tab.
  {key = 't', mods = 'ALT', action = wezterm.action({SpawnTab = 'CurrentPaneDomain'})},
  {key = 't', mods = 'ALT|SHIFT', action = wezterm.action({SpawnTab = 'DefaultDomain'})},
  {key = "w", mods = "ALT", action=wezterm.action({CloseCurrentTab = {confirm=true}})},
  {key = "w", mods = "ALT|SHIFT", action = wezterm.action({CloseCurrentTab = {confirm = false}})},
  {key = "[", mods = "ALT|SHIFT", action = wezterm.action({ActivateTabRelative = -1})},
  {key = "]", mods = "ALT|SHIFT", action = wezterm.action({ActivateTabRelative = 1})},

  -- Keybinds of controlling terminal pane.
  {key = 'v', mods = 'ALT', action = wezterm.action({SplitHorizontal = {domain = 'CurrentPaneDomain'}})},
  {key = ';', mods = 'ALT', action = wezterm.action({SplitVertical = {domain = 'CurrentPaneDomain'}})},
  {key = "w", mods = "ALT", action = wezterm.action({CloseCurrentPane = {confirm = true}})},
  {key = "w", mods = "ALT|SHIFT", action = wezterm.action({CloseCurrentPane = {confirm = false}})},
  {key = "h", mods = "ALT", action = wezterm.action({ActivatePaneDirection = 'Left'})},
  {key = "j", mods = "ALT", action = wezterm.action({ActivatePaneDirection = 'Down'})},
  {key = "k", mods = "ALT", action = wezterm.action({ActivatePaneDirection = 'Up'})},
  {key = "l", mods = "ALT", action = wezterm.action({ActivatePaneDirection = 'Right'})},
  {key = "[", mods = "ALT", action = wezterm.action({ActivatePaneDirection = 'Prev'})},
  {key = "]", mods = "ALT", action = wezterm.action({ActivatePaneDirection = 'Next'})},
}

return {
  use_ime = false, --vimで日本語入力するときは、skkeletonを使っているから問題無い

  font = wezterm.font('Cica'),
  font_size = 12.0,
  -- Must setting when tile window manager.
  adjust_window_size_when_changing_font_size = false,

  hide_tab_bar_if_only_one_tab = true,

  -- colorscheme settings
  color_scheme = 'nordfox',
  color_scheme_dirs = { '$HOME/.config/wezterm/colors/' },

  window_background_opacity = 0.8,
  window_padding = {
    left = 5,
    top = 5,
    right = 0,
    bottom = 0,
  },

  selection_word_boundary = " \t\n{}[]()\"'`,;:",

  scrollback_lines = 5000,

  disable_default_key_bindings = true,
  keys = my_keybinds,
  mouse_bindings = {
    -- Ctrl-click will open the link under the mouse cursor
    {
    event = {Up = {streak = 1, button = "Left"}},
    mods = "CTRL",
    action = "OpenLinkAtMouseCursor",
    },
  },
}
