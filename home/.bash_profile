#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] || source ~/.bashrc

export LESS="--ignore-case \
             --quit-if-one-screen \
             --no-init \
             --LONG-PROMPT \
             --RAW-CONTROL-CHARS \
             --hilite-search \
             --HILITE-UNREAD \
             --window=-4 \
             --tabs=4"

[[ -n $(toe -a | cut -f1 | grep 'xterm-256color') ]] && export TERM='xterm-256color'
