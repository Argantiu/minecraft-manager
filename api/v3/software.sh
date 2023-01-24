#!/bin/bash

PAPERAPI=https://api.papermc.io/v2/projects/paper/versions/
PURPURAPI=https://api.purpurmc.org/v2/purpur/
SPIBUKAPI=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
MOHISTAPI=https://mohistmc.com/api/
BUNGEEAPI=https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
WATERAPI=https://api.papermc.io/v2/projects/waterfall/versions/
VELOAPI=https://api.papermc.io/v2/projects/velocity/versions/
MCAPI=https://piston-data.mojang.com/v1/

MCVERS=$(yq eval '.version' ./../../mcsys.yml && cut -d "." -f2)
if [[ $MCVERS == "19" ]] || [[ $MCVERS == "18" ]]; then
apt install zulu17-jdk
else apt install zulu8-jdk
fi

mcbase() {
cd "$MCPATH"/libraries/mcsys/saves || exit 1
rm -f version.json
}

paper() {
wget -q "$PAPERAPI""$MCVERSION"/ -O version.json
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
wget -q "$PAPERAPI""$MCVERSION"/builds/"$LATEST"/downloads/paper-"$MCVERSION"-"$LATEST".jar -O paper-"$MCVERSION"-"$LATEST".jar
unzip -qq -t paper-"$MAINVERSION"-"$LATEST".jar
if [ "$?" -ne 0 ]; then 
echo "Downloaded paper-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t "$MCNAME"
else 
diff -q paper-"$MAINVERSION"-"$LATEST".jar "$MTPATH"/"$MCNAME".jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then 
  cp paper-"$MAINVERSION"-"$LATEST".jar paper-"$MAINVERSION"-"$LATEST".jar."$(date +%Y.%m.%d.%H.%M.%S)" && mv paper-"$MAINVERSION"-"$LATEST".jar "$MTPATH"/"$MCNAME".jar
  /usr/bin/find "$MTPATH"/mcsys/saves/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
  echo "paper-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t "$MCNAME"
  rm -f version.json
 else 
  echo "No paper-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t "$MCNAME"
  rm paper-"$MAINVERSION"-"$LATEST".jar
  rm -f version.json
 fi
fi
}







velocity() {
}
waterfall() {
}
bungeecord() {
}
# Default Minecraft
minecraft() {
}
bukkit() {
}
spigot() {
}
paper() {
}
purpur() {
}
# Modded Server
mohist() {
}
