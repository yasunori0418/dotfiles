# INFO: https://qiita.com/kotashiratsuka/items/ae37757aa1d31d1d4f4d
# INFO: https://qiita.com/syui/items/ed2d36698a5cc314557d

# 補完候補をカーソル選択できるようにする。
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1

#大文字、小文字を区別せず補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

# apt-getとかdpkgコマンドをキャッシュを使って速くする
zstyle ':completion:*' use-cache true

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

#rehash不要にする
zstyle ":completion:*:commands" rehash 1

#補完でカラーを使用する
zstyle ':completion:*' list-colors ${LS_COLORS}

#kill の候補にも色付き表示
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

#コマンドにsudoを付けても補完
zstyle ':completion:*:sudo:*' command-path /usr/local/bin /usr/bin /bin /usr/local/sbin

#何も入力されていないときのTABでTABが挿入されるのを抑制
zstyle ':completion:*' insert-tab false

# セパレータを設定する
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true
