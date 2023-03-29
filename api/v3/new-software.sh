#!/bin/bash
MCVER=$(yq eval '.version' ./../../mcsys.yml)
SOFTWARE=$(yq eval '.software' ./../../mcsys.yml)
LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " ")
MCJAVA=$($MCVER && cut -d "." -f2)

case "$SOFTWARE" in
minecraft) SOFTAPI=https://piston-data.mojang.com/v1/ ;;
paper) SOFTAPI=https://api.papermc.io/v2/projects/paper/versions/"$MCVER"/ ;;
purpur) SOFTAPI=https://api.purpurmc.org/purpur/"$MCVER"/ ;;
spigot) SOFTAPI=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar ;;
bukkit) SOFTAPI=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar ;;
mohist) SOFTAPI=https://mohistmc.com/api/ ;;
magma) SOFTAPI=https:// ;;
velocity) SOFTAPI=https://api.papermc.io/v2/projects/velocity/versions/"$MCVER"/ ;;
waterfall) SOFTAPI=https://api.papermc.io/v2/projects/waterfall/versions/"$MCVER"/ ;;
bungeecord) SOFTAPI=https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
*) echo "Error >> Software doesn't exitst. Does it have a typo?" ;;
esac

function mcloadbase() {
if [[ $MCJAVA == "19" ]] || [[ $MCJAVA == "18" ]]; then 
apt install zulu17-jdk
else 
apt install zulu8-jdk
fi
}

# Downloader
cd $MCPATH/cache || exit

# 
function paperapi() {
wget -q $SOFTAPI -O version.json
wget -q $SOFTAPI/$LATEST -O $MCNAME.jar
}

if [[ $SOFTWARE == "paper"]] || 
#wget -q $SOFTAPI -O $MCNAME.jar