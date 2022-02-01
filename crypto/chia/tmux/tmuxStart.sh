#!/bin/sh
# kudos to https://gist.github.com/todgru/6224848

sleep 3

session="chia"

# set up tmux
tmux start-server

# create a new tmux session, starting vim from a saved session in the new window
# tmux new-session -d -s $session -n vim #"vim -S ~/.vim/sessions/kittybusiness"
tmux new-session -d -s $session

# Select pane 1, set dir to api, run vim
tmux selectp -t 1
tmux send-keys "cd ~/chia-blockchain && . ./activate && chia start harvester -r" C-m

# Split pane 1 horizontal by 65%, start redis-server
tmux splitw -h -p 35
tmux send-keys "tail -F ~/.chia/mainnet/log/debug.log | grep --color=auto eligible" C-m

# Select pane 2
tmux selectp -t 2
# Split pane 2 vertiacally by 25%
tmux splitw -v -p 35

# select pane 3
tmux selectp -t 3
tmux send-keys "tail -F ~/.chia/mainnet/log/debug.log" C-m
tmux splitw -v -p 30

# Select pane 1
tmux selectp -t 1

# create a new window called scratch
#tmux new-window -t $session:1 -n scratch

# return to main window
#tmux select-window -t $session:0

# Finished setup, attach to the tmux session!
tmux attach-session -t $session
