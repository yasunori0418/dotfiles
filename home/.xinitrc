#!/bin/sh

# localectl --no-convert set-x11-keymap us pc105 "" ctrl:swapcaps
# こっちの方が優秀
# capswapコマンドを作ったので、これでキー配列は管理する
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# 本来なら以下のコードが必要だけど、lyで起動させるとよしなにxrdbしてくれるみたい。
# 明示的に読み込んでおくぞ
[[ -f ~/.Xresources ]] && xrdb ~/.Xresources

# Xの起動が間に合わないときの対処方法として、sleepさせるのもアリみたい。
#sleep 5

# 明示的に読み込まないといけないみたいね…
[[ -f ~/.xprofile ]] && source ~/.xprofile

exec i3
