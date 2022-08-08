#!/bin/bash
# Automatisches Minecraft Server Script - Bearbeiten auf eigene Gefahr!!
# Version 3.0.0.0-#0 erstellt von Argantiu GmBh 08.08.2022 https://crazycloudcraft.de
ASOFTWARE=
OPTBASE=
SERVERBASE=
BEMCSUPPORT=
BACKUP=
MPREFIX=
# For sed
MAINVERSION=
MCNAME=
RAM=
JAVABIN=
# Path generating
MTPATH=/$OPTBASE/$SERVERBASE

#Already Started
if screen -list | grep -q "$MCNAME"; then
    echo -e "$MPREFIX Server ist schon längt online! Nutze: screen -r $MCNAME um in die Konsole zu gelangen"
    echo -e "$MPREFIX Sie können auch: less -r screenlog.0 schreiben um in den log zu sehen."
    exit 1
else
echo -e "$MPREFIX Starte $MCNAME server..."
fi
# Bugg Patcher 
if [ -f $LPATH/$MCNAME.jar ]; then
 echo "Jar exestiert, perfekt" >/dev/null 2>&1
else
 touch $LPATH/$MCNAME.jar
fi
# Auto updater
mkdir -p $LPATH/mcsys/update
cd $LPATH/mcsys/update || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/update/updater.sh -O updater.sh


# Create backup for your server
if [[ $BACKUP == "TRUE" ]]; then
 if [ -f "$MCNAME.jar" ]; then
    echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Create Backup..."
    echo "Backing up server (to /unused/$BPATH folder)" | /usr/bin/logger -t $MCNAME
    cd $LPATH/unused/$BPATH && ls -1tr | head -n -10 | xargs -d '\n' rm -f --
    cd $LPATH || exit 1
    if [[ $BETTERBACKUP == "TRUE" ]] || [[ $BETTERBACKUP == "true" ]]; then
    tar -pzcf ./unused/backups/backup-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz --exclude='unused/*' --exclude='$MCNAME.jar' --exclude='mcsys/jar/*' --exclude='mcsys/floodgate/*' --exclude='mcsys/geyser/*' ./
    else
    tar -pzcf ./unused/backups/backup-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz --exclude='unused/*' --exclude='$MCNAME.jar' --exclude='mcsys/*' --exclude='cache/*' --exclude='logs/*' --exclude='libraries/*' --exclude='paper.yml-README.txt' --exclude='screenlog.*' --exclude='versions/*' ./
    fi
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
#Paper: Getting Update form your selected version.
if [[ $ASOFTWARE == "PAPER" ]]; then
 cd $LPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/paper.sh -O $MCNAME.sh
fi
#Velocity: Getting Update form your selected version.
if [[ $ASOFTWARE == "VELOCITY" ]]; then
 cd $LPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/velocity.sh -O $MCNAME.sh
fi
#Purpur: Getting Update form your selected version.
if [[ $ASOFTWARE == "PURPUR" ]]; then
 cd $LPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/purpur.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "MOHIST" ]]; then
 cd $LPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/mohist.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "SPIGOT" ]]; then
 cd $LPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/spigot.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "BUKKIT" ]]; then
 cd $LPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/bukkit.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "BUNGEECORD" ]]; then
 cd $LPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/bungeecord.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "WATERFALL" ]]; then
 cd $LPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v2/software/waterfall.sh -O $MCNAME.sh
fi

sed -i "0,/MAINVERSION=.*/s//MAINVERSION=$MAINVERSION/" $LPATH/mcsys/$MCNAME.sh >/dev/null 2>&1
sed -i "0,/MCNAME=.*/s//MCNAME=$MCNAME/" $LPATH/mcsys/$MCNAME.sh >/dev/null 2>&1
sed -i "0,/LPATH=.*/s//LPATH=$LPATH/" $LPATH/mcsys/$MCNAME.sh >/dev/null 2>&1
sed -i "0,/RAM=.*/s//RAM=$RAM/" $LPATH/mcsys/$MCNAME.sh >/dev/null 2>&1
sed -i "0,/JAVABIN=.*/s//JAVABIN=$JAVABIN/" $LPATH/mcsys/$MCNAME.sh >/dev/null 2>&1

/bin/bash $LPATH/$MCNAME.sh
exit 0
