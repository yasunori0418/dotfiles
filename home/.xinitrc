#!/bin/sh

# localectl --no-convert set-x11-keymap us pc105 "" ctrl:swapcaps こっちの方が優秀
#[[ -f ~/.Xmodmap ]] || xmodmap ~/.Xmodmap

# 本来なら以下のコードが必要だけど、lyで起動させるとよしなにxrdbしてくれるみたい。
#[[ -f ~/.Xresources ]] || xrdb ~/.Xresources

# Xの起動が間に合わないときの対処方法として、sleepさせるのもアリみたい。
#sleep 5

i3
