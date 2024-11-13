# unbind all keybinds
# HACK: わざわざrunを使うのは、ハイライトが壊れるため
# run 'tmux unbind -a -q' # これで全てのキーを設定させていただける

# prefix keys
set -g prefix C-z
bind C-z send-prefix

source ~/.config/tmux/keybinds/copy_mode.tmux

bind R source-file ~/.config/tmux/tmux.conf \; display-message "loading source-file done"

bind x confirm-before -p "kill-pane #P? (y/n)" kill-pane
bind -n M-s split-window -v -c '#{pane_current_path}'
bind -n M-v split-window -h -c '#{pane_current_path}'

bind -n M-h select-pane -L
bind -n M-j select-pane -D
bind -n M-k select-pane -U
bind -n M-l select-pane -R

bind -n M-n new-window -c "#{pane_current_path}"
bind -n M-N new-session
bind -n M-\{ previous-window
bind -n M-\} next-window

bind -n M-a choose-tree
bind -n M-e choose-session
bind -n M-w choose-tree -w

# vim:ft=tmux
