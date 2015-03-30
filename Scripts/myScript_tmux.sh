#!/bin/bash

SESSIONNAME="myScript"
tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ]
 then
    tmux new-session -s $SESSIONNAME -n main -d
    tmux send-keys -t $SESSIONNAME "/usr/bin/sudo ~/Desktop/code/raspi-prep/Scripts/runme.sh" C-m
fi

# To attach afterwards:
# tmux attach -t $SESSIONNAME