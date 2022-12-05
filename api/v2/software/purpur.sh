#!/bin/bash
# Minecraft Server auto stop script - Do not configure this script!!
# Version 3.0.0.0-#0 made by CrazyCloudCraft https://crazycloudcraft.de
MTPATH=$(cat < mcsys.yml | grep "server-directory:" | cut -d ':' -f2 | tr -d " ")
MAINVERSION=$(cat < mcsys.yml | grep "version:" | cut -d ':' -f2)
RAM=$(cat < mcsys.yml | grep "ram:" | cut -d ':' -d 'B' -f2)
JAVABIN=$(cat < mcsys.yml | grep "java:" | cut -d ':' -f2)
MCNAME=$(cat < mcsys.yml | grep "systemname:" | cut -d ':' -f2)
mkdir -p $MTPATH/mcsys/saves/jar
cd $MTPATH/mcsys/saves/jar || exit 1
rm -f version.json
wget -q https://api.purpurmc.org/v2/purpur/"$MAINVERSION" -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -v ":" | grep -e "[0-9]" | cut -d "\"" -f2)
wget -q https://api.purpurmc.org/v2/purpur/"$MAINVERSION"/"$LATEST"/download -O purpur-$MAINVERSION-$LATEST.jar
unzip -qq -t purpur-$MAINVERSION-$LATEST.jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded purpur-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
else
 diff -q purpur-$MAINVERSION-$LATEST.jar $MTPATH/$MCNAME.jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp purpur-$MAINVERSION-$LATEST.jar purpur-$MAINVERSION-$LATEST.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv purpur-$MAINVERSION-$LATEST.jar $MTPATH/$MCNAME.jar
  /usr/bin/find $MTPATH/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  echo "purpur-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
  rm version.json
 else
  echo "No purpur-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
  rm purpur-$MAINVERSION-$LATEST.jar
  rm version.json
 fi
fi
# Starting server
cd $MTPATH || exit 1
echo "Starting $MTPATH/$MCNAME.jar" | /usr/bin/logger -t $MCNAME
screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true --add-modules=jdk.incubator.vector -jar $MCNAME.jar nogui"
exit 1
