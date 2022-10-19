#!/bin/bash
# Automatic minecraft server script - Edit at your own risks!!
# Version 3.0.0.0-#0 created by CrazyCloudCraft https://crazycloudcraft.de
. ./configs/variables.sh
if ! screen -list | grep -q "$MCNAME"; then echo -e "$SHSTOP1"
  exit 1
fi
# Stoppe den Server
echo -e "$SHSTOP2"
echo "$SHSTOP2" | /usr/bin/logger -t $MCNAME
# Sieht nach, ob Spieler Online sind
if [[ $ASOFTWARE == "PAPER" ]] || [[ $ASOFTWARE == "SPIGOT" ]] || [[ $ASOFTWARE == "BUKKIT" ]] || [[ $ASOFTWARE == "PURPUR" ]] || [[ $ASOFTWARE == "MOHIST" ]] && [[ $MCOUNT == "TRUE" ]] || [[ $MCOUNT == "true" ]]; then
mkdir -p $MTPATH/mcsys/cache
cd $MTPATH/mcsys/cache || exit 1
hostname -I > ip-info.txt
MCIPAD=$(cat < ip-info.txt | grep -o '^\S*')
MCPORT=$(cat < $MTPATH/server.properties | grep server-port= | cut -b 13,14,1)
wget -q https://api.minetools.eu/ping/"$MCIPAD"/"$MCPORT" -O online-info.txt
if grep -q error "online-info.txt"; then echo -e "$SHSTOP3"
else MCOTYPE=$(cat < online-info.txt | grep online | tr -d " " | cut -b 10)
fi

# Starte Countdown, wenn Spieler Online sind
if [[ $MCOTYPE = "0" ]]; then
 echo "0 Spieler Online, Perfekt."
else
 screen -Rd $MCNAME -X stuff "say &f Server stoppt in 10 sekunden! $(printf '\r')"
 sleep 6s
 screen -Rd $MCNAME -X stuff "say &f Server stoppt in 4 sekunden! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say &f Server stoppt in 3 sekunden! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say &f Server stoppt in 2 sekunden! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say &f Server stoppt in 1er sekunde! $(printf '\r')"
 sleep 1s
fi
screen -Rd $MCNAME -X stuff "say &f Server stoppt.$(printf '\r')"
echo "Schalte Minecraft $MCNAME Server aus..." | /usr/bin/logger -t $MCNAME

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
  echo -e "$MPREFIX $SERVERBASE Server hat nach 30 sekunden nicht reagiert, Minecraft Server wird abgewürgt."  | /usr/bin/logger -t $MCNAME
  screen -S $MCNAME -X quit
  pkill -15 -f "SCREEN -dmSL $MCNAME"
fi

echo -e "$MPREFIX Minecraft $MCNAME gestoppt."
echo -e "Minecraft Server $MCNAME stoppt." | /usr/bin/logger -t $MCNAME
