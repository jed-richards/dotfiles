#!/bin/bash

# DP-2   - Laptop
# DP-0.1 - Middle and Primary
# DP-0.2 - Far right
#
#    ----------------------------
#    |      ||        ||        |
#    | DP-2 || DP-0.1 || DP-0.2 |
#    |      ||        ||        |
#    ----------------------------

# Turn on all displays
xrandr --output DP-0.1 --auto # middle/primary
xrandr --output DP-0.2 --auto # farthest right

# Set positions of each screen
xrandr --output DP-2 --left-of DP-0.1
xrandr --output DP-0.2 --right-of DP-0.1

# Set the middle screen as primary
xrandr --output DP-0.1 --primary

echo "Screens have been set up!"
