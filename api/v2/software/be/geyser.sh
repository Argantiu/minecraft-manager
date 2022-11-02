#!/bin/bash
# Minecraft Server auto stop script - Do not configure this script!!
# Version 3.0.0.0-#0 made by Argantiu GmBh 06/21/2022 UTC/GMT +1 https://crazycloudcraft.de
# shellcheck source=/dev/null
cd ./../configs || exit 1
source variables.sh
cd $MTPATH || exit 1
# Floodgate
mkdir -p $MTPATH/mcsys/floodgate
if [ ! $ASOFTWARE = "modded/mohist.sh" ]; then
 if [ ! -f $MTPATH/plugins/floodgate-spigot.jar ]; then touch $MTPATH/plugins/floodgate-spigot.jar
 fi
 cd $MTPATH/mcsys/floodgate || exit 1
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/target/floodgate-spigot.jar -O floodgate-spigot.jar
 unzip -qq -t floodgate-spigot.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded floodgate default is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q floodgate-spigot.jar $MTPATH/plugins/floodgate-spigot.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp floodgate-spigot.jar floodgate-spigot.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv floodgate-spigot.jar $MTPATH/plugins/floodgate-spigot.jar
   /usr/bin/find $MTPATH/mcsys/saves/floodgate/* -type f -mtime +5 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "floodgate default has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No floodgate default update neccessary" | /usr/bin/logger -t $MCNAME
   rm floodgate-spigot.jar
  fi
 fi
else echo -e "Bedrock support doesn't work on this software! Please use an other sofware or disable Bedrock support."
fi

# Geyser
mkdir -p $MTPATH/mcsys/geyser
if [[ ! $ASOFTWARE == "modded/mohist.sh" ]] && [[ ! $PROXYMO == "true" ]] || [[ ! $PROXYMO == "TRUE" ]]; then
 if [ ! -f $MTPATH/plugins/Geyser-Spigot.jar ]; then touch $MTPATH/plugins/Geyser-Spigot.jar
 fi
 cd $MTPATH/mcsys/geyser || exit 1
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar -O Geyser-Spigot.jar
 unzip -qq -t Geyser-Spigot.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded Geyser Default is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q Geyser-Spigot.jar $LPATH/plugins/Geyser-Spigot.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp Geyser-Spigot.jar Geyser-Spigot.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv Geyser-Spigot.jar $MTPATH/plugins/Geyser-Spigot.jar
   /usr/bin/find $MTPATH/mcsys/saves/geyser/* -type f -mtime +5 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "Geyser Default has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No Geyser default update neccessary" | /usr/bin/logger -t $MCNAME
   rm Geyser-Spigot.jar
  fi
 fi
else echo -e "Bedrock support doesn't work on this software! Please use an other sofware or disable Bedrock support."
fi
