#!/bin/bash
# Made by CrazyCloudCraft
# Update v2.5.2.0 on 05/15/2022 made by Argantiu

# Do not configure this scipts!
# shellcheck source=lang/en/mcsys.conf
. /config/mcsys.txt

# Build path
LPATH=/$OPTBASE/$SERVERBASE

# Check if offline
if ! screen -list | grep -q "$MCNAME"; then
    echo -e "$MPREFIX $MTRANZLATION"
    # Start server
    /bin/bash $LPATH/mcsys/start.sh
    exit 0
fi

# Stop server
/bin/bash $LPATH/mcsys/stop.sh

# Start server
/bin/bash $LPATH/mcsys/start.sh
