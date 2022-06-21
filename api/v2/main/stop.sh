#!/bin/bash
# Minecraft Server auto stop script - Do not configure this scipt!!
# Version 3.0.0.0-#0 made by Argantiu GmBh 06/21/2022 UTC/GMT +1 https://crazycloudcraft.de
MCNAME=
SERVERBASE=
ASOFTWARE=
MCOUNT=
MPREFIX=
NTRANZLATION=
DISPLAYTRANZTIME=
MESSAGESTOP=
#
if ! screen -list | grep -q "$MCNAME"; then
  echo -e "$MPREFIX "
  exit 1
fi

# Stop the server
echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m $NTRANZLATION"
echo -e "[Argantiu] $NTRANZLATION" | /usr/bin/logger -t $MCNAME
# Start countdown notice on server
if [[ $ASOFTWARE == "PAPER" ]] || [[ $ASOFTWARE == "SPIGOT" ]] || [[ $ASOFTWARE == "BUKKIT" ]] || [[ $ASOFTWARE == "PURPUR" ]] || [[ $ASOFTWARE == "MOHIST" ]] || [[ $ASOFTWARE == "WATERFALL" ]] || [[ $ASOFTWARE == "BUNGEECORD" ]] && [[ $MCOUNT == "TRUE" ]]; then
 screen -Rd $MCNAME -X stuff "say Server is stopping...$(printf '\r')"
 screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 10 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 9 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 8 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 7 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 6 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 5 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 4 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 3 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 2 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
 screen -Rd $MCNAME -X stuff "say $MESSAGESTOP 1 $DISPLAYTRANZTIME ! $(printf '\r')"
 sleep 1s
fi
screen -Rd $MCNAME -X stuff "say Server stopped...$(printf '\r')"
echo "Closing Server..." | /usr/bin/logger -t $MCNAME
screen -Rd $MCNAME -X stuff "Stop$(printf '\r')"

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
  echo -e "$SERVERBASE server still hasn't closed after 30 seconds, closing screen explicit"  | /usr/bin/logger -t $MCNAME
  screen -S $MCNAME -X quit
  pkill -15 -f "SCREEN -dmSL $MCNAME"
fi

echo -e "MPREFIX Minecraft server $SERVERBASE stopped."
echo -e "Minecraft server $SERVERBASE stopped." | /usr/bin/logger -t $MCNAME
