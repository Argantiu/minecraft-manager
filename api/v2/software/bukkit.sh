#!/bin/bash
# Minecraft Server auto stop script - Do not configure this script!!
# Version 3.0.0.0-#0 made by CrazyCloudCraft https://crazycloudcraft.de
# shellcheck source=/dev/null
cd ./../configs || exit 1
source variables.sh
cd $MTPATH || exit 1
cd $MTPATH/mcsys/saves/jar || exit 1
if [ ! -f $MTPATH/mcsys/saves/jar/BuildTools.jar ]; then touch $MTPATH/mcsys/saves/jar/BuildTools.jar
fi
wget -q https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools-1.jar
unzip -qq -t BuildTools-1.jar
if ! unzip -qq -t BuildTools-1.jar; then #if [ "$?" -ne 0 ]; then
 echo "Downloaded BuildTools.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
else
 diff -q BuildTools-1.jar BuildTools.jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then 
  rm BuildTools.jar && mv BuildTools-1.jar BuildTools.jar && mkdir -p $MTPATH/mcsys/saves/jar/cache
  cd $MTPATH/mcsys/saves/jar/cache || exit 1
  cp ./../BuildTools.jar .
  java -jar BuildTools.jar --rev $MAINVERSION --compile craftbukkit
  cp ./CraftBukkit/target/craftbukkit-*.jar $MTPATH/mcsys/saves/jar/craftbukkit-$MAINVERSION.jar"$(date +%Y.%m.%d.%H.%M.%S)"
  mv ./CraftBukkit/target/craftbukkit-*.jar $MTPATH/$MCNAME.jar
  cd ../ || exit 1
  rm -r ./cache
  /usr/bin/find $MTPATH/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  echo "bukkit-$MAINVERSION.jar has been updated" | /usr/bin/logger -t $MCNAME
 else
  echo "No BuildTools.jar update neccessary" | /usr/bin/logger -t $MCNAME
  rm BuildTools-1.jar
 fi
fi
#Starting server
cd $MTPATH || exit 1
echo "Starting $MTPATH/$MCNAME.jar" | /usr/bin/logger -t $MCNAME
screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $MCNAME.jar nogui"
exit 1
