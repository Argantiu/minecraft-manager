#!/bin/bash
# Minecraft Server auto stop script - Do not configure this scipt!!
# Version 3.0.0.0-#0 made by Argantiu GmBh 06/21/2022 UTC/GMT +1 https://crazycloudcraft.de
MCNAME=
LPATH=
MPREFIX=
MTRANZLATION=
# Check if offline
if ! screen -list | grep -q "$MCNAME"; then
    echo -e "$MPREFIX $MTRANZLATION"
    # Start server
    /bin/bash $LPATH/start.sh
    exit 0
fi
# Stop server
/bin/bash $LPATH/stop.sh
# Start server
/bin/bash $LPATH/start.sh
