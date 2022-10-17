#!/bin/bash
# Here is a setting for developers if, they create a own fork user/repo
IFCREATEDFORK=Argantiu/system-api
# Automatic minecraft server script - Edit at your own risks!!
# Version 3.0.0.0-#0 created by CrazyCloudCraft https://crazycloudcraft.de
. ./configs/variables.sh
# Already Started
if screen -list | grep -q "$MCNAME"; then
    echo -e ""
    exit 1
else
echo -e "$MPREFIX Starte $MCNAME server..."
fi
# Bugg Patcher 
if [ -f $MTPATH/$MCNAME.jar ]; then
 echo "Server Jar exists" >/dev/null 2>&1
else
 touch $MTPATH/$MCNAME.jar
fi
# Auto updater
mkdir -p $MTPATH/mcsys/update
cd $MTPATH/mcsys/update || exit 1
wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/update/updater.sh -O updater-new.sh
diff -q updater-new.sh updater.sh >/dev/null 2>&1
if [ "$?" -eq 1 ]; then
/bin/bash $MTPATH/mcsys/update/
fi

# Create backup for your server
if [[ $BACKUP == "TRUE" ]] || [[ $BACKUP == "true" ]]; then
 if [ -f "$MCNAME.jar" ]; then
    echo -e "$MPREFIX Create Backup..."
    echo "Backing up server (to /unused/backups folder)" | /usr/bin/logger -t $MCNAME
    cd $MTPATH/unused/backups && ls -1tr | head -n -10 | xargs -d '\n' rm -f --
    cd $MTPATH || exit 1
    if [[ $BETTERBACKUP == "TRUE" ]] || [[ $BETTERBACKUP == "true" ]]; then
    tar -pzcf ./unused/backups/backup-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz --exclude="unused/*" --exclude="$MCNAME.jar" --exclude="mcsys/*" --exclude="cache/*" --exclude="logs/*" --exclude="libraries/*" --exclude="paper.yml-README.txt" --exclude="screenlog.*" --exclude="versions/*" ./ 
    else
    tar -pzcf ./unused/backups/backup-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz --exclude="unused/*" --exclude="$MCNAME.jar" --exclude="mcsys/jar/*" --exclude="mcsys/floodgate/*" --exclude="mcsys/geyser/*" ./
    fi
 fi
fi
# Bedrock Part
if [[ $BEMCUPDATE == "TRUE" ]] || [[ $BEMCUPDATE == "true" ]]; then
 echo -e "$MPREFIX Updateing Bedrock"
 cd $MTPATH/mcsys || exit 1
 ? #wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/be/geyser.sh -O be-updater.sh
 #chmod +x be-updater.sh
 # sed #
 /bin/bash $MTPATH/mcsys/be-updater.sh
fi
# Software update and start
#Paper: Getting Update form your selected version.
if [[ $ASOFTWARE == "PAPER" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/paper.sh -O $MCNAME.sh
fi
#Velocity: Getting Update form your selected version.
if [[ $ASOFTWARE == "VELOCITY" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/velocity.sh -O $MCNAME.sh
fi
#Purpur: Getting Update form your selected version.
if [[ $ASOFTWARE == "PURPUR" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/purpur.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "MOHIST" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/mohist.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "SPIGOT" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/spigot.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "BUKKIT" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/bukkit.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "BUNGEECORD" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/bungeecord.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "WATERFALL" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/waterfall.sh -O $MCNAME.sh
fi

/bin/bash $MTPATH/mcsys/$MCNAME.sh
exit 0
