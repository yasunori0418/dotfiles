# For tpm setup
# HACK: わざわざrunを使うのは、ハイライトが壊れるため
run 'tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "${XDG_CACHE_HOME}/tmux/plugins"'

# List of plugins
set -g @plugin "tmux-plugins/tpm"
set -g @plugin "tmux-plugins/tmux-yank"

# 見た目は重要
set -g @plugin "nordtheme/tmux"
set -g @plugin "tmux-plugins/tmux-prefix-highlight"
set -g @prefix_highlight_show_copy_mode 'on'
set -g @prefix_highlight_show_sync_mode 'on'
set -g @prefix_highlight_prefix_prompt 'Wait'
set -g @prefix_highlight_copy_prompt 'Copy'
set -g @prefix_highlight_sync_prompt 'Sync'

set -g @plugin 'tmux-plugins/tmux-open'
set -g @open 'o'

set -g @plugin 'schasse/tmux-jump'
set -g @jump-key 'J'

set -g @plugin 'tmux-plugins/tmux-copycat'

run -b '${XDG_CONFIG_HOME}/tmux/initial'

# vim:ft=tmux
