#!/bin/bash
# Updater for the manage system. Created by CrazyCloudCraft.
echo -e "Update >> 3.0.0"
echo -e "- Fixing everything"
echo -e "- It should run now ;)"
echo -e "Downloading new assets."
echo -e "Update Secured by Argantiu Germany"
apt-get upgrade -y &> /dev/null
apt-get update -y &> /dev/null
if ! command -v joe &> /dev/null; then apt-get install joe -y &> /dev/null
fi
if ! command -v screen &> /dev/null; then apt-get install screen -y &> /dev/null
fi
if ! command -v sudo &> /dev/null; then apt-get install sudo -y &> /dev/null
fi
if ! command -v zip &> /dev/null; then apt-get install zip -y &> /dev/null
fi
if ! command -v xargs &> /dev/null; then apt-get install findutils -y &> /dev/null
fi
if ! command -v diff &> /dev/null; then apt-get install diffutils -y &> /dev/null
fi
if ! command -v rpl &> /dev/null; then apt-get install rpl -y &> /dev/null
fi
cd ./../configs || exit 1
rm variables.sh
wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/assets/variables.sh
chmod +x variables.sh
cd ./../ || exit 1
wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/main/restart.sh
wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/main/start.sh
wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/main/stop.sh
chmod +x ./*.sh
cd ./../../ || exit 1
wget -q https://raw.githubusercontent.com/$IFCREATEDFORK/main/api/v2/assets/manage.tool
chmod +x manage.tool
sed -i "0,:source variables.sh:s:$DICTY/mcsys/configs/variables.sh" $DICTY/mcsys/start.sh $DICTY/mcsys/stop.sh $DICTY/mcsys/restart.sh >/dev/null 2>&1
sed -i "0,:source variables.sh:s:$DICTY/mcsys/configs/variables.sh" $DICTY/manage.tool >/dev/null 2>&1
exit 0
