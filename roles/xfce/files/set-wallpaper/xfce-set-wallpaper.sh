#!/bin/env bash

# Set the wallpaper to all monitors
#

WALLPAPER_PATH="/comum/wallpapers"
WALLPAPER_FILE=$(find ${WALLPAPER_PATH} -type f | shuf -n1)

echo ${WALLPAPER_FILE}

# Get all identified monitors path
MONITORS=$(xfconf-query -c xfce4-desktop -p /backdrop -l | grep "workspace./last-image")

# Set the wallpaper for each monitor
for MONITOR in ${MONITORS}
do
  echo $MONITOR
  xfconf-query -c xfce4-desktop -p ${MONITOR} -s ${WALLPAPER_FILE}
done

exit 0
