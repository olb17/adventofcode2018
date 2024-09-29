!/usr/bin/env bash

session="AoC2018"

tmux new-session -d -s $session

window=0
tmux rename-window -t $session:$window 'dev'

tmux split-window -v -l '20%'

tmux select-pane -t 0
tmux send-keys "nvim" Enter

tmux select-pane -t 1
tmux send-keys "mix test.watch" Enter

tmux select-pane -t 0

tmux attach-session -t $session

