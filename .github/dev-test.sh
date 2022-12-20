#!/bin/bash
# Minecraft Server installer for an Easy Setup
# Made By CrazyCloudCraft
IFFORK=Argantiu/minecraft-manager
PREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
LANG=2
case $LANG in
1)
 echo -e "$PREFIX Where is your server directory located?"
 echo -e "$PREFIX e.g. /opt/paper or /home/myserver/server"
 echo -e "$PREFIX Your server directory:"
;;
2)
 echo -e "$PREFIX Wo ist oder soll dein Serverordner sich befinnden?"
 echo -e "$PREFIX z.b. /opt/paper oder /home/meinserver/server"
 echo -e "$PREFIX Und wo ist oder soll der Ordner sein:"
;;
*)
 echo "Please select a language! " && exit 1
;;
esac
{
echo -n -e " "
read -r DCI;
}
DICTY=$(echo "$DCI" | sed 's/\/$//')
mkdir -p "$DICTY"/mcsys/configs
mkdir -p "$DICTY"/unused
cd "$DICTY"/mcsys/configs || exit 1
if ! command -v wget &> /dev/null; then apt-get install wget -y >/dev/null 2>&1
fi
case $LANG in
1)
  echo -e "$PREFIX Great! System is generating the configuration now. Please wait..."
  wget -q https://github.com/$IFFORK/raw/main/api/v2/assets/mcsys_en.yml -O mcsys.yml
  wget -q https://raw.githubusercontent.com/$IFFORK/main/api/v2/messages/messages_en.lang -O messages.lang
;;
2)
  echo -e "$PREFIX Okay! Die Konfiguration wird vorbereitet. Bitte warten..."
  wget -q https://github.com/$IFFORK/raw/main/api/v2/assets/mcsys_de.yml -O mcsys.yml
  wget -q https://raw.githubusercontent.com/$IFFORK/main/api/v2/messages/messages_de.lang -O messages.lang
;;
esac
#wget -q https://raw.githubusercontent.com/$IFFORK/main/api/v2/assets/variables.sh
#chmod +x variables.sh
cd "$DICTY"/mcsys || exit 1
wget -q https://raw.githubusercontent.com/$IFFORK/main/api/v2/main/restart.sh
wget -q https://raw.githubusercontent.com/$IFFORK/main/api/v2/main/start.sh
wget -q https://raw.githubusercontent.com/$IFFORK/main/api/v2/main/stop.sh
chmod +x ./*.sh
cd "$DICTY" || exit 1
wget -q https://raw.githubusercontent.com/$IFFORK/main/api/v2/assets/manage.tool
chmod +x manage.tool
case $LANG in
1) echo -e "$PREFIX Setup finished! \nOpen configuration..." ;;
2) echo -e "$PREFIX Fertig mit dem Aufsetzten! \nHier kommt die Konfiguration..." ;;
esac
# Install dependencys
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
sed -i "s:opt/.*:$DICTY:g" "$DICTY"/mcsys/configs/mcsys.yml >/dev/null 2>&1
#sed -i "0,:source variables.sh:s:$DICTY/mcsys/configs/variables.sh" "$DICTY"/mcsys/start.sh "$DICTY"/mcsys/stop.sh "$DICTY"/mcsys/restart.sh >/dev/null 2>&1
#sed -i "0,:source variables.sh:s:$DICTY/mcsys/configs/variables.sh" "$DICTY"/manage.tool >/dev/null 2>&1
joe "$DICTY"/mcsys/configs/mcsys.yml
