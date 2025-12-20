#!/bin/bash

sketchybar --add item media center \
           --set media label.color=0xffffffff \
                       label.max_chars=20 \
                       scroll_texts=on \
                       icon=􀑪             \
                       icon.color=0xffffffff   \
                       script="$PLUGIN_DIR/media.sh" \
           --subscribe media media_change
