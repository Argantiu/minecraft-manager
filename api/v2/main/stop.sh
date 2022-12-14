#!/bin/bash
# Automatic minecraft server script - Edit at your own risks!!
# Version 3.0.0.0-#0 created by CrazyCloudCraft https://crazycloudcraft.de
MLANG=./mcsys/configs/messages.lang
CONYAM=./mcsys/configs/mcsys.yml
SHSTOP1=$(cat < $MLANG | grep "stopsh.server.offline:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
SHSTOP2=$(cat < $MLANG | grep "stopsh.server.stop.info:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
SHSTOP3=$(cat < $MLANG | grep "stopsh.counter.invalid:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
SHSTOP4=$(cat < $MLANG | grep "stopsh.counter.stop.10:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
SHSTOP5=$(cat < $MLANG | grep "stopsh.counter.stop.4:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
SHSTOP6=$(cat < $MLANG | grep "stopsh.counter.stop.3:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
SHSTOP7=$(cat < $MLANG | grep "stopsh.counter.stop.2:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
SHSTOP8=$(cat < $MLANG | grep "stopsh.counter.stop.1:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
SHSTOP9=$(cat < $MLANG | grep "stopsh.counter.stop:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
SHSTOP10=$(cat < $MLANG | grep "stopsh.server.stopping:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
SHSTOP11=$(cat < $MLANG | grep "stopsh.server.killing:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
SHSTOP12=$(cat < $MLANG | grep "stopsh.server.stopped:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
MPREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
MCNAME=$(cat < $CONYAM | grep "systemname:" | cut -d ':' -f2)
MCOUNT=$(cat < $CONYAM | grep "dynamic-counter:" | cut -d ':' -f2)
VARSOFT=$(cat < $CONYAM | grep "software:" | cut -d ':' -f2 | tr -d " ")
if [[ $VARSOFT == "PURPUR" ]] || [[ $VARSOFT == "purpur" ]] || [[ $VARSOFT == "purpurmc" ]]; then ASOFTWARE=purpur.sh
fi
if [[ $VARSOFT == "PAPER" ]] || [[ $VARSOFT == "papermc" ]] || [[ $VARSOFT == "paper" ]] || [[ $VARSOFT == "paperspigot" ]]; then ASOFTWARE=paper.sh
fi
if [[ $VARSOFT == "SPIGOT" ]] || [[ $VARSOFT == "spigot" ]] || [[ $VARSOFT == "spogotmc" ]]; then ASOFTWARE=spigot.sh
fi
if [[ $VARSOFT == "BUKKIT" ]] || [[ $VARSOFT == "bukkit" ]] || [[ $VARSOFT == "bukkitmc" ]]; then ASOFTWARE=bukkit.sh
fi
# Modded
if [[ $VARSOFT == "MOHIST" ]] || [[ $VARSOFT == "mohist" ]] || [[ $VARSOFT == "mohistmc" ]]; then ASOFTWARE=modded/mohist.sh
fi
# Proxy
if [[ $VARSOFT == "VELOCITY" ]] || [[ $VARSOFT == "velo" ]] || [[ $VARSOFT == "velocity" ]]; then ASOFTWARE=proxy/velocity.sh
fi
if [[ $VARSOFT == "BUNGEECORD" ]] || [[ $VARSOFT == "bungeecord" ]] || [[ $VARSOFT == "bungee" ]]; then ASOFTWARE=proxy/bungeecord.sh
fi
if [[ $VARSOFT == "WATERFALL" ]] || [[ $VARSOFT == "waterfall" ]] || [[ $VARSOFT == "waterfallmc" ]]; then ASOFTWARE=proxy/waterfall.sh
fi

if ! screen -list | grep -q "$MCNAME"; then echo -e "$SHSTOP1"
  exit 1
fi
# Stop the server
echo -e "$SHSTOP2"
echo "$SHSTOP2" | /usr/bin/logger -t "$MCNAME"
# Looks if players are online
if [[ $ASOFTWARE == "paper.sh" ]] || [[ $ASOFTWARE == "spigot.sh" ]] || [[ $ASOFTWARE == "bukkit.sh" ]] || [[ $ASOFTWARE == "purpur.sh" ]] || [[ $ASOFTWARE == "modded/mohist.sh" ]] && [[ $MCOUNT == "TRUE" ]] || [[ $MCOUNT == "true" ]]; then
mkdir -p "$MTPATH"/mcsys/cache && cd "$MTPATH"/mcsys/cache || exit 1
hostname -I > ip-info.txt
MCIPAD=$(cat < ip-info.txt | grep -o '^\S*')
MCPORT=$(cat < "$MTPATH"/server.properties | grep server-port= | cut -b 13,14,1)
wget -q https://api.minetools.eu/ping/"$MCIPAD"/"$MCPORT" -O online-info.txt
 if grep -q error "online-info.txt"; then echo -e "$SHSTOP3"
 else MCOTYPE=$(cat < online-info.txt | grep online | tr -d " " | cut -b 10)
 fi
fi
# Start a countdown if there are players online.
if ! [[ $MCOTYPE = "0" ]]; then screen -Rd "$MCNAME" -X stuff "say $SHSTOP4 $(printf '\r')" && sleep 6s
 screen -Rd "$MCNAME" -X stuff "say $SHSTOP5 $(printf '\r')" && sleep 1s
 screen -Rd "$MCNAME" -X stuff "say $SHSTOP6 $(printf '\r')" && sleep 1s
 screen -Rd "$MCNAME" -X stuff "say $SHSTOP7 $(printf '\r')" && sleep 1s
 screen -Rd "$MCNAME" -X stuff "say $SHSTOP8 $(printf '\r')" && sleep 1s
fi
screen -Rd "$MCNAME" -X stuff "say $SHSTOP9 $(printf '\r')"
echo "$SHSTOP10" | /usr/bin/logger -t "$MCNAME"
# Wait up to 20 seconds for server to close
StopChecks=0
while [ $StopChecks -lt 30 ]; do
  if ! screen -list | grep -q "$MCNAME"; then
    break
  fi
  sleep 1;
  StopChecks=$((StopChecks+1))
done
# Force quit if server is still open
if screen -list | grep -q "$MCNAME"; then
  echo -e "$SHSTOP11"  | /usr/bin/logger -t "$MCNAME"
  screen -S "$MCNAME" -X quit
  pkill -15 -f "SCREEN -dmSL $MCNAME"
fi
echo -e "$SHSTOP12"
echo -e "$SHSTOP12" | /usr/bin/logger -t "$MCNAME"
