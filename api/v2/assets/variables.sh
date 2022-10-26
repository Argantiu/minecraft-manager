#!/bin/bash
# Here are the System variables don't edit them here. You can use the mcsys.yml ;)
# Automatic minecraft server script - Edit at your own risks!!
# Version 3.0.0.0-#0 created by CrazyCloudCraft https://crazycloudcraft.de

# Software
VARSOFT=$(cat < mcsys.yml | grep software: | cut -d ':' -d ' ' -f2)
if [[ $ASOFTWARE == "PURPUR" ]] || [[ $ASOFTWARE == "purpur" ]] || [[ $ASOFTWARE == "purpurmc" ]]; then ASOFTWARE=PURPUR
fi
if [[ $VARSOFT == "PAPER" ]] || [[ $VARSOFT == "papermc" ]] || [[ $VARSOFT == "paper" ]] || [[ $VARSOFT == "paperspigot" ]]; then ASOFTWARE=PAPER
fi
if [[ $VARSOFT == "SPIGOT" ]] || [[ $VARSOFT == "spigot" ]] || [[ $VARSOFT == "spogotmc" ]]; then ASOFTWARE=SPIGOT
fi
if [[ $ASOFTWARE == "BUKKIT" ]] || [[ $ASOFTWARE == "bukkit" ]] || [[ $ASOFTWARE == "bukkitmc" ]]; then ASOFTWARE=BUKKIT
fi
# Modded
if [[ $ASOFTWARE == "MOHIST" ]] || [[ $ASOFTWARE == "mohist" ]] || [[ $ASOFTWARE == "mohistmc" ]]; then ASOFTWARE=MOHIST
fi
# Proxy
if [[ $ASOFTWARE == "VELOCITY" ]] || [[ $ASOFTWARE == "velo" ]] || [[ $ASOFTWARE == "velocity" ]]; then ASOFTWARE=VELOCITY
fi
if [[ $ASOFTWARE == "BUNGEECORD" ]] || [[ $ASOFTWARE == "bungeecord" ]] || [[ $ASOFTWARE == "bungee" ]]; then ASOFTWARE=BUNGEECORD
fi
if [[ $ASOFTWARE == "WATERFALL" ]] || [[ $ASOFTWARE == "waterfall" ]] || [[ $ASOFTWARE == "waterfallmc" ]]; then ASOFTWARE=WATERFALL
fi
## Variablen möglich machen, dass man farben verwenden kann ( "§a §9" etc.) 
MLANG=./messages.lang
#TR1=$(cat < $MLANG | grep startsh.already.online: | cut -d ':' -d ' ' -f2)


version: 1.19.2
software: PAPER
server.directory: opt/MeinServer
systemname: mcpaper
ram: 4GB
java: /usr/bin/java
proxy.mode: false
dynamic.counter: true
backups: false
primebackups: false
bedrock: false
sys.prefix: §8[§aArgantiu§8]



MTPATH=$(cat < mcsys.yml | grep server.directory: | cut -d ':' -d ' ' -f2)

BEUPDATE=$(cat < mcsys.yml | grep BEMCUPDATE= | cut -d ':' -d ' ' -f2)
BACKUP=$(cat < mcsys.yml | grep BACKUP= | cut -d ':' -d ' ' -f2)
BETTERBACKUP=$(cat < mcsys.yml | grep BETTERBACKUP= | cut -d ':' -d ' ' -f2)
MPREFIX=$(cat < mcsys.yml | grep MPREFIX= | cut -d ':' -d ' ' -f2)
MCNAME=$(cat < mcsys.yml | grep MCNAME= | cut -d ':' -d ' ' -f2)

OPTBASE=
SERVERBASE=
# manage.tool
SERVERNAME=$(cat < mcsys.yml | grep MCNAME: | cut -d '=' -f2)
# Tranzlations




#ASOFTWARE=$(cat mcsys.yml | grep "software:" | rev | cut -d '/' -f1 | rev )
IGNORE=$(cat mcsys.yml | grep "software:" | rev | cut -d '/' -f1 | rev )
ASOFTWARE=$(cat mcsys.yml | grep "software:" | tr -d " " | cut -d ':' -f2 | sed s/$IGNORE//m)
