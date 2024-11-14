# unbind all keybinds
# HACK: わざわざrunを使うのは、ハイライトが壊れるため
# run 'tmux unbind -a -q' # これで全てのキーを設定させていただける

# prefix keys
set -g prefix C-z
bind C-z send-prefix

source ~/.config/tmux/keybinds/copy_mode.tmux

bind R source-file ~/.config/tmux/tmux.conf \; display-message "loading source-file done"

bind x confirm-before -p "kill-pane #P? (y/n)" kill-pane
bind s split-window -v -c '#{pane_current_path}'
bind v split-window -h -c '#{pane_current_path}'

bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

bind c new-window -c "#{pane_current_path}"
bind C new-session

bind a choose-tree
bind e choose-session
bind w choose-tree -w

# vim:ft=tmux
