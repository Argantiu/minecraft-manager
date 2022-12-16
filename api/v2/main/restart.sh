#!/bin/bash
# Automatic minecraft server script - Edit at your own risks!!
# Version 3.0.0.0-#0 created by CrazyCloudCraft https://crazycloudcraft.de
MLANG=./configs/messages.lang
CONYAM=./configs/mcsys.yml
MTPATH=$(cat < "$CONYAM" | grep "server-directory:" | cut -d ':' -f2 | tr -d " ")
MPREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
MCNAME=$(cat < "$CONYAM" | grep "systemname:" | cut -d ':' -f2)
SHRESTART=$(cat < "$MLANG" | grep "restartsh.server.offline:" | cut -d ':' -d '"' -f2 | sed "s/%server_name%/$MCNAME/g" | sed "s/%prefix%/$MPREFIX/g")
# Check, if server is offline. And then start the server.
if ! screen -list | grep -q "$MCNAME"; then echo -e "$SHRESTART" && /bin/bash "$MTPATH"/mcsys/start.sh && exit 0
else
# Stop and then start the server.
/bin/bash "$MTPATH"/mcsys/stop.sh
/bin/bash "$MTPATH"/mcsys/start.sh
fi
