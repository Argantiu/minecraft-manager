#!/bin/bash
# This is the brand new Minecraft server manager build by CrazyCloudCraft.de
MCPREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
MCNAME=$(yq eval '.name' mcsys.yml)
MCPATH=$(yq eval '.directory' mcsys.yml && sed 's/\/$//')
#MCCOUNT=yq eval '.count' mcsys.yml
#MCSOFTWARE=$(yq eval '.software' mcsys.yml && yq 'downcase')
#MCBEDROCK=$(yq eval '.bedrock' mcsys.yml
#MCPROXY=$(yq eval '.proxy' mcsys.yml

mcstart (){
if screen -list | grep -q "$MCNAME"; then echo -e "1" && exit 1
else echo -e "2"
fi
if [ ! -f "$MCPATH"/"$MCNAME".jar ]; then touch "$MCPATH"/"$MCNAME".jar
fi
if [ ! -f "$MCPATH"/libraries/mcsys/updater.sh ]; then touch "$MCPATH"/libraries/mcsys/updater.sh
fi
sed -i 's/false/true/g' "$MCPATH"/eula.txt >/dev/null 2>&1
sed -i 's;restart-script: ./start.sh;restart-script: ./main.sh 3;g' "$MCPATH"/spigot.yml >/dev/null 2>&1
MCBACKUP=$(yq eval '.backup' mcsys.yml
if [[ $MCBACKUP == "true" ]]; then
 if [ -f "$MCNAME.jar" ]; then echo -e "3"
    cd "$MCPATH"/libraries/mcsys/backups && usr/bin/find "$MTPATH"/unused/backups/* -type f -mtime +10 -delete 2>&1 #ls -1tr | head -n -10 | xargs -d '\n' rm -f --
    cd "$MCPATH" || exit 1
    if [[ $BETTERBACKUP == "TRUE" ]] || [[ $BETTERBACKUP == "true" ]]; then
    tar -pzcf ./unused/backups/backup-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz --exclude="unused/*" --exclude="$MCNAME.jar" --exclude="mcsys/*" --exclude="cache/*" --exclude="logs/*" --exclude="libraries/*" --exclude="paper.yml-README.txt" --exclude="screenlog.*" --exclude="versions/*" ./ 
    echo -e "$MSTART4"
    else
    tar -pzcf ./unused/backups/backup-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz --exclude="unused/*" --exclude="$MCNAME.jar" --exclude="mcsys/saves/*" ./
    echo -e "$MSTART4"
    fi
 fi
fi
# Make Backup
# push Software.sh
# Berock Part
# Chage to proxy if needed
# Logrotate
# wait until software finish
# Start Server
}

mcstop (){
# Check if Server already offline
# Check if can make counter
# Stopps server
}

mcrestart (){
# Check if server already offline
# restart server
}

mcdelete (){

}

##### Choosemodul
#-h or anythig = help
# 1 = Start
# 2 = Stop
# 3 = Restart
# 4 = Config
# 5 = Delete
# * = Help
