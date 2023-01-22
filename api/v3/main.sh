#!/bin/bash
# This is the brand new Minecraft server manager build by CrazyCloudCraft.de
MCPREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
MCNAME=$(yq eval '.name' mcsys.yml)
MCPATH=$(yq eval '.directory' mcsys.yml && sed 's/\/$//')

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
MCBACKUP=$(yq eval '.backup' mcsys.yml)
if [[ $MCBACKUP == "true" ]]; then
 if [ -f "$MCNAME.jar" ]; then echo -e "3"
   cd "$MCPATH"/libraries/mcsys/backups && usr/bin/find "$MCPATH"/libraries/mcsys/backups/* -type f -mtime +10 -delete 2>&1 #ls -1tr | head -n -10 | xargs -d '\n' rm -f --
   cd "$MCPATH" || exit 1
   tar -pzcf ./libraries/mcsys/backups/backup-"$MCNAME"-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz --exclude="unused/*" --exclude="$MCNAME.jar" --exclude="mcsys/*" --exclude="cache/*" --exclude="logs/*" --exclude="libraries/*" --exclude="paper.yml-README.txt" --exclude="screenlog.*" --exclude="versions/*" ./ 
   echo -e "4"
 fi
fi
MCPROXY=$(yq eval '.proxy' mcsys.yml)
if [[ $MCPROXY == "TRUE" ]]; then
sed -i '0,;online-mode=true;online-mode=false' "$MCPATH"/server.propeties >/dev/null 2>&1
sed -i '0,;bungeecord: false;bungeecord: true' "$MCPATH"/spigot.yml >/dev/null 2>&1
else 
sed -i '0,;online-mode=false;online-mode=true' "$MCPATH"/server.propeties >/dev/null 2>&1
sed -i '0,;bungeecord: true;bungeecord: false' "$MCPATH"/spigot.yml >/dev/null 2>&1
fi
# if $LOGROTATE == true ; then ...
[ -f screenlog.6 ] && rm screenlog.6
[ -f screenlog.5 ] && mv screenlog.5 screenlog.6
[ -f screenlog.4 ] && mv screenlog.4 screenlog.5
[ -f screenlog.3 ] && mv screenlog.3 screenlog.4
[ -f screenlog.2 ] && mv screenlog.2 screenlog.3
[ -f screenlog.1 ] && mv screenlog.1 screenlog.2
[ -f screenlog.0 ] && mv screenlog.0 screenlog.1
MCBEDROCK=$(yq eval '.bedrock' mcsys.yml)
if [[ $MCBEDROCK == "true" ]]; then echo -e "5"
 cd "$MCPATH"/libraries/mcsys || exit 1
 wget -q  
 chmod +x bedrock.sh
 /bin/bash "$MCPATH"/libraries/mcsys/bedrock.sh &
 fi
fi
/bin/bash "$MCPATH"/libraries/mcsys/software.sh &
exit 0
}

mcstop (){
if ! screen -list | grep -q "$MCNAME"; then echo -e "S1"
  exit 1
fi
MCCOUNT=$(yq eval '.count' mcsys.yml)
MCSOFTWARE=$(yq eval '.software' mcsys.yml && yq 'downcase')
if ! [[ $MCSOFTWARE == "bungeecord" ]] || [[ $MCSOFTWARE == "velocity" ]] || [[ $MCSOFTWARE == "waterfall" ]] && [[ $MCCOUNT == "true" ]]; then
mkdir -p "$MCPATH"/cache/mcsys && cd "$MCPATH"/cache/mcsys || exit 1
hostname -I > ip-info.txt
MCIPAD=$(cat < ip-info.txt | grep -o '^\S*')
MCPORT=$(cat < "$MTPATH"/server.properties | grep server-port= | cut -b 13,14,1)
wget -q https://api.minetools.eu/ping/"$MCIPAD"/"$MCPORT" -O on-i.txt
 if grep -q error "on-i.txt"; then echo -e "S3" 
 else MCOTYPE=$(cat < on-i.txt | grep online | tr -d " " | cut -b 10)
 fi
fi
if ! [[ $MCOTYPE = "0" ]]; then screen -Rd "$MCNAME" -X stuff "say S4 10 S5 $(printf '\r')" && sleep 6s
 screen -Rd "$MCNAME" -X stuff "say S4 4 S5 $(printf '\r')" && sleep 1s
 screen -Rd "$MCNAME" -X stuff "say S4 3 S5 $(printf '\r')" && sleep 1s
 screen -Rd "$MCNAME" -X stuff "say S4 2 S5 $(printf '\r')" && sleep 1s
 screen -Rd "$MCNAME" -X stuff "say S4 1 S5 $(printf '\r')" && sleep 1s
fi
screen -Rd "$MCNAME" -X stuff "say S6 $(printf '\r')"
StopChecks=0
while [ $StopChecks -lt 30 ]; do
  if ! screen -list | grep -q "$MCNAME"; then
    break
  fi
  sleep 1;
  StopChecks=$((StopChecks+1))
done
if screen -list | grep -q "$MCNAME"; then
  echo -e "S7"
  screen -S "$MCNAME" -X quit
  pkill -15 -f "SCREEN -dmSL $MCNAME"
fi
echo -e "S8"
exit 0
}

mcrestart (){
if ! screen -list | grep -q "$MCNAME"; then echo -e "S1 & 2" && mcstart && exit 0
else
mcstop
mcstart
fi
exit 0
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
