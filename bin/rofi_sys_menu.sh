#!/usr/bin/env bash
# rofi_system_menu.sh / JennyM 2017 malkalech.com

list=(
  ##  Lock  ##
  "Lock Screen" "gnome-screensaver-command -l"
  "Logout"      "gnome-session-quit --force"
  ##  Power ##
  "Reboot"      "systemctl reboot"
  "Suspend"     "systemctl suspend"
  "Shutdown"    "systemctl poweroff"
)

for (( i=1; i<=$((${#list[@]}/2)); i++ )); do
  [[ -z "$@" ]] && echo "${i}. ${list[$i*2-2]}" && continue
  [[ "$@" == "${i}. ${list[$i*2-2]}" ]] && command="${list[$i*2-1]}" && break
done
eval "${command:-:}"
