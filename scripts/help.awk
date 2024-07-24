#!/usr/bin/awk -f

function cmd_acent(char) {
  acent = start front_cyan acent_bold end
  return acent char reset
}

function ex_comment_acent(char) {
  acent = start front_black back_cyan acent_bold acent_underline end
  return acent char reset
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
  acent_bold = ";1" # 太字
  acent_thin = ";2" # 薄く表示
  acent_italic = ";3" # イタリック
  acent_underline = ";4" # アンダーライン
  acent_blink = ";5" # ブリンク(点滅)
  acent_quickblink = ";6" # 高速ブリンク(高速点滅)
  acent_inversion = ";7" # 文字色と背景色の反転
  acent_hide = ";8" # 表示を隠す(コピペは可能)
  acent_strikeout = ";9" # 取り消し線

  # エスケープシーケンス終了
  end = "m"

  line_acent = start back_cyan end padding_32 reset
}

/^[a-zA-Z_-]+:.*?## .*$/ {
  sub("※.*$", "\n" padding_32 "&\n")
  printf(cmd_acent("%-30s") " %s\n", $1, $2)
}

/^## .* ##$/ {
  sub("^## ", "")
  sub(" ##$", "")
  printf("\n" line_acent ex_comment_acent("%s") "\n", $0)
}
