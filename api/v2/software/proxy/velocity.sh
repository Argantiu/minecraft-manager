#!/bin/bash
# Minecraft Server auto stop script - Do not configure this scipt!!
# Version 3.0.0.0-#0 made by Argantiu GmBh 06/21/2022 UTC/GMT +1 https://crazycloudcraft.de
PRMCVERSION=3.1.2
MCNAME=
LPATH=
RAM=
JAVABIN=
mkdir -p $LPATH/mcsys/jar
cd $LPATH/mcsys/jar || exit 1
rm -f version.json
wget -q https://api.papermc.io/v2/projects/velocity/versions/$PRMCVERSION-SNAPSHOT -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
wget -q https://api.papermc.io/v2/projects/velocity/versions/$PRMCVERSION-SNAPSHOT/builds/$LATEST/downloads/velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar -O velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar
unzip -qq -t velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
else
 diff -q velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar $LPATH/$MCNAME.jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar $LPATH/$MCNAME.jar
  /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  echo "velocity-$PRMCVERSION-SNAPSHOT-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
  rm version.json
 else
  echo "No velocity-$PRMCVERSION-SNAPSHOT-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
  rm velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar
  rm version.json
 fi
fi
# Stop Bedrock edition part
# Starting server
cd $LPATH || exit 1
echo "Starting $LPATH/$MCNAME.jar" | /usr/bin/logger -t $MCNAME
screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar $MCNAME.jar"
exit 1
