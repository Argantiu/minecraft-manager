#!/bin/bash
source ./CycodlySystemManager.sh

function javaManager() {
    local GETmcVersionType=$(echo $MCVERSION | cut -d '.' -f 2)
    apt install gnupg ca-certificates curl;
    curl -s https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg
    echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | tee /etc/apt/sources.list.d/zulu.list
    apt update
    if [[ GETmcVersionType -gt 19 ]]; then
        apt install zulu21-jdk;
    elif [[ GETmcVersionType -gt 16 ]]; then
        apt install zulu17-jdk;
    else 
        apt install zulu8-jdk;
    fi
    if java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d '.' -f1; then
        return;
    else
        echo "ERROR: Java installation failed!";
        exit 1;
    fi
}

function softwareInstall() {
    cd "$MCPATH"/cycodly
    if [ -f $MCSOFTWARE.json ] && [[ $(cat < $MCSOFTWARE.json) == $LATEST ]]; then
            echo "Update not needed.";
            minecraftServiceStart;
            return;
    else
        echo $LATEST > $MCSOFTWARE.json;
    fi
    mkdir -p "$MCPATH"/cache/cycodly && cd "$_"

    if [[ $MCSOFTWARE == "velocity" ]]; then 
        wget -q -O $MCSOFTWARE-$V_VERSION-$LATEST.jar $DOWNLOAD_URL
    elif [[ $MCSOFTWARE =~ ^("spigot"|"craftbukkit")$ ]]; then
        wget -q -O BuildTools-$LATEST.jar $DOWNLOAD_URL
            java -jar BuildTools-$LATEST.jar --rev $MCVERSION --compile $MCSOFTWARE 
        mv *$MCSOFTWARE*.jar $MCSOFTWARE-$MCVERSION-$LATEST.jar
    else
        wget -q -O $MCSOFTWARE-$MCVERSION-$LATEST.jar $DOWNLOAD_URL
    fi
    
    if [ $(unzip -qq -t $MCSOFTWARE-$MCVERSION-$LATEST.jar) -ne 0 ]; then
        echo "Downloaded $MCSOFTWARE-$MCVERSION-$LATEST.jar is corrupt. No update.";
    else
        mkdir -p "$MCPATH"/cycodly/softwarebackup;
        cp $MCSOFTWARE-$MCVERSION-$LATEST.jar "$MCPATH"/cycodly/softwarebackup/$MCSOFTWARE-"$MCVERSION"-"$LATEST"_"$(date +%Y-%m-%d)".jar;
        find "$MCPATH"/cycodly/softwarebackup/* -type f -mtime +10 -delete 2>&1;
        mv $MCSOFTWARE-$MCVERSION-$LATEST.jar "$MCPATH"/"$MCNAME".jar
        cd "$MCPATH"/cache && rm -r -f cycodly
        echo "$MCSOFTWARE-$MCVERSION-$LATEST.jar updated";
        minecraftServiceStart;
        return;
    fi
}

case $MCSOFTWARE in
paper|waterfall) 
    API=https://api.papermc.io/v2/projects
    LATEST=$(curl -s $API/$MCSOFTWARE/versions/$MCVERSION | jq -r .builds[-1]) 
    DOWNLOAD_URL=$API/$MCSOFTWARE/versions/$MCVERSION/builds/$LATEST/downloads/$MCSOFTWARE-$MCVERSION-$LATEST.jar
    ;;
velocity)
    API=https://api.papermc.io/v2/projects
    V_VERSION=$(curl -s $API/$MCSOFTWARE | jq -r .versions[-1])
    LATEST=$(curl -s $API/$MCSOFTWARE/versions/$V_VERSION | jq -r .builds[-1])
    DOWNLOAD_URL=$API/$MCSOFTWARE/versions/$MCVERSION/builds/$LATEST/downloads/$MCSOFTWARE-$V_VERSION-$LATEST.jar
    ;;
mohist|banner|youer)
    API=https://mohistmc.com/api/v2/projects
    LATEST=$(curl -s $API/$MCSOFTWARE/$MCVERSION/builds | jq -r .builds[-1].number)
    DOWNLOAD_URL=$API/$MCSOFTWARE/$MCVERSION/builds/$LATEST/$MCSOFTWARE-$MCVERSION-$LATEST-server.jar
    ;;
craftbukkit|spigot)
    API=https://hub.spigotmc.org/jenkins/job/BuildTools
    LATEST=$(curl -s $API/api/json | jq -r .builds[0].number)
    DOWNLOAD_URL=$API/$LATEST/artifact/bootstrap/target/BuildTools.jar
    ;;
purpur)
    API=https://api.purpurmc.org/v2/purpur
    LATEST=$(curl -s $API/$MCVERSION | jq -r .builds.all[-1])
    DOWNLOAD_URL=$API/$MCVERSION/$LATEST/download
    ;;
bungeecord)
    API=https://ci.md-5.net/job/BungeeCord
    LATEST=$(curl -s $API/api/json | jq -r .builds[0].number)
    DOWNLOAD_URL=$API/$LATEST/artifact/bootstrap/target/BungeeCord.jar
    ;;
esac
javaManager
softwareInstall