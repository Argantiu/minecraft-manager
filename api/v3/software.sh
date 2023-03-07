#!/bin/bash
MCVERSION=$(yq eval '.version' ./../../mcsys.yml)
RAM=$(yq eval '.ram' ./../../mcsys.yml)
MCNAME=$(yq eval '.name' ./../../mcsys.yml)
MCPATH=$(yq eval '.directory' ./../../mcsys.yml)
MCVERS=$($MCVERSION && cut -d "." -f2)
DATE=$(date +%Y.%m.%d.%H.%M.%S)
#if [[ $(yq eval .debug ../../mcsys.yml) == "true" ]]; then MCDEBUG=&> /dev/null 2>&1; fi

PMC=https://api.papermc.io/v2
PAPERAPI="$PMC"/projects/paper/versions/
PURPURAPI="$PMC"/purpur/
#SPIBUKAPI=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
#MOHISTAPI=https://mohistmc.com/api/
#BUNGEEAPI=https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
#WATERAPI="$PMC"/projects/waterfall/versions/
#VELOAPI="$PMC"/projects/velocity/versions/
#MCAPI=https://piston-data.mojang.com/v1/
# 1. Selection software
# 2. Download and prepare
# 3. Select start Arguments
# 1 = Paper + PurPur 
# 2 = Spigot + Bukkit 
# 3 = Velocy + Waterfall
# 4 = Bungeecord
# 5 = Mohist + Magma
# 6 = Minecraft

function mclinkapi() {
wget -q $(grep )
}



function mcloadbase() {
if [[ $MCVERS == "19" ]] || [[ $MCVERS == "18" ]]; then 
apt install zulu17-jdk
else 
apt install zulu8-jdk
fi

cd "$MCPATH"/libraries/mcsys/saves && rm -f version.json || exit 1

if [[ $SOFTTYPE == "1" ]] || [[ $SOFTTYPE == "3" ]]; then wget -q "$APILINK""$MCVERSION"/ -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ") ; fi
mclinkapi
}


deniedaction() {
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
}
mcserverstart() {
cd "$MCPATH" || exit 1
echo "Starting $MCPATH/$MCNAME.jar" | /usr/bin/logger -t "$MCNAME"
if [[ $SOFTTYPE == 1 ]]; then
screen -d -m -L -S "$MCNAME"  /bin/bash -c "$JAVABIN -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true --add-modules=jdk.incubator.vector -jar $MCNAME.jar nogui"
exit 1
}




paper() { 
mcbase && wget -q "$PAPERAPI""$MCVERSION"/ -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
wget -q "$PAPERAPI""$MCVERSION"/builds/"$LATEST"/downloads/paper-"$MCVERSION"-"$LATEST".jar -O paper-"$MCVERSION"-"$LATEST".jar

if [ "$(unzip -qq -t paper-"$MCVERSION"-"$LATEST".jar)" -ne 0 ]; then 
echo "Downloaded paper-$MCVERSION-$LATEST.jar is corrupt. No update."
else 
diff -q paper-"$MCVERSION"-"$LATEST".jar "$MCPATH"/"$MCNAME".jar >/dev/null 2>&1
 
 if [ "$?" -eq 1 ]; then 
   cp paper-"$MCVERSION"-"$LATEST".jar paper-"$MCVERSION"-"$LATEST".jar."$(date +%Y.%m.%d.%H.%M.%S)" 
   mv paper-"$MAINVERSION"-"$LATEST".jar "$MCPATH"/"$MCNAME".jar
  /usr/bin/find "$MCPATH"/libraries/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1
  echo "paper-$MCVERSION-$LATEST has been updated"
  else 
  echo "No paper update neccessary" 
  rm paper-"$MCVERSION"-"$LATEST".jar
 fi
fi
rm -f version.json
cd "$MCPATH" || exit 1
echo "Starting $MCPATH/$MCNAME.jar"
screen -d -m -L -S "$MCNAME"  /bin/bash -c "/usr/bin/java -Xms$RAM -Xmx$RAM -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $MCNAME.jar nogui"
exit 1
}
#purpur() velocity() waterfall() bungeecord() minecraft() bukkit() spigot() mohist()
purpur) {
mcbase
wget -q "$PURPURAPI""$MAINVERSION" -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -v ":" | grep -e "[0-9]" | cut -d "\"" -f2)
wget -q "$PURPURAPI""$MAINVERSION"/"$LATEST"/download -O "$LATEST".jar
unzip -qq -t "$LATEST".jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded purpur-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t "$MCNAME"
else
 diff -q purpur-"$MAINVERSION"-"$LATEST".jar "$MTPATH"/"$MCNAME".jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp purpur-"$MAINVERSION"-"$LATEST".jar purpur-"$MAINVERSION"-"$LATEST".jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv purpur-"$MAINVERSION"-"$LATEST".jar "$MTPATH"/"$MCNAME".jar
  /usr/bin/find "$MTPATH"/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
  echo "purpur-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t "$MCNAME"
  rm version.json
 else
  echo "No purpur-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t "$MCNAME"
  rm purpur-"$MAINVERSION"-"$LATEST".jar
  rm version.json
 fi
fi
# Starting server
}

case "$1" in
paper) paper ;;
esac
