#!/bin/bash
# Updating everything... Made by Argantiu
# Don't edit this here
# shellcheck source=/lang/en/mcsys.conf
source ../config/mcsys.conf
# shellcheck source=/dev/null
source ../config/values.conf.old 
# Path generating
LPATH=/$OPTBASE/$SERVERBASE
#
apt-get -qq update -y
cd $LPATH/mcsys/config || exit 1
mv values.conf values.conf.old
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/values.conf -O values.conf
sed -i "s:empty:$DSERVERFOLDER:g" ./values.conf $>/dev/null 2>&1
cd $LPATH/mcsys || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/restart.sh -O restart.sh
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/start.sh -O start.sh
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/stop.sh -O stop.sh
chmod +x ./*.sh
cd $LPATH/mcsys/updater || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/updater.sh -O updater.sh
exit 1

