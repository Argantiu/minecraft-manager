#!/bin/bash
# Here are the System variables don't edit them here. You can use the mcsys.yml ;)
# Automatic minecraft server script - Edit at your own risks!!
# Version 3.0.0.0-#0 created by CrazyCloudCraft https://crazycloudcraft.de
MCONF=./configs/mcsys.yml
MLANG=./configs/messages.lang
ASOFTWARE=$(cat < $MCONF | grep software: | cut -d ':' -d ' ' -f2)
MTPATH=$(cat < $MCONF | grep server.directory: | cut -d ':' -d ' ' -f2)
BEUPDATE=$(cat < $MCONF | grep BEMCUPDATE= | cut -d ':' -d ' ' -f2)
BACKUP=$(cat < $MCONF | grep BACKUP= | cut -d ':' -d ' ' -f2)
BETTERBACKUP=$(cat < $MCONF | grep BETTERBACKUP= | cut -d ':' -d ' ' -f2)
MPREFIX=$(cat < $MCONF | grep MPREFIX= | cut -d ':' -d ' ' -f2)
MCNAME=$(cat < $MCONF | grep MCNAME= | cut -d ':' -d ' ' -f2)
OPTBASE=
SERVERBASE=
# Tranzlations
TR1=$(cat < $MLANG | grep startsh.already.online: | cut -d ':' -d ' ' -f2)
