#!/bin/bash
# This is the brand new Minecraft server manager build by CrazyCloudCraft.de
MCPREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
MCNAME=$(yq eval '.name' mcsys.yml)
MCPATH=$(yq eval '.directory' mcsys.yml && sed 's/\/$//')
#MCVERSION=$(yq eval '.version' mcsys.yml
#MCCOUNT=yq eval '.count' mcsys.yml
#MCSOFTWARE=$(yq eval '.software' mcsys.yml && yq 'downcase')
#MCBACKUP=$(yq eval '.backup' mcsys.yml
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

# Update Java if needed.

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
