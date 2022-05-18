#!/bin/bash
# Minecraft Server start script - Check if server is already started
# Version 2.5.2.0 made by CrazyCloudCraft 05/15/2022 UTC/GMT +1 https://crazycloudcraft.de
# Do not configure this scipts!
# shellcheck source=values.conf
source ./config/values.conf
# shellcheck source=lang/en/mcsys.conf
source ./config/mcsys.conf
# Path generating
LPATH=/$OPTBASE/$SERVERBASE
# drive depencies
if [ -f $LPATH/$MCNAME.jar ]; then
 echo "Jar exists" >/dev/null 2>&1
else
 touch $LPATH/$MCNAME.jar
fi

# Accept eula.txt
sed -i 's/false/true/g' $LPATH/eula.txt >/dev/null 2>&1
sed -i 's/\restart-script: ./start.sh/\\restart-script: ./mcsys/restart.sh/g' $LPATH/spigot.yml >/dev/null 2>&1
# Testing Dependencies
if screen -list | grep -q "$MCNAME"; then
    echo "Server has already started! Use screen -r $MCNAME to open it"
    exit 1
fi

# Change directory to server directory
cd $LPATH || exit 1

# Create backup for your server
if [ $BACKUP = "TRUE" ]; then
 if [ -f "$MCNAME.jar" ]; then
    echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Create Backup..."
    echo "Backing up server (to /unused/$BPATH folder)" | /usr/bin/logger -t $MCNAME
    cd $LPATH/unused/$BPATH && ls -1tr | head -n -10 | xargs -d '\n' rm -f --
    cd $LPATH || exit 1
    tar -pzcf ./unused/$BPATH/backup-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz --exclude='unused/*' ./
 fi
fi


# Clean Logfiles
/usr/bin/find $LPATH/logs -type f -mtime +6 -delete > /dev/null 2>&1

# Bedrock Part
if [ $BEUPDATE = TRUE ] || [ $GBEUPDATE = TRUE ]; then
 echo -e "$MPREFIX Updateing Bedrock"
 cd $LPATH/mcsys || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/be-updater.sh -O be-updater.sh
 chmod +x be-updater.sh
 /bin/bash $LPATH/mcsys/be-updater.sh
fi
#Paper: Getting Update form your selected version.
if [ $ASOFTWARE = "PAPER" ]; then
 mkdir -p $LPATH/mcsys/jar
 cd $LPATH/mcsys/jar || exit 1
 rm -f version.json
 wget -q https://papermc.io/api/v2/projects/paper/versions/$MAINVERSION/ -O version.json
 LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
 wget -q https://papermc.io/api/v2/projects/paper/versions/$MAINVERSION/builds/$LATEST/downloads/paper-$MAINVERSION-$LATEST.jar -O paper-$MAINVERSION-$LATEST.jar
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
fi

#PurPur: Getting Update form your selected version.
if [ $ASOFTWARE = "PURPUR" ]; then
 mkdir -p $LPATH/mcsys/jar
 cd $LPATH/mcsys/jar || exit 1
 rm -f version.json
 wget -q https://api.purpurmc.org/v2/purpur/$MAINVERSION -O version.json
 LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -v ":" | grep -e "[0-9]" | cut -d "\"" -f2)
 wget -q https://api.purpurmc.org/v2/purpur/$MAINVERSION/$LATEST/download -O purpur-$MAINVERSION-$LATEST.jar
 unzip -qq -t purpur-$MAINVERSION-$LATEST.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded purpur-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q purpur-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar >/dev/null 2>&1 
  if [ "$?" -eq 1 ]; then
   cp purpur-$MAINVERSION-$LATEST.jar purpur-$MAINVERSION-$LATEST.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv purpur-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar
   /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "purpur-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
   rm version.json
  else
   echo "No purpur-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
   rm purpur-$MAINVERSION-$LATEST.jar
   rm version.json
  fi
 fi
fi

#Mohist: Getting Update form your selected version.
if [ $ASOFTWARE = "MOHIST" ]; then
 mkdir -p $LPATH/mcsys/jar
 cd $LPATH/mcsys/jar || exit 1
 DATE=$(date +%Y.%m.%d.%H.%M.%S)
 wget -q https://mohistmc.com/api/$MAINVERSION/latest/download -O mohist-$MAINVERSION-$DATE.jar
 unzip -qq -t  mohist-$MAINVERSION-$DATE.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded mohist-$MAINVERSION-$DATE.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q mohist-$MAINVERSION-$DATE.jar $LPATH/$MCNAME.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp mohist-$MAINVERSION-$DATE.jar  mohist-$MAINVERSION-$DATE.jar.backup
   mv mohist-$MAINVERSION-$DATE.jar $LPATH/$MCNAME.jar
   /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "mohist-$MAINVERSION-$DATE.jar has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No mohist-$MAINVERSION-$DATE.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm mohist-$MAINVERSION-$DATE.jar
  fi
 fi
fi

#Spigot: Getting Update form your selected version.
if [ $ASOFTWARE = "SPIGOT" ] || [ $ASOFTWARE = "BUKKIT" ]; then
 mkdir -p $LPATH/mcsys/build
 mkdir -p $LPATH/mcsys/spitool
 cd $LPATH/mcsys/build || exit 1
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
  diff BuildTools.jar $LPATH/mcsys/spitool/BuildTools.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cd $LPATH/mcsys/build || exit 1
   cp BuildTools.jar $LPATH/mcsys/spitool/BuildTools.jar
   if [ $ASOFTWARE = "SPIGOT" ]; then
    java -jar BuildTools.jar --rev $MAINVERSION
    cp ./BuildTools/spigot-$MAINVERSION.jar ./spigot-$MAINVERSION.jar"$(date +%Y.%m.%d.%H.%M.%S)"
    mv ./BuildTools/spigot-$MAINVERSION.jar $LPATH/$MCNAME.jar
   fi
   if [ $ASOFTWARE = "BUKKIT" ]; then
    java -jar BuildTools.jar --rev $MAINVERSION --compile craftbukkit
    cp ./BuildTools/craftbukkit-$MAINVERSION.jar ./craftbukkit-$MAINVERSION.jar"$(date +%Y.%m.%d.%H.%M.%S)"
    mv ./BuildTools/craftbukkit-$MAINVERSION.jar $LPATH/$MCNAME.jar
   fi
   rm -r BuildTools
   cd $LPATH/mcsys/spitool/ || exit 1
   mv BuildTools.jar BuildTools.jar"$(date +%Y.%m.%d.%H.%M.%S)"
   /usr/bin/find $LPATH/mcsys/build/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   /usr/bin/find $LPATH/mcsys/spitool/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME»
   echo "spigot-$MAINVERSION.jar has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No BuildTools.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm BuildTools.jar
  fi
 fi
fi

#Velocity: Getting Update form your selected version.
if [ $ASOFTWARE = "VELOCITY" ]; then
 mkdir -p $LPATH/mcsys/jar
 cd $LPATH/mcsys/jar || exit 1
 rm -f version.json
 wget -q https://papermc.io/api/v2/projects/velocity/versions/$PRMCVERSION-SNAPSHOT -O version.json
 LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
 wget -q https://papermc.io/api/v2/projects/velocity/versions/$PRMCVERSION-SNAPSHOT/builds/$LATEST/downloads/velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar -O velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar
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
fi

#Bungeecord: Getting Update form your selected version.
if [ $ASOFTWARE = "BUNGEECORD" ]; then
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
fi

#Starting paper server
cd $LPATH || exit 1

echo "Starting $LPATH/$MCNAME.jar" | /usr/bin/logger -t $MCNAME
if [ $ASOFTWARE = "PAPER" ]; then
 screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $LPATH/$MCNAME.jar nogui"
 exit 0
fi

if [ $ASOFTWARE = "PURPUR" ]; then
 screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $LPATH/$MCNAME.jar nogui"
 exit 0
fi

if [ $ASOFTWARE = "VELOCITY" ]; then
 screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar $LPATH/$MCNAME.jar"
 exit 0
fi

if [ $ASOFTWARE = "MOHIST" ]; then
 screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $LPATH/$MCNAME.jar nogui"
 exit 0
fi

if [ $ASOFTWARE = "BUNGEECORD" ]; then
 screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar $LPATH/$MCNAME.jar"
 exit 0
fi

if [ $ASOFTWARE = "SPIGOT" ]; then
 screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $LPATH/$MCNAME.jar nogui"
 exit 0
fi

if [ $ASOFTWARE = "WATERFALL" ]; then
 screen -d -m -L -S $MCNAME  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -jar  $LPATH/$MCNAME.jar"
 exit 0
fi
 
exit 1
# End of file.
