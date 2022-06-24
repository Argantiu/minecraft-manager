#!/bin/bash
# Minecraft Server auto stop script - Do not configure this scipt!!
# Version 3.0.0.0-#0 made by Argantiu GmBh 06/21/2022 UTC/GMT +1 https://crazycloudcraft.de
#Bungeecord: Getting Update form your selected version.
MAINVERSION=
MCNAME=
LPATH=
RAM=
JAVABIN=
cd $LPATH/mcsys/jar || exit 1
rm -f version.json
wget -q https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
unzip -qq -t BungeeCord.jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded BungeeCord.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
else
 diff -q BungeeCord.jar $LPATH/$MCNAME.jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp BungeeCord.jar BungeeCord.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv BungeeCord.jar $LPATH/$MCNAME.jar
  /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  echo "BungeeCord.jar has been updated" | /usr/bin/logger -t $MCNAME
 else
  echo "No BungeeCord.jar update neccessary" | /usr/bin/logger -t $MCNAME
  rm BungeeCord.jar
  rm -f version.json
 fi
fi
# Starting server
cd $LPATH || exit 1
echo "Starting $LPATH/$MCNAME.jar" | /usr/bin/logger -t $MCNAME
screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar $MCNAME.jar"
exit 1
