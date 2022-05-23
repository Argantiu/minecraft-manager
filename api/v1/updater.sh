#!/bin/bash
# Updating everything... Made by Argantiu
# Don't edit this here
# shellcheck source=/lang/en/mcsys.conf
. /../config/mcsys.txt
# shellcheck source=/dev/null
. /../config/values.txt.old 
# Path generating
LPATH=/$OPTBASE/$SERVERBASE
#
apt-get -qq update -y
cd $LPATH/mcsys/config || exit 1
mv values.txt values.txt.old
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/values.txt -O values.txt
sed -i "s:empty:$DSERVERFOLDER:g" ./values.txt $>/dev/null 2>&1
cd $LPATH/mcsys || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/restart.sh -O restart.sh
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/start.sh -O start.sh
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/stop.sh -O stop.sh
chmod +x ./*.sh
cd $LPATH/mcsys/updater || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/updater.sh -O updater.sh
exit 1

