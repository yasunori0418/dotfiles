#!/usr/bin/env -S awk -f

function cmd_accent(char) {
  accent = start front_cyan accent_bold end
  return accent char reset
}

function ex_comment_accent(char) {
  accent = start front_black back_cyan accent_bold accent_underline end
  return accent char reset
}

BEGIN {
  FS = ":.*?## "

  padding_32 = "                                "

  ## エスケープシーケンス・コレクション ##
  esc = "\033"
  reset = esc "[0m"
  start = esc "["

  # 前景色
  front_black =";30"
  front_red = ";31"
  front_green = ";32"
  front_yellow = ";33"
  front_blue = ";34"
  front_magenta = ";35"
  front_cyan = ";36"
  front_white = ";37"

  # 背景色
  back_black = ";40"
  back_red = ";41"
  back_green = ";42"
  back_yellow = ";43"
  back_blue = ";44"
  back_magenta = ";45"
  back_cyan = ";46"
  back_white = ";47"

  # 表示アクセント
  accent_bold = ";1" # 太字
  accent_thin = ";2" # 薄く表示
  accent_italic = ";3" # イタリック
  accent_underline = ";4" # アンダーライン
  accent_blink = ";5" # ブリンク(点滅)
  accent_quickblink = ";6" # 高速ブリンク(高速点滅)
  accent_inversion = ";7" # 文字色と背景色の反転
  accent_hide = ";8" # 表示を隠す(コピペは可能)
  accent_strikeout = ";9" # 取り消し線

  # エスケープシーケンス終了
  end = "m"

  line_accent = start back_cyan end padding_32 reset
}

/^[%a-zA-Z_-]+:.*?## .*$/ {
  sub("※.*$", "\n" padding_32 "&\n")
  printf(cmd_accent("%-30s") " %s\n", $1, $2)
}

/^## .* ##$/ {
  sub("^## ", "")
  sub(" ##$", "")
  printf("\n" line_accent ex_comment_accent("%s") "\n", $0)
}
