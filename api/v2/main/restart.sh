#!/bin/bash
# Automatic minecraft server script - Edit at your own risks!!
# Version 3.0.0.0-#0 created by CrazyCloudCraft https://crazycloudcraft.de
# shellcheck source=/dev/null
source /configs/variables.sh
# Check, if server is offline. And then start the server.
if ! screen -list | grep -q "$MCNAME"; then echo -e "$SHRESTART" && /bin/bash $LPATH/mcsys/start.sh && exit 0
else
# Stop and then start the server.
/bin/bash $MTPATH/mcsys/stop.sh
/bin/bash $MTPATH/mcsys/start.sh
fi
