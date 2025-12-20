#!/bin/bash

sketchybar -m --add event window_focus \
              --add event title_change

sketchybar -m --add item title left \
              --set title script="$HOME/.config/sketchybar/plugins/window_title.sh" \
              --subscribe title window_focus front_app_switched space_change title_change
