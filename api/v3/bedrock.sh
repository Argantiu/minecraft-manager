#!/bin/bash
SOFTWARE=$(yq eval '.software' ./../../mcsys.yml)
MCPATH=$(yq eval '.directory' ./../../mcsys.yml)
MCNAME=$(yq eval '.name' ./../../mcsys.yml)
# API Links. For easy change
GEYSERAPI=https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/"$SOFTWARE"
FLOODAPI=https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/
function floodgate() { # Floodgate instalation
find ."$MCPATH"/plugins ! -name "floodgate-$SOFTWARE.jar"  -name 'floodgate-*' -delete
if [ ! -f "$MCPATH"/plugins/floodgate-"$SOFTWARE".jar ]; then touch "$MCPATH"/plugins/floodgate-"$SOFTWARE".jar ; fi
cd "$MCPATH"/libraries/mcsys/bedrock || exit 1
case $SOFTWARE in
bungeecord|waterfall) wget -q "$FLOODAPI""$($SOFTWARE | cut -d "c" -f1)" -O floodgate.jar ;;
velocity) wget -q $FLOODAPI"$SOFTWARE" -O floodgate.jar ;;
paper|purpur|spigot|folia) wget -q "$FLOODAPI"spigot -O floodgate.jar ;;
esac
if [ "$(unzip -qq -t floodgate.jar)" -ne 0 ]; then echo "Downloaded floodgate $SOFTWARE is corrupt. No update."
else diff -q floodgate.jar "$MCPATH"/plugins/floodgate-"$SOFTWARE".jar >/dev/null 2>&1
if [ "$?" -eq 1 ]; then cp floodgate.jar floodgate-"$SOFTWARE".jar."$(date +%Y.%m.%d.%H.%M.%S)" && mv floodgate.jar "$MCPATH"/plugins/floodgate-"$SOFTWARE".jar && echo "floodgate $SOFTWARE has been updated"
/usr/bin/find "$MCPATH"/libraries/mcsys/bedrock/* -type f -mtime +5 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
else echo "No Floodgate $SOFTWARE update neccessary" && rm floodgate.jar ; fi ; fi
}
function geyser() { # Geyser instalation
find ."$MCPATH"/plugins ! -name "Geyser-$SOFTWARE.jar"  -name 'Geyser-*' -delete
if [ ! -f "$MCPATH"/plugins/Geyser-"$SOFTWARE".jar ]; then touch "$MCPATH"/plugins/Geyser-"$SOFTWARE".jar ; fi
cd "$MCPATH"/libraries/mcsys/bedrock || exit 1
case $SOFTWARE in
bungeecord|waterfall|velocity) wget -q "$GEYSERAPI""$SOFTWARE" -O Geyser.jar ;;
paper|purpur|spigot|folia) wget -q "$GEYSERAPI"spigot -O Geyser.jar ;;
esac
if [ "$(unzip -qq -t Geyser.jar)" -ne 0 ]; then echo "Downloaded Geyser $SOFTWARE is corrupt. No update."
else diff -q Geyser.jar "$MCPATH"/plugins/Geyser-"$SOFTWARE".jar >/dev/null 2>&1
if [ "$?" -eq 1 ]; then cp Geyser.jar Geyser-"$SOFTWARE".jar."$(date +%Y.%m.%d.%H.%M.%S)" && mv Geyser.jar "$MCPATH"/plugins/Geyser-"$SOFTWARE".jar && echo "Geyser $SOFTWARE has been updated"
/usr/bin/find "$MCPATH"/libraries/mcsys/bedrock/* -type f -mtime +5 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
else echo "No Geyser $SOFTWARE update neccessary" && rm Geyser.jar ; fi ; fi
}
function proxycheck() { # Is this Server connected to a Proxy? Check the config files.
case "$SOFTWARE" in
paper|purpur|spigot) 
if [[ $(cat < "$MCPATH"/configs/paper-global.yml | grep velocity: | cut -d " " -f2) == "true" ]] || [[ $(cat < "$MCPATH"/spigot.yml | grep bungeecord: | cut -d " " -f2) == "true" ]]; then 
floodgate ; else floodgate && geyser ; fi 
;;
*) floodgate && geyser ;;
esac
}
# Starter
mkdir -p "$MCPATH"/libraries/mcsys/bedrock
case "$SOFTWARE" in
paper|purpur|spigot|folia) proxycheck ;;
waterfall|bungeecord|velocity) floodgate && geyser ;;
*) echo "Software dosen't support Bedrock Edition." ;;
esac
exit 0
