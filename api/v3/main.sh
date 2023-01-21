#!/bin/bash
# This is the brand new Minecraft server manager build by CrazyCloudCraft.de
MCPREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
MCNAME=$(yq eval '.name' mcsys.yml)
MCPATH=$(yq eval '.directory' mcsys.yml && sed 's/\/$//')
#MCVERSION=$(yq eval '.version' mcsys.yml
#MCCOUNT=
#MCSOFTWARE=yq 'downcase'
#MCBACKUP=
#MCBEDROCK=
#MCPROXY=

mcstart (){
if screen -list | grep -q "$MCNAME"; then echo -e "$MSTART1" && exit 1
else echo -e "$MSTART2"
fi

# Fix System errors.

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
