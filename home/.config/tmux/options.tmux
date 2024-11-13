# truecolor
set -g default-terminal "tmux-256color" # 基本的にはscreen-256colorかtmux-256colorを設定
set -ga terminal-overrides "$TERM:Tc" # tmuxを起動していない時のzshでの$TERMの値を指定

# index
set -g base-index 1
set -g pane-base-index 1

# base settings
set -g history-limit 100000
set -g default-command $SHELL
set -g escape-time 0
set -g editor $EDITOR
set -g exit-empty on
set -g exit-unattached on
set -g history-file "~/.zhistory"
set -g status-position top
set -g mode-keys vi
set -g status-keys emacs
set -g status-interval 5
set -g focus-events on
set -g set-clipboard off
set -g aggressive-resize on

# vim:ft=tmux
