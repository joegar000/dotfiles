#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --animate sin 10 --set $NAME label.color.alpha=0.0 label.width=0

  sleep 0.05

  sketchybar -m --set $NAME label="$INFO"
  sketchybar --animate sin 10 --set $NAME label.color.alpha=1.0 label.width=dynamic

fi
