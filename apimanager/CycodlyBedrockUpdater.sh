#!/bin/bash

source ./CycodlySystemManager.sh
API=https://download.geysermc.org/v2/projects

function updateService() {
    local PRODUCT=$1
    local SOFTWARE=$2
    local VERSION=$(curl -s $API/$PRODUCT | jq -r .versions[-1])
    local LATEST=$(curl -s $API/$PRODUCT/versions/$VERSION | jq -r .builds[-1])
    local DOWNLOAD_URL=$API/$PRODUCT/versions/$VERSION/builds/$LATEST/downloads/$SOFTWARE

    cd "$MCPATH"/cycodly
    if [ -f $PRODUCT.json ] && [[ $(cat < $PRODUCT.json) == $LATEST ]]; then
        echo "Update not needed.";
        return;
    else
        echo $LATEST > $PRODUCT.json
    fi
    mkdir -p "$MCPATH"/cache/cycodly && cd "$_"

    
}
function updateFloodgate() {
    
}
function updateiHydraulic() {

}
function updateHurricane() {

}
function updateCosmetics() {

}

function updateViaVersion() {

}

if ! grep -qE 'velocity:\s*true|bungeecord:\s*true' "$MCPATH"/configs/paper-global.yml "$MCPATH"/spigot.yml; then
    updateGeyser 
fi
updateFloodgate
case $MCSOFTWARE in
paper|craftbukkit|spigot|purpur)
    if ! grep -qE 'velocity:\s*true|bungeecord:\s*true' "$MCPATH"/configs/paper-global.yml "$MCPATH"/spigot.yml; then
    updateService geyser spigot
    fi
    updateService hurricane spigot
    updateService thirdpartycosmetics thirdpartycosmetics
    ;;
mohist|youer)
    SOFTWARE=neoforge
    if ! grep -qE 'velocity:\s*true|bungeecord:\s*true' "$MCPATH"/configs/paper-global.yml "$MCPATH"/spigot.yml; then
    updateService geyser neoforge
    fi
    updateService hydraulic neoforge
    updateService hurricane spigot
    updateService thirdpartycosmetics thirdpartycosmetics
    ;;
banner)
    if ! grep -qE 'velocity:\s*true|bungeecord:\s*true' "$MCPATH"/configs/paper-global.yml "$MCPATH"/spigot.yml; then
    updateService geyser fabric
    fi
    updateService hydraulic fabric
    updateService hurricane spigot
    updateService thirdpartycosmetics thirdpartycosmetics
    ;;
velocity)
    updateService geyser velocity
    ;;
bungeecord|waterfall)
    updateService geyser fabric
    ;;
esac




########################################

# Floodgate instalation
function floodgate() { 
    local FLOODAPI=https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/
    find ."$MCPATH"/plugins ! -name "floodgate-$SOFTWARE.jar"  -name 'floodgate-*' -delete
    if [ ! -f "$MCPATH"/plugins/floodgate-"$SOFTWARE".jar ]; then 
        touch "$MCPATH"/plugins/floodgate-"$SOFTWARE".jar
    fi
    cd "$MCPATH"/libraries/mcsys/bedrock || exit 1
    
    case $SOFTWARE in
    bungeecord|waterfall) wget -q "$FLOODAPI""$($SOFTWARE | cut -d "c" -f1)" -O floodgate.jar ;;
    velocity) wget -q $FLOODAPI"$SOFTWARE" -O floodgate.jar ;;
    paper|purpur|spigot|folia) wget -q "$FLOODAPI"spigot -O floodgate.jar ;;
    esac
    
    if [ "$(unzip -qq -t floodgate.jar)" -ne 0 ]; then 
        echo "Downloaded floodgate $SOFTWARE is corrupt. No update."
    else 
        diff -q floodgate.jar "$MCPATH"/plugins/floodgate-"$SOFTWARE".jar >/dev/null 2>&1
        if [ "$?" -eq 1 ]; then 
            cp floodgate.jar floodgate-"$SOFTWARE".jar."$(date +%Y.%m.%d.%H.%M.%S)" 
            mv floodgate.jar "$MCPATH"/plugins/floodgate-"$SOFTWARE".jar 
            echo "floodgate $SOFTWARE has been updated"
            find "$MCPATH"/libraries/mcsys/bedrock/* -type f -mtime +5 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
        else 
            echo "No Floodgate $SOFTWARE update neccessary"
            rm floodgate.jar
        fi
    fi
}

# Geyser instalation
function geyser() {
    local GEYSERAPI=https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/"$SOFTWARE" 
    find ."$MCPATH"/plugins ! -name "Geyser-$SOFTWARE.jar"  -name 'Geyser-*' -delete
    if [ ! -f "$MCPATH"/plugins/Geyser-"$SOFTWARE".jar ]; then 
        touch "$MCPATH"/plugins/Geyser-"$SOFTWARE".jar
    fi
    cd "$MCPATH"/libraries/mcsys/bedrock || exit 1
    
    case $SOFTWARE in
        bungeecord|waterfall|velocity) wget -q "$GEYSERAPI""$SOFTWARE" -O Geyser.jar ;;
        paper|purpur|spigot|folia) wget -q "$GEYSERAPI"spigot -O Geyser.jar ;;
    esac
    
    if [ "$(unzip -qq -t Geyser.jar)" -ne 0 ]; then 
        echo "Downloaded Geyser $SOFTWARE is corrupt. No update."
    else 
        diff -q Geyser.jar "$MCPATH"/plugins/Geyser-"$SOFTWARE".jar >/dev/null 2>&1
        if [ "$?" -eq 1 ]; then 
            cp Geyser.jar Geyser-"$SOFTWARE".jar."$(date +%Y.%m.%d.%H.%M.%S)" 
            mv Geyser.jar "$MCPATH"/plugins/Geyser-"$SOFTWARE".jar 
            echo "Geyser $SOFTWARE has been updated"
            find "$MCPATH"/libraries/mcsys/bedrock/* -type f -mtime +5 -delete 2>&1 | /usr/bin/logger -t "$MCNAME"
        else 
            echo "No Geyser $SOFTWARE update neccessary" 
            rm Geyser.jar
        fi
    fi
}

function proxycheck() { # Is this Server connected to a Proxy? Check the config files.
    case "$SOFTWARE" in
        paper|purpur|spigot)
            if [[ $(cat < "$MCPATH"/configs/paper-global.yml | grep velocity: | cut -d " " -f2) == "true" ]] || [[ $(cat < "$MCPATH"/spigot.yml | grep bungeecord: | cut -d " " -f2) == "true" ]]; then
                floodgate
            else 
                floodgate 
                geyser
            fi
        ;;
        *) 
            floodgate 
            geyser 
        ;;
    esac
}
# Starter
mkdir -p "$MCPATH"/libraries/mcsys/bedrock
case "$SOFTWARE" in
    paper|purpur|spigot|folia) proxycheck ;;
    waterfall|bungeecord|velocity) floodgate && geyser ;;
    *) echo "Software dosen't support Bedrock Edition." ;;
esac
exit 0