#!/bin/bash
# Minecraft Server auto stop script - Do not configure this scipt!!
# Version 3.0.0.0-#0 made by CrazyCloudCraft https://crazycloudcraft.de
# shellcheck source=/dev/null
. ./../configs/variables.sh

# Floodgate
 cd $MTPATH/plugins || exit 1
 mkdir -p $MTPATH/mcsys/saves/floodgate
 cd $MTPATH/mcsys/saves/floodgate || exit 1
 if [ $ASOFTWARE = "BUNGEECORD" ] || [ $ASOFTWARE = "WATERFALL" ]; then
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/bungee/target/floodgate-bungee.jar -O floodgate-bungee.jar
 unzip -qq -t floodgate-bungee.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded floodgate for Bungeecord and Waterfall is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/plugins/floodgate-bungee.jar ]; then
   echo "Geyser bungee plugin exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/plugins/floodgate-bungee.jar
  fi
  diff -q floodgate-bungee.jar $LPATH/plugins/floodgate-bungee.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp floodgate-bungee.jar floodgate-bungee.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv floodgate-bungee.jar $LPATH/plugins/floodgate-bungee.jar
   /usr/bin/find $LPATH/mcsys/floodgate/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "floodgate for Bungeecord and Waterfall has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No floodgate bungee update neccessary" | /usr/bin/logger -t $MCNAME
   rm floodgate-bungee.jar
  fi
 fi
 fi
# Velocity part
 if [[ $ASOFTWARE == "VELOCITY" ]]; then
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/velocity/target/floodgate-velocity.jar -O floodgate-velocity.jar
 unzip -qq -t floodgate-velocity.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded floodgate for velocity is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/plugins/floodgate-velocity.jar ]; then
   echo "floodgate-velocity.jar plugin exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/plugins/floodgate-velocity.jar
  fi
  diff -q floodgate-velocity.jar $LPATH/plugins/floodgate-velocity.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp floodgate-velocity.jar floodgate-velocity.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv floodgate-velocity.jar $LPATH/plugins/floodgate-velocity.jar
   /usr/bin/find $LPATH/mcsys/floodgate/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "floodgate for velocity has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No floodgate velocity update neccessary" | /usr/bin/logger -t $MCNAME
   rm floodgate-velocity.jar
  fi
 fi
 fi
fi

# Geyser for Proxy
if [[ $ASOFTWARE == "BUNGEECORD" ]] || [[ $ASOFTWARE == "VELOCITY" ]] || [[ $ASOFTWARE == "WATERFALL" ]] && [[ $BESUPPORT == "TRUE" ]]; then
 cd $LPATH/plugins || exit 1
 mkdir -p $LPATH/mcsys/geyser
 cd $LPATH/mcsys/geyser || exit 1
 if [ $ASOFTWARE = "BUNGEECORD" ] || [ $ASOFTWARE = "WATERFALL" ]; then
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/bungeecord/target/Geyser-BungeeCord.jar -O Geyser-BungeeCord.jar
 unzip -qq -t Geyser-BungeeCord.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded Geyser Bungeecord and Waterfall is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/plugins/Geyser-BungeeCord.jar ]; then
   echo "Geyser-BungeeCord.jar plugin exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/plugins/Geyser-BungeeCord.jar
  fi
  diff -q Geyser-BungeeCord.jar $LPATH/plugins/Geyser-BungeeCord.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
  cp Geyser-BungeeCord.jar Geyser-BungeeCord.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv Geyser-BungeeCord.jar $LPATH/plugins/Geyser-BungeeCord.jar
  /usr/bin/find $LPATH/mcsys/geyser/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "Geyser for Bungeecord and Waterfall has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No Geyser-BungeeCord.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm Geyser-BungeeCord.jar
  fi
 fi
 fi
# Velocity part
 if [[ $ASOFTWARE == "VELOCITY" ]]; then
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/velocity/target/Geyser-Velocity.jar -O Geyser-Velocity.jar
 unzip -qq -t Geyser-Velocity.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded Geyser-Velocity is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/plugins/Geyser-Velocity.jar ]; then
   echo "Geyser-Velocity.jar plugin exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/plugins/Geyser-Velocity.jar
  fi
  diff -q Geyser-Velocity.jar $LPATH/plugins/Geyser-Velocity.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
  cp Geyser-Velocity.jar Geyser-Velocity.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv Geyser-Velocity.jar $LPATH/plugins/Geyser-Velocity.jar
  /usr/bin/find $LPATH/mcsys/geyser/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "Geyser for Velocity has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No Geyser-Velocity.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm Geyser-Velocity.jar
  fi
 fi
 fi
fi

# Error for Mod Servers
if [[ $ASOFTWARE == "FORGE" ]] || [[ $ASOFTWARE == "MOHIST" ]] || [[ $ASOFTWARE == "FABRIC" ]] || [[ $ASOFTWARE == "MINECRAFT" ]] && [[ $BESUPPORT == "TRUE" ]]; then
echo -e "Bedrock support doesn't work on this software! Please use an other sofware or disable Bedrock support."
fi

exit 0
