unbind -a -q -T copy-mode-vi # これでcopy-modeのキー全部を設定させていただける
unbind -a -q -T copy-mode # こっちは、emacs版のcopy-mode

# visual selection
bind-key -T copy-mode-vi C-c send-keys -X cancel
bind-key -T copy-mode-vi q send-keys -X cancel
bind-key -T copy-mode-vi Escape send-keys -X clear-selection
bind-key -T copy-mode-vi V send-keys -X select-line
bind-key -T copy-mode-vi v send-keys -X rectangle-off \; send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-on \; send-keys -X begin-selection
bind-key -T copy-mode-vi o send-keys -X other-end

# yank
bind-key -T copy-mode-vi y send-keys -X copy-pipe
bind-key -T copy-mode-vi d send-keys -X copy-pipe-end-of-line-and-cancel

# search
bind-key -T copy-mode-vi \% send-keys -X next-matching-bracket
bind-key -T copy-mode-vi \# send-keys -FX search-backward "#{copy_cursor_word}"
bind-key -T copy-mode-vi * send-keys -FX search-forward "#{copy_cursor_word}"
bind-key -T copy-mode-vi / command-prompt -T search -p "(search down)" { send-keys -X search-forward "%%" }
bind-key -T copy-mode-vi ? command-prompt -T search -p "(search up)" { send-keys -X search-backward "%%" }
bind-key -T copy-mode-vi n send-keys -X search-again
bind-key -T copy-mode-vi N send-keys -X search-reverse

# f-motion t-motion
bind-key -T copy-mode-vi f command-prompt -1 -p "(jump forward)" { send-keys -X jump-forward "%%" }
bind-key -T copy-mode-vi F command-prompt -1 -p "(jump backward)" { send-keys -X jump-backward "%%" }
bind-key -T copy-mode-vi t command-prompt -1 -p "(jump to forward)" { send-keys -X jump-to-forward "%%" }
bind-key -T copy-mode-vi T command-prompt -1 -p "(jump to backward)" { send-keys -X jump-to-backward "%%" }
bind-key -T copy-mode-vi , send-keys -X jump-reverse
bind-key -T copy-mode-vi \; send-keys -X jump-again

# cursor move
bind-key -T copy-mode-vi 0 send-keys -X back-to-indentation
bind-key -T copy-mode-vi ^ send-keys -X start-of-line
bind-key -T copy-mode-vi \$ send-keys -X end-of-line
bind-key -T copy-mode-vi H send-keys -X top-line
bind-key -T copy-mode-vi M send-keys -X middle-line
bind-key -T copy-mode-vi L send-keys -X bottom-line
bind-key -T copy-mode-vi h send-keys -X cursor-left
bind-key -T copy-mode-vi j send-keys -X cursor-down
bind-key -T copy-mode-vi k send-keys -X cursor-up
bind-key -T copy-mode-vi l send-keys -X cursor-right
bind-key -T copy-mode-vi W send-keys -X next-space
bind-key -T copy-mode-vi E send-keys -X next-space-end
bind-key -T copy-mode-vi B send-keys -X previous-space
bind-key -T copy-mode-vi w send-keys -X next-word
bind-key -T copy-mode-vi e send-keys -X next-word-end
bind-key -T copy-mode-vi b send-keys -X previous-word

# page move
bind-key -T copy-mode-vi z send-keys -X scroll-middle
bind-key -T copy-mode-vi \{ send-keys -X previous-paragraph
bind-key -T copy-mode-vi \} send-keys -X next-paragraph
bind-key -T copy-mode-vi C-f send-keys -X page-down
bind-key -T copy-mode-vi C-b send-keys -X page-up
bind-key -T copy-mode-vi C-d send-keys -X halfpage-down
bind-key -T copy-mode-vi C-u send-keys -X halfpage-up
bind-key -T copy-mode-vi C-y send-keys -X scroll-up
bind-key -T copy-mode-vi C-e send-keys -X scroll-down
bind-key -T copy-mode-vi : command-prompt -p "(goto line)" { send-keys -X goto-line "%%" }
bind-key -T copy-mode-vi g send-keys -X history-top
bind-key -T copy-mode-vi G send-keys -X history-bottom

# 多分、カウントリピート
bind-key -T copy-mode-vi 1 command-prompt -N -I 1 -p (repeat) { send-keys -N "%%" }
bind-key -T copy-mode-vi 2 command-prompt -N -I 2 -p (repeat) { send-keys -N "%%" }
bind-key -T copy-mode-vi 3 command-prompt -N -I 3 -p (repeat) { send-keys -N "%%" }
bind-key -T copy-mode-vi 4 command-prompt -N -I 4 -p (repeat) { send-keys -N "%%" }
bind-key -T copy-mode-vi 5 command-prompt -N -I 5 -p (repeat) { send-keys -N "%%" }
bind-key -T copy-mode-vi 6 command-prompt -N -I 6 -p (repeat) { send-keys -N "%%" }
bind-key -T copy-mode-vi 7 command-prompt -N -I 7 -p (repeat) { send-keys -N "%%" }
bind-key -T copy-mode-vi 8 command-prompt -N -I 8 -p (repeat) { send-keys -N "%%" }
bind-key -T copy-mode-vi 9 command-prompt -N -I 9 -p (repeat) { send-keys -N "%%" }

# マウス…まぁあっても困らんか… (デフォルト)
bind-key -T copy-mode-vi MouseDown1Pane select-pane
bind-key -T copy-mode-vi MouseDrag1Pane select-pane \; send-keys -X begin-selection
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xsel -i --primary"
bind-key -T copy-mode-vi WheelUpPane select-pane \; send-keys -X -N 5 scroll-up
bind-key -T copy-mode-vi WheelDownPane select-pane \; send-keys -X -N 5 scroll-down
bind-key -T copy-mode-vi DoubleClick1Pane select-pane \; send-keys -X select-word \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel
bind-key -T copy-mode-vi TripleClick1Pane select-pane \; send-keys -X select-line \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel

bind-key -T copy-mode-vi C-l send-keys -X refresh-from-pane

# vim:ft=tmux
