tmux -S /tmp/tmux-1002/pzserver send-keys -t pzserver 'servermsg "Atenção O servidor irá reiniciar em 30 segundos"' C-m
sleep 15
tmux -S /tmp/tmux-1002/pzserver send-keys -t pzserver 'servermsg "Atenção O servidor irá reiniciar em 15 segundos"' C-m
sleep 15
tmux -S /tmp/tmux-1002/pzserver send-keys -t pzserver 'servermsg "Atenção O servidor irá reiniciar."' C-m
tmux -S /tmp/tmux-1002/pzserver send-keys -t pzserver 'servermsg "save"' C-m
sleep 5
tmux -S /tmp/tmux-1002/pzserver send-keys -t pzserver 'quit' C-m

