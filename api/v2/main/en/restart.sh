#!/bin/bash
# Minecraft Server auto script - Do not configure this scipt!!
# Version 3.0.0.0-#0 made by Argantiu GmBh 08/08/2022 UTC/GMT +1 https://crazycloudcraft.de
MCNAME=
MTPATH=
MPREFIX=
MTRANZLATION=
# Check if offline
if ! screen -list | grep -q "$MCNAME"; then
    echo -e "$MPREFIX $MTRANZLATION"
    # Start server
    /bin/bash $LPATH/mcsys/start.sh
    exit 0
fi
# Stop server
/bin/bash $MTPATH/mcsys/stop.sh
# Start server
/bin/bash $MTPATH/mcsys/start.sh
