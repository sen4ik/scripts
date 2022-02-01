#!/bin/bash
touch ~/.tmux.conf && echo -e "set -g mouse on\nset -g pane-border-status bottom\nset -g history-limit 999999999" | tee ~/.tmux.conf > /dev/null
