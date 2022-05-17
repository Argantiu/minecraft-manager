#!/bin/bash
# Sript start Do NOT EDIT THIS HERE!
. /config/mcsys.conf

LPATH=/$OPTBASE/$SERVERBASE
mkdir -p $LPATH/plugins
mkdir -p $LPATH/mcsys

# Floodgate for Spigot
if [ $ASOFTWARE = "PAPER" ] || [ $ASOFTWARE = "SPIGOT" ] || [ $ASOFTWARE = "BUKKIT" ] || [ $ASOFTWARE = "PURPUR" ] && [ $BESUPPORT = "TRUE" ]; then
 cd $LPATH/plugins || exit 1
 mkdir -p $LPATH/mcsys/floodgate
 cd $LPATH/mcsys/floodgate || exit 1
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/target/floodgate-spigot.jar -O floodgate-spigot.jar
 unzip -qq -t floodgate-spigot.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded floodgate default is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/plugins/floodgate-spigot.jar ]; then
   echo "Floodgate plugin exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/plugins/floodgate-spigot.jar 
  fi
  diff -q floodgate-spigot.jar $LPATH/plugins/floodgate-spigot.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp floodgate-spigot.jar floodgate-spigot.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv floodgate-spigot.jar $LPATH/plugins/floodgate-spigot.jar
   /usr/bin/find $LPATH/mcsys/floodgate/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "floodgate default has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No floodgate default update neccessary" | /usr/bin/logger -t $MCNAME
   rm floodgate-spigot.jar
  fi
 fi
fi

# Geyser Updater for nomal servers
if [ $ASOFTWARE = "PAPER" ] || [ $ASOFTWARE = "SPIGOT" ] || [ $ASOFTWARE = "BUKKIT" ] || [ $ASOFTWARE = "PURPUR" ] && [ $GBESUPPORT = "TRUE" ]; then
 cd $LPATH/plugins || exit 1
 mkdir -p $LPATH/mcsys/geyser
 cd $LPATH/mcsys/geyser || exit 1
 wget -q https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar -O Geyser-Spigot.jar
 unzip -qq -t Geyser-Spigot.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded Geyser Default is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/plugins/Geyser-Spigot.jar ]; then
   echo "Geyser default plugin exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/plugins/Geyser-Spigot.jar
  fi
  diff -q Geyser-Spigot.jar $LPATH/plugins/Geyser-Spigot.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp Geyser-Spigot.jar Geyser-Spigot.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv Geyser-Spigot.jar $LPATH/plugins/Geyser-Spigot.jar
   /usr/bin/find $LPATH/mcsys/geyser/* -type f -mtime +6 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "Geyser Default has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No Geyser default update neccessary" | /usr/bin/logger -t $MCNAME
   rm Geyser-Spigot.jar
  fi
 fi
fi

# Floodgate for Proxy
if [ $ASOFTWARE = "BUNGEECORD" ] || [ $ASOFTWARE = "VELOCITY" ] || [ $ASOFTWARE = "WATERFALL" ] && [ $BESUPPORT = "TRUE" ]; then
 cd $LPATH/plugins || exit 1
 mkdir -p $LPATH/mcsys/floodgate
 cd $LPATH/mcsys/floodgate || exit 1
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
 if [ $ASOFTWARE = "VELOCITY" ]; then
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
if [ $ASOFTWARE = "BUNGEECORD" ] || [ $ASOFTWARE = "VELOCITY" ] || [ $ASOFTWARE = "WATERFALL" ] && [ $BESUPPORT = "TRUE" ]; then
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
 if [ $ASOFTWARE = "VELOCITY" ]; then
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
if [ $ASOFTWARE = "FORGE" ] || [ $ASOFTWARE = "MOHIST" ] || [ $ASOFTWARE = "FABRIC" ] || [ $ASOFTWARE = "MINECRAFT" ] && [ $BESUPPORT = "TRUE" ]; then
echo -e "Bedrock support doesn't work on this software! Please use an other sofware or disable Bedrock support."
fi

exit 1
