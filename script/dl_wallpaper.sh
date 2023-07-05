#! /bin/bash

DL_PATH=~/Pictures/wallpaper
FILE_JPG=Nordic-darker.jpg
FILE_PNG=Nordic-darker.png

# https://store.kde.org/p/1633675
curl --create-dirs -o $DL_PATH/$FILE_JPG https://vsthemes.org/uploads/posts/2020-04/1586853771_daniel-leone-v7datklzzaw-unsplash-modded.jpg

GEOMETRY=`xrandr | grep -F '*' | awk -F ' ' '{print $1}'`

convert -resize $GEOMETRY! $DL_PATH/$FILE_JPG $DL_PATH/$FILE_PNG

rm $DL_PATH/$FILE_JPG
