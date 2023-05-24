#!/bin/bash
MCVER=$(yq eval '.version' ./../../mcsys.yml)
SOFTWARE=$(yq eval '.software' ./../../mcsys.yml)
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
MCJAVA=$($MCVER && cut -d "." -f2)
MCPATH=$(yq eval '.directory' ./../../mcsys.yml)

case "$SOFTWARE" in
minecraft) SOFTAPI=https://piston-data.mojang.com/v1/ ;;
paper) SOFTAPI=https://api.papermc.io/v2/projects/paper/versions/"$MCVER"/ ;;
purpur) SOFTAPI=https://api.purpurmc.org/purpur/"$MCVER"/ ;;
spigot) SOFTAPI=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar ;;
bukkit) SOFTAPI=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar ;;
mohist) SOFTAPI=https://mohistmc.com/api/ ;;
magma) SOFTAPI=https://api.magmafoundation.org/api/v2/"$MCVER"/ ;;
velocity) SOFTAPI=https://api.papermc.io/v2/projects/velocity/versions/3.2.0-SNAPSHOT/ ;;
waterfall) SOFTAPI=https://api.papermc.io/v2/projects/waterfall/versions/"$MCVER"/ ;;
bungeecord) SOFTAPI=https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
*) echo "Error >> Software doesn't exitst. Does it have a typo?" ;;
esac

function javainstall() { # Todo: Checker if java already exists + get java home for startup.
if [[ $MCJAVA == "19" ]] || [[ $MCJAVA == "18" ]]; then apt install zulu17-jdk ; else apt install zulu8-jdk ; fi
}

# 1. Variant
# Download versions.json
# Download
# Check if download right
# Check if download needed
# Move things around
# Cleanup

# 2. Variant
# Download directly
# Check if download right
# Check if donwload needed
# Save with date
# ...

function stablebuilds() {
mkdir -p "$MCPATH"/libraries/mcsys/saves #?
case $SOFTWARE in
paper|purpur|magma|velocity|waterfall)  
# Download json
# Latest=

;;
mohist|bungeecord)  ;;
spigot|bukkit)  ;;
esac
if [ "$(unzip -qq -t $MCNAME.jar)" -ne 0 ]; then


}

function alphabuilds() {
mkdir -p "$MCPATH"/libraries/mcsys/saves-alpha
case $SOFTWARE in
minecraft)
folia)
esac

}




# Downloader old for testing
mkdir -p "$MCPATH"/cache/mcsys
cd "$MCPATH"/cache/mesys || exit 1
rm -f version.json
wget -q $SOFTAPI -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -v ":" | grep -e "[0-9]" | cut -d "\"" -f2)
if [[ $SOFTWARE == "purpur" ]]; then wget -q "$SOFTAPI""$LATEST"/download -O server-"$MCVER"-"$LATEST".jar ; fi
if [[ $SOFTWARE == "paper" ]]; then wget -q "$SOFTAPI"/builds/"$LATEST"/downloads/paper-"$MCVER"-"$LATEST".jar -O server-"$MCVER"-"$LATEST".jar ; fi
if [[ $SOFTWARE == "waterfall" ]]; then wget -q "$SOFTAPI"/builds/"$LATEST"/downloads/waterfall-"$MCVER"-"$LATEST".jar -O server-"$MCVER"-"$LATEST".jar ; fi
unzip -qq -t server-"$MCVER"-"$LATEST".jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded $SOFTWARE-$MCVER-$LATEST.jar is corrupt. No update."
else
 diff -q server-"$MCVER"-"$LATEST".jar "$MCPATH"/"$MCNAME".jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  mkdir -p "$MCPATH"/libraries/mcsys/saves
  cp server-"$MCVER"-"$LATEST".jar "$MCPATH"/libraries/mcsys/saves/"$SOFTWARE"-"$MCVER"-"$LATEST".jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv server-"$MCVER"-"$LATEST".jar "$MCPATH"/"$MCNAME".jar
  /usr/bin/find "$MCPATH"/libraries/mcsys/saves/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
  echo "$SOFTWARE-$MCVER-$LATEST has been updated"
  rm version.json
 else
  echo "No server-$MCVER-$LATEST update neccessary" 
  rm server-"$MAINVERSION"-"$LATEST".jar
  rm version.json
 fi
fi
# Starting server
cd "$MTPATH" || exit 1
echo "Starting $MCPATH/$MCNAME.jar" 
screen -d -m -L -S "$MCNAME"  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true --add-modules=jdk.incubator.vector -jar $MCNAME.jar nogui"
exit 1



## Spigot + Bukkit
cd "$MTPATH"/mcsys/saves/jar || exit 1
if [ ! -f "$MTPATH"/mcsys/saves/jar/BuildTools.jar ]; then touch "$MTPATH"/mcsys/saves/jar/BuildTools.jar
fi
wget -q https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools-1.jar
unzip -qq -t BuildTools-1.jar
if ! unzip -qq -t BuildTools-1.jar; then #if [ "$?" -ne 0 ]; then
 echo "Downloaded BuildTools.jar is corrupt. No update." | /usr/bin/logger -t "$MCNAME"
else
 diff -q BuildTools-1.jar BuildTools.jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then 
  rm BuildTools.jar && mv BuildTools-1.jar BuildTools.jar && mkdir -p "$MTPATH"/mcsys/saves/jar/cache
  cd "$MTPATH"/mcsys/saves/jar/cache || exit 1
  cp ./../BuildTools.jar .
  java -jar BuildTools.jar --rev "$MAINVERSION"
  cp ./CraftBukkit/target/spigot-*.jar "$MTPATH"/mcsys/saves/jar/spigot-"$MAINVERSION".jar"$(date +%Y.%m.%d.%H.%M.%S)"
  mv ./CraftBukkit/target/spigot-*.jar "$MTPATH"/"$MCNAME".jar
  cd ../ || exit 1
  rm -r ./cache
  /usr/bin/find "$MTPATH"/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
  echo "spigot-$MAINVERSION.jar has been updated" | /usr/bin/logger -t "$MCNAME"
 else
  echo "No BuildTools.jar update neccessary" | /usr/bin/logger -t "$MCNAME"
  rm BuildTools-1.jar
 fi
fi
# Starting server
cd "$MTPATH" || exit 1
echo "Starting $MTPATH/$MCNAME.jar" | /usr/bin/logger -t "$MCNAME"
screen -d -m -L -S "$MCNAME"  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $MCNAME.jar nogui"
exit 1

## Mohist
cd "$MTPATH"/mcsys/saves/jar || exit 1
DATE=$(date +%Y.%m.%d.%H.%M.%S)
wget -q https://mohistmc.com/api/"$MAINVERSION"/latest/download -O mohist-"$MAINVERSION"-"$DATE".jar
unzip -qq -t  mohist-"$MAINVERSION"-"$DATE".jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded mohist-$MAINVERSION-$DATE.jar is corrupt. No update." | /usr/bin/logger -t "$MCNAME"
else
 diff -q mohist-"$MAINVERSION"-"$DATE".jar "$MTPATH"/"$MCNAME".jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp mohist-"$MAINVERSION"-"$DATE".jar  mohist-"$MAINVERSION"-"$DATE".jar.backup
  mv mohist-"$MAINVERSION"-"$DATE".jar "$MTPATH"/"$MCNAME".jar
  /usr/bin/find "$MTPATH"/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
  echo "mohist-$MAINVERSION-$DATE.jar has been updated" | /usr/bin/logger -t "$MCNAME"
 else
  echo "No mohist-$MAINVERSION-$DATE.jar update neccessary" | /usr/bin/logger -t "$MCNAME"
  rm mohist-"$MAINVERSION"-"$DATE".jar
 fi
fi
# Starting server
cd "$MTPATH" || exit 1
echo "Starting $MTPATH/$MCNAME.jar" | /usr/bin/logger -t "$MCNAME"
screen -d -m -L -S "$MCNAME"  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $MCNAME.jar nogui"
exit 1


## Bungeecord
cd "$MTPATH"/mcsys/saves/jar || exit 1
rm -f version.json
wget -q https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
unzip -qq -t BungeeCord.jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded BungeeCord.jar is corrupt. No update." | /usr/bin/logger -t "$MCNAME"
else
 diff -q BungeeCord.jar "$MTPATH"/"$MCNAME".jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp BungeeCord.jar BungeeCord.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv BungeeCord.jar "$MTPATH"/"$MCNAME".jar
  /usr/bin/find "$MTPATH"/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
  echo "BungeeCord.jar has been updated" | /usr/bin/logger -t "$MCNAME"
 else
  echo "No BungeeCord.jar update neccessary" | /usr/bin/logger -t "$MCNAME"
  rm BungeeCord.jar
  rm -f version.json
 fi
fi
# Starting server
cd "$MTPATH" || exit 1
echo "Starting $MTPATH/$MCNAME.jar" | /usr/bin/logger -t "$MCNAME"
screen -d -m -L -S "$MCNAME"  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar $MCNAME.jar"
exit 1

## Velocity
PRMCVERSION=3.1.2
cd "$MTPATH"/mcsys/saves/jar || exit 1
rm -f version.json
wget -q https://api.papermc.io/v2/projects/velocity/versions/$PRMCVERSION-SNAPSHOT -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
wget -q https://api.papermc.io/v2/projects/velocity/versions/$PRMCVERSION-SNAPSHOT/builds/"$LATEST"/downloads/velocity-$PRMCVERSION-SNAPSHOT-"$LATEST".jar -O velocity-$PRMCVERSION-SNAPSHOT-"$LATEST".jar
unzip -qq -t velocity-$PRMCVERSION-SNAPSHOT-"$LATEST".jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded velocity-$PRMCVERSION-SNAPSHOT-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t "$MCNAME"
else
 diff -q velocity-$PRMCVERSION-SNAPSHOT-"$LATEST".jar "$MTPATH"/"$MCNAME".jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp velocity-$PRMCVERSION-SNAPSHOT-"$LATEST".jar velocity-$PRMCVERSION-SNAPSHOT-"$LATEST".jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv velocity-$PRMCVERSION-SNAPSHOT-"$LATEST".jar "$MTPATH"/"$MCNAME".jar
  /usr/bin/find "$MTPATH"/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
  echo "velocity-$PRMCVERSION-SNAPSHOT-$LATEST has been updated" | /usr/bin/logger -t "$MCNAME"
  rm version.json
 else
  echo "No velocity-$PRMCVERSION-SNAPSHOT-$LATEST update neccessary" | /usr/bin/logger -t "$MCNAME"
  rm velocity-$PRMCVERSION-SNAPSHOT-"$LATEST".jar
  rm version.json
 fi
fi
# Starting server
cd "$MTPATH" || exit 1
echo "Starting $MTPATH/$MCNAME.jar" | /usr/bin/logger -t "$MCNAME"
screen -d -m -L -S "$MCNAME"  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar $MCNAME.jar"
exit 1

## Waterfall
cd "$MTPATH"/mcsys/saves/jar || exit 1
rm -f version.json
wget -q https://api.papermc.io/v2/projects/waterfall/versions/"$MAINVERSION" -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
wget -q https://api.papermc.io/v2/projects/waterfall/versions/"$MAINVERSION"/builds/"$LATEST"/downloads/waterfall-"$MAINVERSION"-"$LATEST".jar -O waterfall-"$MAINVERSION"-"$LATEST".jar
unzip -qq -t waterfall-"$MAINVERSION"-"$LATEST".jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded waterfall-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t "$MCNAME"
else
 diff -q waterfall-"$MAINVERSION"-"$LATEST".jar "$MTPATH"/"$MCNAME".jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp waterfall-"$MAINVERSION"-"$LATEST".jar waterfall-"$MAINVERSION"-"$LATEST".jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv waterfall-"$MAINVERSION"-"$LATEST".jar "$MTPATH"/"$MCNAME".jar
  /usr/bin/find "$MTPATH"/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
  echo "waterfall-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t "$MCNAME"
  rm version.json
 else
  echo "No waterfall-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t "$MCNAME"
  rm waterfall-"$MAINVERSION"-"$LATEST".jar
  rm version.json
 fi
fi
# Starting server
cd "$MTPATH" || exit 1
echo "Starting $MTPATH/$MCNAME.jar" | /usr/bin/logger -t "$MCNAME"
screen -d -m -L -S "$MCNAME"  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar $MCNAME.jar"
exit 1