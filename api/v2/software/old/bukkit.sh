#!/bin/bash
# Minecraft Server auto stop script - Do not configure this scipt!!
# Version 3.0.0.0-#0 made by Argantiu GmBh 06/21/2022 UTC/GMT +1 https://crazycloudcraft.de
MAINVERSION=
MCNAME=
LPATH=
RAM=
JAVABIN=
#Spigot / Bukkit: Getting Update form your selected version.
mkdir -p $LPATH/mcsys/build
mkdir -p $LPATH/mcsys/spitool
mkdir -p $LPATH/mcsys/build/mcmain
cd $LPATH/mcsys/build/mcmain || exit 1
wget -q https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools.jar
unzip -qq -t BuildTools.jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded BuildTools.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
else
 if [ -f $LPATH/mcsys/spitool/BuildTools.jar ]; then
  echo "BuildTools exists" | /usr/bin/logger -t $MCNAME
 else
  touch $LPATH/mcsys/spitool/BuildTools.jar
 fi
 diff $LPATH/mcsys/build/mcmain/BuildTools.jar $LPATH/mcsys/spitool/BuildTools.jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp $LPATH/mcsys/build/mcmain/BuildTools.jar $LPATH/mcsys/spitool/BuildTools.jar
  cd $LPATH/mcsys/spitool || exit 1
  cp BuildTools.jar BuildTools.jar"$(date +%Y.%m.%d.%H.%M.%S)"
  cd $LPATH/mcsys/build/mcmain || exit 1
  java -jar BuildTools.jar --rev $MAINVERSION #--output-dir $LPATH/mcsys/build/
  cp $LPATH/mcsys/build/mcmain/spigot-$MAINVERSION.jar $LPATH/mcsys/spitool/spigot-$MAINVERSION.jar"$(date +%Y.%m.%d.%H.%M.%S)"
  mv $LPATH/mcsys/build/mcmain/spigot-$MAINVERSION.jar $LPATH/$MCNAME.jar
  rm -r $LPATH/mcsys/build/mcmain
  /usr/bin/find $LPATH/mcsys/build/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  /usr/bin/find $LPATH/mcsys/spitool/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  echo "spigot/bukkit-$MAINVERSION.jar has been updated" | /usr/bin/logger -t $MCNAME
 else
  echo "No BuildTools.jar update neccessary" | /usr/bin/logger -t $MCNAME
  rm BuildTools.jar
 fi
fi
# Starting server
cd $LPATH || exit 1
echo "Starting $LPATH/$MCNAME.jar" | /usr/bin/logger -t $MCNAME
screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $MCNAME.jar nogui"
exit 1
