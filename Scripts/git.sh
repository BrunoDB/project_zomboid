#!/bin/sh
tmux -S /tmp/tmux-1002/pzserver send-keys -t pzserver 'save' C-m
sleep 5
cd /home/steam/Zomboid
git add *
git commit -m "Realizado backup."
git push
