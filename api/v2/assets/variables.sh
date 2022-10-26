#!/bin/bash
# Here are the System variables don't edit them here. You can use the mcsys.yml ;)
# Automatic minecraft server script - Edit at your own risks!!
# Version 3.0.0.0-#0 created by CrazyCloudCraft https://crazycloudcraft.de

# Here is a setting for developers if, they create a own fork user/repo
IFCREATEDFORK=Argantiu/minecraft-manager
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
MTPATH=$(cat < mcsys.yml | grep "server.directory:" | cut -d ':' -f2 | tr -d " ")
SERVERBASE=$(cat < mcsys.yml | grep "server.directory:" | rev | cut -d '/' -f1 | rev )
OPTBASE=$(cat < mcsys.yml | grep "server.directory:" | tr -d " " | cut -d ':' -f2 | sed s/$SERVERBASE//m)
# Prefix
#COLOR=\033[0;
#MPREFIX=$(cat < mcsys.yml | grep "sys.prefix:" | cut -d ':' -f2 | sed s:§0:\033[0;30m:m | )
# Farbliste:

# Black:        \033[0;30m'     Dark Gray:     \033[1;30m'
# Red:          \033[0;31m'     Light Red:     \033[1;31m'
# Green:        \033[0;32m'     Light Green:   \033[1;32m'
# Brown/Orange: \033[0;33m'     Yellow:        \033[1;33m'
# Blue:         \033[0;34m'     Light Blue:    \033[1;34m'
# Purple:       \033[0;35m'     Light Purple:  \033[1;35m'
# Cyan:         \033[0;36m'     Light Cyan:    \033[1;36m'
# Light Gray:   \033[0;37m'     White:         \033[1;37m'

MPREFIX=\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m 
# Version
MAINVERSION=$(cat < mcsys.yml | grep "version:" | cut -d ':' -f2)
# Systemname
MCNAME=$(cat < mcsys.yml | grep "systemname:" | cut -d ':' -f2)
# Ram 
RAM=$(cat < mcsys.yml | grep "ram:" | cut -d ':' -d 'B' -f2)
# Java
JAVABIN=$(cat < mcsys.yml | grep "java:" | cut -d ':' -f2)
# Proxy Mode
PROXYMO=$(cat < mcsys.yml | grep "proxy.mode:" | cut -d ':' -f2)
# Couter
MCOUNT=$(cat < mcsys.yml | grep "dynamic.counter:" | cut -d ':' -f2)
# Backups
BACKUP=$(cat < mcsys.yml | grep "backups:" | cut -d ':' -f2)
# Prime Backups
BETTERBACKUP=$(cat < mcsys.yml | grep "primebackups:" | cut -d ':' -f2)
# Bedrock
BEUPDATE=$(cat < mcsys.yml | grep "bedrock:" | cut -d ':' -f2)

## Variablen möglich machen, dass man farben verwenden kann ( "§a §9" etc.) 
MLANG=./messages.lang
TR1=$(cat < $MLANG | grep startsh.already.online: | cut -d ':' -d ' ' -f2)
