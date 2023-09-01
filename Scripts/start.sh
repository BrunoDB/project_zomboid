#!/bin/sh

cd /home/steam/Steam/steamapps/common/Project\ Zomboid\ Dedicated\ Server/
tmux -L pzserver new-session -d -x 80 -y 23 -s pzserver ./start-server.sh
