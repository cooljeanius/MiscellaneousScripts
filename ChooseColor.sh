#!/bin/bash

#
# Simple script to display the OS X system color picker
#

if [ -x `which osascript` ]; then
  osascript -e "choose color"
fi
