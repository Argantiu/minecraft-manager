#!/bin/bash
MCVER=$(yq eval '.version' ./../../mcsys.yml)
SOFTWARE=$(yq eval '.software' ./../../mcsys.yml)
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
MCJAVA=$($MCVER && cut -d "." -f2)
MCPATH=$(yq eval '.directory' ./../../mcsys.yml)

case "$SOFTWARE" in
#minecraft) SOFTAPI=https://piston-data.mojang.com/v1/ ;;
paper) SOFTAPI=https://api.papermc.io/v2/projects/paper/versions/"$MCVER"/ ;;
purpur) SOFTAPI=https://api.purpurmc.org/purpur/"$MCVER"/ ;;
#spigot) SOFTAPI=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar ;;
#bukkit) SOFTAPI=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar ;;
#mohist) SOFTAPI=https://mohistmc.com/api/ ;;
#magma) SOFTAPI=https:// ;;
#velocity) SOFTAPI=https://api.papermc.io/v2/projects/velocity/versions/"$MCVER"/ ;;
waterfall) SOFTAPI=https://api.papermc.io/v2/projects/waterfall/versions/"$MCVER"/ ;;
#bungeecord) SOFTAPI=https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
*) echo "Error >> Software doesn't exitst. Does it have a typo?" ;;
esac

function mcloadbase() {
if [[ $MCJAVA == "19" ]] || [[ $MCJAVA == "18" ]]; then 
apt install zulu17-jdk
else 
apt install zulu8-jdk
fi
}

# Downloader old for testing
mkdir -p "$MCPATH"/cache/mcsys
cd "$MCPATH"/cache/mcsys || exit 1
rm -f version.json
wget -q $SOFTAPI -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -v ":" | grep -e "[0-9]" | cut -d "\"" -f2)
if [[ $SOFTWARE == "purpur" ]]; then wget -q "$SOFTAPI""$LATEST"/download -O server-"$MCVER"-"$LATEST".jar ; fi
if [[ $SOFTWARE == "paper" ]]; then wget -q "$SOFTAPI"/builds/"$LATEST"/downloads/paper-"$MCVER"-"$LATEST".jar -O server-"$MCVER"-"$LATEST".jar ; fi
if [[ $SOFTWARE == "waterfall" ]]; then wget -q "$SOFTAPI"/builds/"$LATEST"/downloads/waterfall-"$MCVER"-"$LATEST".jar -O server-"MCVER"-"$LATEST".jar ; fi
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






# Downloader
#cd $MCPATH/cache || exit

# 
#function paperapi() {
#wget -q $SOFTAPI -O version.json
#wget -q $SOFTAPI/$LATEST -O $MCNAME.jar
#}

#if [[ $SOFTWARE == "paper"]] || 
#wget -q $SOFTAPI -O $MCNAME.jar
