#!/bin/bash
# This is the brand new Minecraft server manager build by CrazyCloudCraft.de
#MCPREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
MCNAME=$(yq eval '.name' mcsys.yml)
MCPATH=$(yq eval '.directory' mcsys.yml && sed 's/\/$//')
MCSOFT=$(yq eval '.software' mcsys.yml)

mcstart() { 
        if screen -list | grep -q "$MCNAME"; then echo -e "$(jq -r .mcstart.online ./libraries/mcsys/messages.json | sed "s:%s_name%:$MCNAME:g")" && exit 1; else echo -e "$(jq -r .mcstart.start ./libraries/mcsys/messages.json | sed "s:%s_name%:$MCNAME:g")"; fi
        if [ ! -f "$MCPATH"/"$MCNAME".jar ]; then touch "$MCPATH"/"$MCNAME".jar; fi
        if [ ! -f "$MCPATH"/libraries/mcsys/updater.sh ]; then touch "$MCPATH"/libraries/mcsys/updater.sh; fi
        sed -i 's/false/true/g' "$MCPATH"/eula.txt >/dev/null 2>&1
        sed -i 's;restart-script: ./start.sh;restart-script: ./main.sh 3;g' "$MCPATH"/spigot.yml >/dev/null 2>&1
        if [[ $(yq eval '.backup' mcsys.yml) == "true" ]] && [ -f "$MCNAME.jar" ]; then echo -e "$(jq -r .mcstart.backup.create ./libraries/mcsys/messages.json)"
        cd "$MCPATH"/libraries/mcsys/backups && usr/bin/find "$MCPATH"/libraries/mcsys/backups/* -type f -mtime +10 -delete 2>&1 #ls -1tr | head -n -10 | xargs -d '\n' rm -f --
        cd "$MCPATH" || exit 1
        tar -pzcf ./libraries/mcsys/backups/backup-"$MCNAME"-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz --exclude="unused/*" --exclude="$MCNAME.jar" --exclude="mcsys/*" --exclude="cache/*" --exclude="logs/*" --exclude="libraries/*" --exclude="paper.yml-README.txt" --exclude="screenlog.*" --exclude="versions/*" ./ 
        echo -e "$(jq -r .mcstart.backup.finish ./libraries/mcsys/messages.json)"; fi
        if [[ $(yq eval '.proxy' mcsys.yml) == "true" ]]; then sed -i '0,;online-mode=true;online-mode=false' "$MCPATH"/server.propeties >/dev/null 2>&1
        sed -i '0,;bungeecord: false;bungeecord: true' "$MCPATH"/spigot.yml >/dev/null 2>&1; else 
        sed -i '0,;online-mode=false;online-mode=true' "$MCPATH"/server.propeties >/dev/null 2>&1
        sed -i '0,;bungeecord: true;bungeecord: false' "$MCPATH"/spigot.yml >/dev/null 2>&1; fi
        # if $LOGROTATE == true ; then ...
        [ -f screenlog.6 ] && rm screenlog.6
        [ -f screenlog.5 ] && mv screenlog.5 screenlog.6
        [ -f screenlog.4 ] && mv screenlog.4 screenlog.5
        [ -f screenlog.3 ] && mv screenlog.3 screenlog.4
        [ -f screenlog.2 ]  && mv screenlog.2 screenlog.3
        [ -f screenlog.1 ] && mv screenlog.1 screenlog.2
        [ -f screenlog.0 ] && mv screenlog.0 screenlog.1
        if [[ $(yq eval '.bedrock' mcsys.yml) == "true" ]]; then echo -e "$(jq -r .mcstart.bedrock ./libraries/mcsys/messages.json)"
        cd "$MCPATH"/libraries/mcsys || exit 1
        wget -q https://raw.githubusercontent.com/Argantiu/minecraft-manager/dev-v3/api/v3/bedrock.sh
        chmod +x bedrock.sh
        /bin/bash "$MCPATH"/libraries/mcsys/bedrock.sh &
        fi
        /bin/bash "$MCPATH"/libraries/mcsys/software.sh "$MCSOFT" &
        wait for $!
        exit 0 ;}

mcstop() { if ! screen -list | grep -q "$MCNAME"; then echo -e "$(jq -r .mcstop.offline ./libraries/mcsys/messages.json)" && exit 1; fi
MCSOFTWARE=$(yq eval '.software' mcsys.yml && yq 'downcase')
if ! [[ $MCSOFTWARE == "bungeecord" ]] || [[ $MCSOFTWARE == "velocity" ]] || [[ $MCSOFTWARE == "waterfall" ]] && [[ $(yq eval '.count' mcsys.yml) == "true" ]]; then
mkdir -p "$MCPATH"/cache/mcsys && cd "$MCPATH"/cache/mcsys || exit 1
hostname -I > ip-info.txt
MCIPAD=$(cat < ip-info.txt | grep -o '^\S*')
MCPORT=$(cat < "$MCPATH"/server.properties | grep server-port= | cut -b 13,14,1)
wget -q https://api.minetools.eu/ping/"$MCIPAD"/"$MCPORT" -O on-i.txt
 if grep -q error "on-i.txt"; then echo -e "$(jq -r .counter.invalid ./libraries/mcsys/messages.json)" 
 else MCOTYPE=$(cat < on-i.txt | grep online | tr -d " " | cut -b 10)
 fi
fi
if ! [[ $MCOTYPE = "0" ]]; then screen -Rd "$MCNAME" -X stuff "say $(jq -r .counter.stop + 10 + .counter.sec ./libraries/mcsys/messages.json) $(printf '\r')" && sleep 6s
 screen -Rd "$MCNAME" -X stuff "say $(jq -r .counter.stop + 4 + .counter.sec ./libraries/mcsys/messages.json) $(printf '\r')" && sleep 1s
 screen -Rd "$MCNAME" -X stuff "say $(jq -r .counter.stop + 3 + .counter.sec ./libraries/mcsys/messages.json) $(printf '\r')" && sleep 1s
 screen -Rd "$MCNAME" -X stuff "say $(jq -r .counter.stop + 2 + .counter.sec ./libraries/mcsys/messages.json) $(printf '\r')" && sleep 1s
 screen -Rd "$MCNAME" -X stuff "say $(jq -r .counter.stop + 1 + .counter.sec ./libraries/mcsys/messages.json) $(printf '\r')" && sleep 1s
fi
screen -Rd "$MCNAME" -X stuff "say $(jq -r .mcstop.stop_n ./libraries/mcsys/messages.json | sed "s:%s_name%:$MCNAME:g") $(printf '\r')"
StopChecks=0
while [ $StopChecks -lt 30 ]; do
  if ! screen -list | grep -q "$MCNAME"; then
    break
  fi
  sleep 1;
  StopChecks=$((StopChecks+1))
done
if screen -list | grep -q "$MCNAME"; then
  echo -e "$(jq -r .mcstop.kill ./libraries/mcsys/messages.json)"
  screen -S "$MCNAME" -X quit
  pkill -15 -f "SCREEN -dmSL $MCNAME"
fi
echo -e "$(jq -r .mcstop.stopped ./libraries/mcsys/messages.json | sed "s:%s_name%:$MCNAME:g")"
exit 0 ;}

mcrestart() { if ! screen -list | grep -q "$MCNAME"; then echo -e "$(jq -r .mcstop.offline + .mcstart.start ./libraries/mcsys/messages.json | sed "s:%s_name%:$MCNAME:g")" && mcstart && exit 0
else
mcstop &
wait for $!
mcstart
fi
exit 0 ;}

mcdelete() { echo -e "$(jq -r .tool.remove ./libraries/mcsys/messages.json)"
{ echo -n "";
read -r MCONFIRM; }
if [[ $MCONFIRM == "ja" ]] || [[ $MCONFIRM == "yes" ]]; then 
mcstop &
DELMC="$?" 
wait $DELMC
rm ./mcsys.yml && rm -r ./cache
cd ./libraries || exit 1
rm -r ./mcsys && echo -e "$(jq -r .tool.rm_ok ./libraries/mcsys/messages.json)" && rm -- "$0"
else echo -e "$(jq -r .tool.rm_no ./libraries/mcsys/messages.json)"
fi
exit 0 ;}

help() { jq -r .tool.help ./libraries/mcsys/messages.json;}

while getopts ":1:2:3:4" option; do
   case $option in
     1) mcstart;;
     2) mcstop;;
     3) mcresart;;
     4) mcdelete;;
     \?) echo "Error: Invalid option" && help && exit;;
   esac
done
