#!/bin/bash
# Here is a setting for developers if, they create a own fork user/repo
IFCREATEDFORK=Argantiu/minecraft-manager
# Automatic minecraft server script - Edit at your own risks!!
# Version 3.0.0.0-#0 created by CrazyCloudCraft https://crazycloudcraft.de
# shellcheck source=./../assets/variables.sh
. ./configs/variables.sh
# Already Started
if screen -list | grep -q "$MCNAME"; then echo -e "$MSTART1" && exit 1
else echo -e "$MSTART2"
fi
# Bugg Patcher
if [ ! -f $MTPATH/$MCNAME.jar ]; then touch $MTPATH/$MCNAME.jar
fi
# Auto updater
mkdir -p $MTPATH/mcsys/update
cd $MTPATH/mcsys/update || exit 1
wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/update/updater.sh -O updater-new.sh
diff -q updater-new.sh updater.sh >/dev/null 2>&1
if [ "$?" -eq 1 ]; then mv updater-new.sh updater.sh && /bin/bash $MTPATH/mcsys/update/updater.sh
fi
# Create backup for your server
if [[ $BACKUP == "TRUE" ]] || [[ $BACKUP == "true" ]]; then
 if [ -f "$MCNAME.jar" ]; then echo -e "$MSTART3" && echo -e "$MSTART3" | /usr/bin/logger -t $MCNAME
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
if [[ $BEUPDATE == "TRUE" ]] || [[ $BEUPDATE == "true" ]]; then
 echo -e "$MSTART4"
 cd $MTPATH/mcsys || exit 1
 ? #wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/be/geyser.sh -O be-updater.sh
 #chmod +x be-updater.sh
 # sed #
 /bin/bash $MTPATH/mcsys/be-updater.sh
fi
# Software update and start
#Paper: Getting Update form your selected version.
if [[ $ASOFTWARE == "PAPER" ]] || [[ $ASOFTWARE == "paper" ]] || [[ $ASOFTWARE == "papermc" ]] || [[ $ASOFTWARE == "paperspigot" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/paper.sh -O $MCNAME.sh
fi
#Purpur: Getting Update form your selected version.
if [[ $ASOFTWARE == "PURPUR" ]] || [[ $ASOFTWARE == "purpur" ]] || [[ $ASOFTWARE == "purpurmc" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/purpur.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "MOHIST" ]] || [[ $ASOFTWARE == "mohist" ]] || [[ $ASOFTWARE == "mohistmc" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/mohist.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "SPIGOT" ]] || [[ $ASOFTWARE == "spigot" ]] || [[ $ASOFTWARE == "spigotmc" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/spigot.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "BUKKIT" ]] || [[ $ASOFTWARE == "bukkit" ]] || [[ $ASOFTWARE == "bukkitmc" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/bukkit.sh -O $MCNAME.sh
fi
#Proxys: Getting Update form your selected version.
if [[ $ASOFTWARE == "VELOCITY" ]] || [[ $ASOFTWARE == "velo" ]] || [[ $ASOFTWARE == "velocity" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/velocity.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "BUNGEECORD" ]] || [[ $ASOFTWARE == "bungeecord" ]] || [[ $ASOFTWARE == "bungee" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/bungeecord.sh -O $MCNAME.sh
fi
if [[ $ASOFTWARE == "WATERFALL" ]] || [[ $ASOFTWARE == "waterfall" ]] || [[ $ASOFTWARE == "waterfallmc" ]]; then
 cd $MTPATH/mcsys/software || exit 1
 wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/waterfall.sh -O $MCNAME.sh
fi
/bin/bash $MTPATH/mcsys/$MCNAME.sh && exit 0
