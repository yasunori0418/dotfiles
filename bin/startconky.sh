#!/bin/bash
conky -c ~/.conky/conky-ken/cpu
sleep 1
conky -c ~/.conky/conky-ken/mem
sleep 5
conky -c ~/.conky/conky-ken/rings
#sleep 10
#conky -c ~/.conky/conky-ken/weather
conky -c /usr/share/conky/conky1.10_shortcuts_maia
