# unbind all keybinds
# HACK: わざわざrunを使うのは、ハイライトが壊れるため
# run 'tmux unbind -a -q' # これで全てのキーを設定させていただける

# prefix keys
set -g prefix C-z
bind C-z send-prefix

# vim:ft=tmux
