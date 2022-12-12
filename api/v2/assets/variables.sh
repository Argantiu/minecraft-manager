#!/bin/bash
# Here are the System variables don't edit them here. You can use the mcsys.yml ;)
# Automatic minecraft server script - Edit at your own risks!!
# Version 3.0.0.0-#0 created by CrazyCloudCraft https://crazycloudcraft.de
# shellcheck disable=SC2034

# Here is a setting for developers if, they create a own fork user/repo
IFCREATEDFORK=Argantiu/minecraft-manager

#while read -r key val; do
#    printf -v "$key" "$val"
#done < <(yq ".variables[] | key + ' ' + ." data.yml)

# Software
VARSOFT=$(cat < mcsys.yml | grep "software:" | cut -d ':' -f2 | tr -d " ")
if [[ $VARSOFT == "PURPUR" ]] || [[ $VARSOFT == "purpur" ]] || [[ $VARSOFT == "purpurmc" ]]; then ASOFTWARE=purpur.sh
fi
if [[ $VARSOFT == "PAPER" ]] || [[ $VARSOFT == "papermc" ]] || [[ $VARSOFT == "paper" ]] || [[ $VARSOFT == "paperspigot" ]]; then ASOFTWARE=paper.sh
fi
if [[ $VARSOFT == "SPIGOT" ]] || [[ $VARSOFT == "spigot" ]] || [[ $VARSOFT == "spogotmc" ]]; then ASOFTWARE=spigot.sh
fi
if [[ $VARSOFT == "BUKKIT" ]] || [[ $VARSOFT == "bukkit" ]] || [[ $VARSOFT == "bukkitmc" ]]; then ASOFTWARE=bukkit.sh
fi
# Modded
if [[ $VARSOFT == "MOHIST" ]] || [[ $VARSOFT == "mohist" ]] || [[ $VARSOFT == "mohistmc" ]]; then ASOFTWARE=modded/mohist.sh
fi
# Proxy
if [[ $VARSOFT == "VELOCITY" ]] || [[ $VARSOFT == "velo" ]] || [[ $VARSOFT == "velocity" ]]; then ASOFTWARE=proxy/velocity.sh
fi
if [[ $VARSOFT == "BUNGEECORD" ]] || [[ $VARSOFT == "bungeecord" ]] || [[ $VARSOFT == "bungee" ]]; then ASOFTWARE=proxy/bungeecord.sh
fi
if [[ $VARSOFT == "WATERFALL" ]] || [[ $VARSOFT == "waterfall" ]] || [[ $VARSOFT == "waterfallmc" ]]; then ASOFTWARE=proxy/waterfall.sh
fi
# Server Directory
#=$(cat mcsys.yml | grep "software:" | rev | cut -d '/' -f1 | rev )
MTPATH=$(cat < mcsys.yml | grep "server-directory:" | cut -d ':' -f2 | tr -d " ")
SERVERBASE=$(cat < mcsys.yml | grep "server-directory:" | rev | cut -d '/' -f1 | rev )
OPTBASE=$(cat < mcsys.yml | grep "server-directory:" | tr -d " " | cut -d ':' -f2 | sed s/"$SERVERBASE"//g)
# Prefix
#COLOR=\033[0;
#MPREFIX=$(cat < mcsys.yml | grep "sys.prefix:" | cut -d ':' -f2 | sed s:§0:\033[0;30m:g | )
# Farbliste:

# Black:        \033[0;30m'     Dark Gray:     \033[1;30m'
# Red:          \033[0;31m'     Light Red:     \033[1;31m'
# Green:        \033[0;32m'     Light Green:   \033[1;32m'
# Brown/Orange: \033[0;33m'     Yellow:        \033[1;33m'
# Blue:         \033[0;34m'     Light Blue:    \033[1;34m'
# Purple:       \033[0;35m'     Light Purple:  \033[1;35m'
# Cyan:         \033[0;36m'     Light Cyan:    \033[1;36m'
# Light Gray:   \033[0;37m'     White:         \033[1;37m'

MPREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
# Version
MAINVERSION=$(cat < mcsys.yml | grep "version:" | cut -d ':' -f2)
# Systemname
MCNAME=$(cat < mcsys.yml | grep "systemname:" | cut -d ':' -f2)
# Ram 
RAM=$(cat < mcsys.yml | grep "ram:" | cut -d ':' -d 'B' -f2)
# Java
JAVABIN=$(cat < mcsys.yml | grep "java:" | cut -d ':' -f2)
# Proxy Mode
PROXYMO=$(cat < mcsys.yml | grep "proxy-mode:" | cut -d ':' -f2)
# Couter
MCOUNT=$(cat < mcsys.yml | grep "dynamic-counter:" | cut -d ':' -f2)
# Backups
BACKUP=$(cat < mcsys.yml | grep "backups:" | cut -d ':' -f2)
# Prime Backups
BETTERBACKUP=$(cat < mcsys.yml | grep "primebackups:" | cut -d ':' -f2)
# Bedrock
BEUPDATE=$(cat < mcsys.yml | grep "bedrock:" | cut -d ':' -f2)

## Variablen möglich machen, dass man farben verwenden kann ( "§a §9" etc.) 
MLANG=messages.lang
# shellcheck disable=SC2086
#manage.tool
MANAGET1=$(cat < $MLANG | grep "manage.tool.output:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
MANAGET2=$(cat < $MLANG | grep "manage.tool.remove:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
MANAGET3=$(cat < $MLANG | grep "manage.tool.remove.ok:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
MANAGET4=$(cat < $MLANG | grep "manage.tool.remove.no:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
MANAGET5=$(cat < $MLANG | grep "manage.tool.no.input:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
#start.sh
MSTART1=$(cat < $MLANG | grep "startsh.server.online:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
MSTART2=$(cat < $MLANG | grep "startsh.server.start:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
MSTART3=$(cat < $MLANG | grep "startsh.backup.create:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
MSTART4=$(cat < $MLANG | grep "startsh.backup.folder:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
MSTART5=$(cat < $MLANG | grep "startsh.bedrock.update:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
#stop.sh
SHSTOP1=$(cat < $MLANG | grep "stopsh.server.offline:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
SHSTOP2=$(cat < $MLANG | grep "stopsh.server.stop.info:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
SHSTOP3=$(cat < $MLANG | grep "stopsh.counter.invalid:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
SHSTOP4=$(cat < $MLANG | grep "stopsh.counter.stop.10:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
SHSTOP5=$(cat < $MLANG | grep "stopsh.counter.stop.4:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
SHSTOP6=$(cat < $MLANG | grep "stopsh.counter.stop.3:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
SHSTOP7=$(cat < $MLANG | grep "stopsh.counter.stop.2:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
SHSTOP8=$(cat < $MLANG | grep "stopsh.counter.stop.1:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
SHSTOP9=$(cat < $MLANG | grep "stopsh.counter.stop:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
SHSTOP10=$(cat < $MLANG | grep "stopsh.server.stopping:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
SHSTOP11=$(cat < $MLANG | grep "stopsh.server.killing:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
SHSTOP12=$(cat < $MLANG | grep "stopsh.server.stopped:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
#restart.sh
SHRESTART=$(cat < $MLANG | grep "restartsh.server.offline:" | cut -d ':' -d '"' -f2 | sed "s:%server_name%:$MCNAME:g" | sed "s:%prefix%:$MPREFIX:g")
# END-
