import subprocess
import time
import re

# Executar o comando para obter a lista de jogadores
tmux_command = 'tmux -S /tmp/tmux-1002/pzserver send-keys -t pzserver "players" C-m'
subprocess.run(tmux_command, shell=True)

# Esperar por 5 segundos
time.sleep(5)

# Executar o comando para capturar as últimas 10 linhas dos logs
log_command = 'tail -n 10 /home/steam/Zomboid/Logs/*DebugLog-server.txt > /tmp/players'
subprocess.run(log_command, shell=True)

# Ler o conteúdo do arquivo /tmp/players invertendo a ordem das linhas
with open('/tmp/players', 'r') as players_file:
    players_lines = players_file.readlines()[::-1]

# Inicializar a lista de nomes de jogadores
player_names = []

# Encontrar a linha que contém "Players connected"
for line in players_lines:
    if "Players connected" in line:
        break

# Capturar os nomes dos jogadores nas linhas seguintes
for line in players_lines:
    stripped_line = line.strip('-').strip()
    if stripped_line and "Players connected" not in stripped_line:
        player_names.append(stripped_line)
    elif "Players connected" in stripped_line:
        break

# Encontrar o número de jogadores
num_players = len(player_names)

if num_players >= 1:
    online = f"{num_players} jogador(es) online: {', '.join(player_names)}"
else:
    online = "Ninguém, que tristeza"

print(online)
