#!/bin/bash
# Automatic minecraft server script - Edit at your own risk!!
# Version 3.0.0.0-#0 created by Argantiu GmBh 2022-08-08 https://crazycloudcraft.de
MCNAME=
MTPATH=
MPREFIX=
# Checking, if the server is offline, to restart it.
if ! screen -list | grep -q "$MCNAME"; then
    echo -e "$MPREFIX The server isn't running, starting server..."
    # Starting server
    /bin/bash $LPATH/mcsys/start.sh
    exit 0
fi
# Stopping server
/bin/bash $MTPATH/mcsys/stop.sh
# Starting server
/bin/bash $MTPATH/mcsys/start.sh
