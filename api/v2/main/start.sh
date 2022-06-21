#!/bin/bash
# Minecraft Server auto stop script - Do not configure this scipt!!
# Version 3.0.0.0-#0 made by Argantiu GmBh 06/21/2022 UTC/GMT +1 https://crazycloudcraft.de
#MAINVERSION=
#PRMCVERSION=3.1.2
#ASOFTWARE=
OPTBASE=
SERVERBASE=
MCNAME=
#RAM=
#JAVABIN=
BEMCSUPPORT=
BACKUP=
BPATH=
#Already Started
if screen -list | grep -q "$MCNAME"; then
    echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Server has already started! Use screen -r $MCNAME to open it"
    exit 1
else
echo -e "\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m Starting server..."
fi

# Path generating
LPATH=/$OPTBASE/$SERVERBASE

# Bedrock updater

# Auto updater datas

# Startup in software updater
