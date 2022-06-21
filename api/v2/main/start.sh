#!/bin/bash
# Minecraft Server auto stop script - Do not configure this scipt!!
# Version 3.0.0.0-#0 made by Argantiu GmBh 06/21/2022 UTC/GMT +1 https://crazycloudcraft.de
ASOFTWARE=
OPTBASE=
SERVERBASE=
MCNAME=
BEMCSUPPORT=
BACKUP=
BPATH=
MPREFIX=
# For sed
MAINVERSION=
MCNAME=
LPATH=
RAM=
JAVABIN=
#Already Started
if screen -list | grep -q "$MCNAME"; then
    echo -e "$MPREFIX Server has already started! Use screen -r $MCNAME to open it"
    exit 1
else
echo -e "$MPREFIX Starting server..."
fi
# Path generating
LPATH=/$OPTBASE/$SERVERBASE
# Adding if not exist
if [ -f $LPATH/$MCNAME.jar ]; then
 echo "Jar exists" >/dev/null 2>&1
else
 touch $LPATH/$MCNAME.jar
fi
# Auto updater


# Create backup for your server
if [[ $BACKUP == "TRUE" ]]; then
 if [ -f "$MCNAME.jar" ]; then
    echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Create Backup..."
    echo "Backing up server (to /unused/$BPATH folder)" | /usr/bin/logger -t $MCNAME
    cd $LPATH/unused/$BPATH && ls -1tr | head -n -10 | xargs -d '\n' rm -f --
    cd $LPATH || exit 1
    tar -pzcf ./unused/$BPATH/backup-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz --exclude='unused/*' ./
 fi
fi
# Bedrock Part
if [[ $BEMCUPDATE == "TRUE" ]]; then
 echo -e "$MPREFIX Updateing Bedrock"
 cd $LPATH/mcsys || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/be-updater.sh -O be-updater.sh
 chmod +x be-updater.sh
 # sed #
 /bin/bash $LPATH/mcsys/be-updater.sh
fi
# Software update and start

if [[ $ASOFTWARE == "PAPER" ]]; then
cd $LPATH/mcsys/software || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/paper.sh -O $MCNAME.sh
fi

if [[ $ASOFTWARE == "VELOCITY" ]]; then
cd $LPATH/mcsys/software || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/paper.sh -O $MCNAME.sh
fi

if [[ $ASOFTWARE == "PURPUR" ]]; then
cd $LPATH/mcsys/software || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/paper.sh -O $MCNAME.sh
fi

if [[ $ASOFTWARE == "MOHIST" ]]; then
cd $LPATH/mcsys/software || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/paper.sh -O $MCNAME.sh
fi

if [[ $ASOFTWARE == "SPIGOT" ]]; then
cd $LPATH/mcsys/software || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/paper.sh -O $MCNAME.sh
fi

if [[ $ASOFTWARE == "BUKKIT" ]]; then
cd $LPATH/mcsys/software || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/paper.sh -O $MCNAME.sh
fi

if [[ $ASOFTWARE == "BUNGEECORD" ]]; then
cd $LPATH/mcsys/software || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/paper.sh -O $MCNAME.sh
fi

if [[ $ASOFTWARE == "WATERFALL" ]]; then
cd $LPATH/mcsys/software || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/paper.sh -O $MCNAME.sh
fi

sed -i "0,/MAINVERSION=.*/s//MAINVERSION=$MAINVERSION/" $LPATH/mcsys/$MCNAME.sh >/dev/null 2>&1
sed -i "0,/MCNAME=.*/s//MCNAME=$MCNAME/" $LPATH/mcsys/$MCNAME.sh >/dev/null 2>&1
sed -i "0,/LPATH=.*/s//LPATH=$LPATH/" $LPATH/mcsys/$MCNAME.sh >/dev/null 2>&1
sed -i "0,/RAM=.*/s//RAM=$RAM/" $LPATH/mcsys/$MCNAME.sh >/dev/null 2>&1
sed -i "0,/JAVABIN=.*/s//JAVABIN=$JAVABIN/" $LPATH/mcsys/$MCNAME.sh >/dev/null 2>&1
