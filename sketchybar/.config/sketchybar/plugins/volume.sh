#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

if [ "$SENDER" = "volume_change" ]; then
  VOLUME=$INFO

  case $VOLUME in
    [6-9][0-9]|100) ICON="􀊩"
    ;;
    [3-5][0-9]) ICON="􀊥"
    ;;
    [1-9]|[1-2][0-9]) ICON="􀊡"
    ;;
    *) ICON="􀊣"
  esac

  sketchybar --animate sin 10 --set $NAME label.color.alpha=0.0 label.width=dynamic
  sleep 0.15
  sketchybar -m --set $NAME icon="$ICON" label="$VOLUME"
  sketchybar --animate sin 10 --set $NAME label.color.alpha=1.0 label.width=dynamic
fi
