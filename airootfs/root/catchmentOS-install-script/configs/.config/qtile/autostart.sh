#!/bin/sh

picom --config ~/.config/picom/picom.conf &

feh --bg-scale ~/.config/qtile/wall.png &

nm-applet &
