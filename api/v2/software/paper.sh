#!/bin/bash
# Minecraft Server auto stop script - Do not configure this scipt!!
# Version 3.0.0.0-#0 made by Argantiu GmBh 06/21/2022 UTC/GMT +1 https://crazycloudcraft.de
MAINVERSION=
MCNAME=
LPATH=
mkdir -p $LPATH/mcsys/jar
cd $LPATH/mcsys/jar || exit 1
rm -f version.json
wget -q https://api.papermc.io/v2/projects/paper/versions/$MAINVERSION/ -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
wget -q https://api.papermc.io/v2/projects/paper/versions/$MAINVERSION/builds/$LATEST/downloads/paper-$MAINVERSION-$LATEST.jar -O paper-$MAINVERSION-$LATEST.jar
unzip -qq -t paper-$MAINVERSION-$LATEST.jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded paper-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
else
 diff -q paper-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp paper-$MAINVERSION-$LATEST.jar paper-$MAINVERSION-$LATEST.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv paper-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar
  /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  echo "paper-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
  rm version.json
 else
  echo "No paper-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
  rm paper-$MAINVERSION-$LATEST.jar
  rm version.json
 fi
fi
