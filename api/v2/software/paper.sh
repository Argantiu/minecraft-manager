#!/bin/bash
# Minecraft Server auto stop script - Do not configure this script!!
# Version 3.0.0.0-#0 made by CrazyCloudCraft https://crazycloudcraft.de
CONYAM=./configs/mcsys.yml
MTPATH=$(cat < $CONYAM | grep "server-directory:" | cut -d ':' -f2 | tr -d " ")
MAINVERSION=$(cat < $CONYAM | grep "version:" | cut -d ':' -f2)
RAM=$(cat < $CONYAM | grep "ram:" | cut -d ':' -d 'B' -f2)
JAVABIN=$(cat < $CONYAM | grep "java:" | cut -d ':' -f2)
MCNAME=$(cat < $CONYAM | grep "systemname:" | cut -d ':' -f2)
cd "$MTPATH"/mcsys/saves/jar || exit 1
rm -f version.json
wget -q https://api.papermc.io/v2/projects/paper/versions/"$MAINVERSION"/ -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
wget -q https://api.papermc.io/v2/projects/paper/versions/"$MAINVERSION"/builds/"$LATEST"/downloads/paper-"$MAINVERSION"-"$LATEST".jar -O paper-"$MAINVERSION"-"$LATEST".jar
unzip -qq -t paper-"$MAINVERSION"-"$LATEST".jar
if [ "$?" -ne 0 ]; then 
echo "Downloaded paper-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t "$MCNAME"
else 
diff -q paper-"$MAINVERSION"-"$LATEST".jar "$MTPATH"/"$MCNAME".jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then 
  cp paper-"$MAINVERSION"-"$LATEST".jar paper-"$MAINVERSION"-"$LATEST".jar."$(date +%Y.%m.%d.%H.%M.%S)" && mv paper-"$MAINVERSION"-"$LATEST".jar "$MTPATH"/"$MCNAME".jar
  /usr/bin/find "$MTPATH"/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
  echo "paper-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t "$MCNAME"
  rm -f version.json
 else 
  echo "No paper-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t "$MCNAME"
  rm paper-"$MAINVERSION"-"$LATEST".jar
  rm -f version.json
 fi
fi
# Starting server.
cd "$MTPATH" || exit 1
echo "Starting $MTPATH/$MCNAME.jar" | /usr/bin/logger -t "$MCNAME"
screen -d -m -L -S "$MCNAME"  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $MCNAME.jar nogui"
exit 1
