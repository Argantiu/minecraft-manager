#!/bin/bash
# Automatisches Minecraft Server Script - Bearbeiten auf eigene Gefahr!!
# Version 3.0.0.0-#0 erstellt von Argantiu GmBh 08.08.2022 https://crazycloudcraft.de
MCNAME=
SERVERBASE=
ASOFTWARE=
MCOUNT=
MPREFIX=
#
if ! screen -list | grep -q "$MCNAME"; then
  echo -e "$MPREFIX Der Server wurde schon gestoppt!"
  exit 1
fi

# Stoppe den Server
echo -e "$MPREFIX Notification: Stppe $DISPLAYNAME Server ..."
echo "[Argantiu] Notification: Stppe $DISPLAYNAME Server ..." | /usr/bin/logger -t $MCNAME
# Sieht nach, ob Spieler Online sind
if [[ $ASOFTWARE == "PAPER" ]] || [[ $ASOFTWARE == "SPIGOT" ]] || [[ $ASOFTWARE == "BUKKIT" ]] || [[ $ASOFTWARE == "PURPUR" ]] || [[ $ASOFTWARE == "MOHIST" ]] && [[ $MCOUNT == "TRUE" ]] || [[ $MCOUNT == "true" ]] && [[ $MCONLINE == "TRUE" ]] ; then
cd $MTPATH/mcsys/cache | exit 1
hostname -I > ip-info.txt
MCIPAD=$(cat < ip-info.txt | grep -o '^\S*')
MCPORT=$(cat < $MTPATH/server.properties | grep server-port= | cut -b 13,14,1

wget -q https://api.minetools.eu/ping/crazycloudcraft.de/25565 -O online-info
if grep -q error "online-info.txt"; then
 echo -e "ERROR the Server information is invalid."
 echo -e "Please open your port to the outside or change the port."
 echo -e "You can also disable this error in the config with MCOUNT=false"
else
MCOTYPE=$(cat < online-info.txt | grep online | tr -d " " | cut -b 10)
fi

# Starte Countdown, wenn Spieler Online sind
if [[ $MCOTYPE = "0" ]]; then
 echo ""
else
 screen -Rd $MCNAME -X stuff "say Server stoppt in 10 sekunden! $(printf '\r')"
 sleep 6s
 screen -Rd $MCNAME -X stuff "say Server stoppt in 4 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say Server stoppt in 3 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say Server stoppt in 2 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say Server stoppt in 1 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
fi
screen -Rd $MCNAME -X stuff "say Server stoppt.$(printf '\r')"
echo "Schalte Minecraft Server aus..." | /usr/bin/logger -t $MCNAME

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

echo -e "$MPREFIX Minecraft $SERVERBASE gestoppt."
echo -e "Minecraft Server $SERVERBASE stoppt." | /usr/bin/logger -t $MCNAME
