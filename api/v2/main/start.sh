#!/bin/bash
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
    echo -e "$MSTART4"
    else
    tar -pzcf ./unused/backups/backup-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz --exclude="unused/*" --exclude="$MCNAME.jar" --exclude="mcsys/jar/*" --exclude="mcsys/floodgate/*" --exclude="mcsys/geyser/*" ./
    echo -e "$MSTART4"
    fi
 fi
fi
# Bedrock Part
if [[ $BEUPDATE == "TRUE" ]] || [[ $BEUPDATE == "true" ]]; then
 echo -e "$MSTART5"
 cd $MTPATH/mcsys || exit 1
 ? #wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/be/geyser.sh -O be-updater.sh
 #chmod +x be-updater.sh
 # sed #
 /bin/bash $MTPATH/mcsys/be-updater.sh
fi
# Software update and start
#Paper: Getting Update form your selected version.
cd $MTPATH/mcsys/software || exit 1
wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/software/$ASOFTWARE -O $MCNAME.sh
/bin/bash $MTPATH/mcsys/$MCNAME.sh && exit 0
