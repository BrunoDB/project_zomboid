#!/bin/bash 
 discord_url="https://discord.com/api/webhooks/1146649136981090354/RTON6BeIWTAC9kkq4LbbEBsiXORxUTSpYIvW576V0iQgi_9SGLsLNtTPTmP4mQ-NtVR0"
#discord_url="https://discord.com/api/webhooks/1146625951258652702/8Vqxtr6e1wCpC9nesqbth0vw9TFi0-1OLylDwqgGKkNLiH4tt-_kAYAGgwPwysY_V42Z"
status=$(ps aux | grep -v grep | grep -i -c "ProjectZomboid64")
if [ $status -eq 1 ]; then
  ip=$(curl -s checkip.dyndns.org | sed 's/.*IP Address: \([0-9\.]*\).*/\1/g')

  tmux -S /tmp/tmux-1002/pzserver send-keys -t pzserver 'players' C-m
  sleep 5
  tail -n 10 /home/steam/Zomboid/Logs/*DebugLog-server.txt >/tmp/players

  # Encontre a linha que contém "Players connected" e obtenha o número de jogadores conectados
  players_line=$(grep -n "Players connected" /tmp/players | tail -n 1)

  # Verifique se a linha foi encontrada

  num_players=$(echo "$players_line" | awk -F '[( )]' '{print $17}')
  if [ $num_players -ge 1 ]; then

    lines_to_show=$((num_players))
    playr=$(echo "$players_line" | awk -F ':' '{print $1}')
    soma=$((playr + 1))
    ply=$(tail -n +${soma} /tmp/players | head -n ${lines_to_show} | tr '\n' ' ')
    online="$ply"
  else
    online="Ninguem, que tristreza"
  fi

  tmux -S /tmp/tmux-1002/pzserver send-keys -t pzserver 'checkModsNeedUpdate' C-m
  # mods=""
  # tail -f ~/Zomboid/Logs/*DebugLog-server.txt -n 0 | while read line; do
  #   if echo $line | grep -q "updated"; then
  #     # echo "Mods estão atualizados" && break
  #     mods="OK ✅"
  #     break
  #   fi
  #   if echo $line | grep -q "need update"; then
  #     # echo updating Zomboid && break
  #     mods="❌\n****Necessario restart do servidor.****"
  #     break
  #   fi
  # done
  # echo "$mods"
  # # mod_ok="✅"
  # # mod_nok="❌\n****Necessario restart do servidor.****"
  num_players=1
  get_mods_status() {
    while read -r line; do
      if echo "$line" | grep -q "updated"; then
        echo -n " ✅"
        # echo -n "❌ Sofreram atualização\n****Necessario restart do servidor.****"
        return 0
      elif echo "$line" | grep -q "need update"; then
        echo -n "❌ Sofreram atualização\n****Necessario restart do servidor.****"
        if [ $num_players -ge 1 ]; then
          tmux -S /tmp/tmux-1002/pzserver send-keys -t pzserver 'servermsg "Mods sofreram atualização, notificar ADM"' C-m
        fi
        return 0
      fi
    done
    echo "Não foi possível determinar o status dos mods."
    return 0
  }

  mods=$(tail -f ~/Zomboid/Logs/*DebugLog-server.txt -n 0 | get_mods_status)
  # echo "$mods"

  generate_post_data() {
    cat <<EOF
	{
	  "content": "",
	  "embeds": [{
		"title": "Acessos",
		"description": "IP: **${ip}** \nPorta: 16261\nSenha: qwe123\nMods: ${mods}\nJogadores Online: ${online}",
		"color": "45973"
	  }]
	}
EOF
  }

  # POST request to Discord Webhook
  curl -H "Content-Type: application/json" -X POST -d "$(generate_post_data)" $discord_url
else

  generate_post_data() {
    cat <<EOF
	{
	  "content": "",
	  "embeds": [{
		"title": "Acesso Indisponivel",
		"description": "Estamos trabalhando nisso, tenha calma, logo logo estaremos de volta.",
		"color": "14177041"
	  }]
	}
EOF
  }

  # POST request to Discord Webhook
  curl -H "Content-Type: application/json" -X POST -d "$(generate_post_data)" $discord_url
fi

