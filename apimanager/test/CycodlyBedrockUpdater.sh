#!/bin/bash

source ./CycodlySystemManager.sh
API=https://download.geysermc.org/v2/projects

function GeyserPlugin() {
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

    wget -q -O $PRODUCT-$SOFTWARE-$VERSION-$LATEST.jar $DOWNLOAD_URL
    
    if [ $(unzip -qq -t $PRODUCT-$SOFTWARE-$VERSION-$LATEST.jar) -ne 0 ]; then
        echo "Downloaded $PRODUCT-$SOFTWARE-$VERSION-$LATEST.jar is corrupt. No update.";
    else
        mkdir -p "$MCPATH"/cycodly/pluginbackup;
        cp $PRODUCT-$SOFTWARE-$VERSION-$LATEST.jar "$MCPATH"/cycodly/pluginbackup/"$PRODUCT"-"$SOFTWARE"-"$VERSION"-"$LATEST"_"$(date +%Y-%m-%d)".jar;
        find "$MCPATH"/cycodly/pluginbackup/* -type f -mtime +2 -delete 2>&1;
        
        if [[ $SOFTWARE =~ (fabric|quilt|forge|neoforge)$ ]]
            mv $PRODUCT-$SOFTWARE-$VERSION-$LATEST.jar "$MCPATH"/mods/$PRODUCT-$SOFTWARE-$VERSION-$LATEST.jar
        elif [[ $SOFTWARE == "thirdpartycosmetics" ]]
            mv $PRODUCT-$SOFTWARE-$VERSION-$LATEST.jar "$MCPATH"/plugins/$PRODUCT-$VERSION-$LATEST.jar
        else
            mv $PRODUCT-$SOFTWARE-$VERSION-$LATEST.jar "$MCPATH"/plugins/$PRODUCT-$SOFTWARE-$VERSION-$LATEST.jar
        fi
        cd "$MCPATH"/cache && rm -r -f cycodly
        echo "$MCSOFTWARE-$MCVERSION-$LATEST.jar updated";
        return;
    fi
}

function ViaProducts() {

}

function ModrinthPlugin() {

}

case $MCSOFTWARE in
paper|craftbukkit|spigot|purpur)
    if ! grep -qE 'velocity:\s*true|bungeecord:\s*true' "$MCPATH"/configs/paper-global.yml "$MCPATH"/spigot.yml; then
    GeyserPlugin geyser spigot
    fi
    GeyserPlugin floodgate spigot
    GeyserPlugin hurricane spigot
    GeyserPlugin thirdpartycosmetics thirdpartycosmetics
    ;;
mohist|youer)
    GeyserPlugin floodgate spigot
    GeyserPlugin hydraulic neoforge
    GeyserPlugin hurricane spigot
    GeyserPlugin thirdpartycosmetics thirdpartycosmetics
    ;;
banner)
    GeyserPlugin floodgate spigot
    GeyserPlugin hydraulic fabric
    GeyserPlugin hurricane spigot
    GeyserPlugin thirdpartycosmetics thirdpartycosmetics
    ;;
velocity)
    GeyserPlugin geyser velocity
    GeyserPlugin floodgate velocity
    ;;
bungeecord|waterfall)
    GeyserPlugin geyser bungeecord
    GeyserPlugin floodgate bungee
    ViaProducts 
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