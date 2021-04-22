#!/usr/bin/env bash
# rofi_launch.sh / JennyM 2016 malkalech.com

alpha="cc"   # opacity (00〜FF)

options=(
  -modi            "combi,system:rofi_sys_menu.sh,calc:qalc,run,ssh"
  -combi-modi      "window"
  -show            "combi"
  -font            "HackGenNerd 18"
  -width           "100"
  -padding         "80"
  -lines           "8"
  -fixed-num-lines
  -hide-scrollbar
  -sidebar-mode

  ##  key bindings  ##
  -kb-cancel        "Escape,Control+g,Control+bracketleft,Control+c"
  -kb-mode-next     "Shift+Right,Control+i,Control+Tab"
  -kb-mode-previous "Shift+Left,Control+Shift+i"

  #### color scheme
  -color-enabled   "true"
  ## window         bg                   border               separator
  -color-window    "argb:${alpha}040404, argb:${alpha}040404, argb:${alpha}458588"
  ## text & cursor  bg             fg                   bg (alt)       bg (highlight)       fg (highlight)
  -color-normal    "argb:00000000, argb:${alpha}458588, argb:00000000, argb:${alpha}076678, argb:${alpha}83a598"
  -color-active    "argb:00000000, argb:${alpha}689d6a, argb:00000000, argb:${alpha}427b58, argb:${alpha}8ec07c"
  -color-urgent    "argb:00000000, argb:${alpha}b16286, argb:00000000, argb:${alpha}8f3f71, argb:${alpha}d3869b"
)

rofi "$@" "${options[@]}"
