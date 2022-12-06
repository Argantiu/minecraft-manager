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
wget -q https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
unzip -qq -t BungeeCord.jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded BungeeCord.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
else
 diff -q BungeeCord.jar $MTPATH/$MCNAME.jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp BungeeCord.jar BungeeCord.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv BungeeCord.jar $MTPATH/$MCNAME.jar
  /usr/bin/find $MTPATH/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  echo "BungeeCord.jar has been updated" | /usr/bin/logger -t $MCNAME
 else
  echo "No BungeeCord.jar update neccessary" | /usr/bin/logger -t $MCNAME
  rm BungeeCord.jar
  rm -f version.json
 fi
fi
# Starting server
cd $MTPATH || exit 1
echo "Starting $MTPATH/$MCNAME.jar" | /usr/bin/logger -t $MCNAME
screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar $MCNAME.jar"
exit 1
