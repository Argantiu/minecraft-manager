#!/bin/bash
# Minecraft Server auto stop script - Do not configure this script!!
# Version 3.0.0.0-#0 made by CrazyCloudCraft https://crazycloudcraft.de
MTPATH=$(cat < mcsys.yml | grep "server-directory:" | cut -d ':' -f2 | tr -d " ")
MAINVERSION=$(cat < mcsys.yml | grep "version:" | cut -d ':' -f2)
RAM=$(cat < mcsys.yml | grep "ram:" | cut -d ':' -d 'B' -f2)
JAVABIN=$(cat < mcsys.yml | grep "java:" | cut -d ':' -f2)
MCNAME=$(cat < mcsys.yml | grep "systemname:" | cut -d ':' -f2)
cd $MTPATH/mcsys/saves/jar || exit 1
rm -f version.json
wget -q https://api.papermc.io/v2/projects/waterfall/versions/$MAINVERSION -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
wget -q https://api.papermc.io/v2/projects/waterfall/versions/$MAINVERSION/builds/$LATEST/downloads/waterfall-$MAINVERSION-$LATEST.jar -O waterfall-$MAINVERSION-$LATEST.jar
unzip -qq -t waterfall-$MAINVERSION-$LATEST.jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded waterfall-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
else
 diff -q waterfall-$MAINVERSION-$LATEST.jar $MTPATH/$MCNAME.jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp waterfall-$MAINVERSION-$LATEST.jar waterfall-$MAINVERSION-$LATEST.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv waterfall-$MAINVERSION-$LATEST.jar $MTPATH/$MCNAME.jar
  /usr/bin/find $MTPATH/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  echo "waterfall-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
  rm version.json
 else
  echo "No waterfall-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
  rm waterfall-$MAINVERSION-$LATEST.jar
  rm version.json
 fi
fi
# Starting server
cd $MTPATH || exit 1
echo "Starting $MTPATH/$MCNAME.jar" | /usr/bin/logger -t $MCNAME
screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar $MCNAME.jar"
exit 1
