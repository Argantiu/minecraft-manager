#!/bin/bash
# Minecraft Server installer
MCPREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
ARGANTIUAPI=https://raw.githubusercontent.com/Argantiu/minecraft-manager/dev-v3/api/v3
#AGDEBUG=> /dev/null 2>&1
# Ask for language: Which language do you speak.
echo -e "\033[1;32m------------------------------------------"
echo -e "$MCPREFIX Welcome to Argantiu's server management tool"
echo -e "$MCPREFIX You can leave with STRG+C"
echo -e "$MCPREFIX -----------------------------------"
echo -e "$MCPREFIX First, please select your language:"
echo -e "$MCPREFIX 1 = English (English)"
echo -e "$MCPREFIX 2 = Deutsch (German)"
{ echo -n -e "$MCPREFIX Please type a number and hit enter:"; echo -n -e " "; read -r LANG; }
case $LANG in
1) echo -e "$MCPREFIX Where is your server directory located?"
 echo -e "$MCPREFIX e.g. /opt/paper or /home/myserver/server"
 echo -e "$MCPREFIX Your server directory:" ;;
2) echo -e "$MCPREFIX Wo ist oder soll dein Serverordner sich befinnden?"
 echo -e "$MCPREFIX z.b. /opt/paper oder /home/meinserver/server"
 echo -e "$MCPREFIX Und wo ist oder soll der Ordner sein:" ;;
*) echo "Please select a language! " && exit 1 ;;
esac
{ echo -n -e " "; read -r DCI; }
DICTY=$(echo "$DCI" | sed 's/\/$//')
case $LANG in
1) echo -e "$MCPREFIX Wich Software do you want to use?"
 echo -e "$MCPREFIX You can write [ paper, purpur, spigot, bukkit, mohist, bungeecord, velocity, waterfall ] here." ;;
2) echo -e "$MCPREFIX Welche Software willst du verwenden?"
 echo -e "$MCPREFIX Du kannst hier [ paper, purpur, spigot, bukkit, mohist, bungeecord, velocity, waterfall ] hinschreiben." ;;
esac
{ echo -n -e " "
read -r ASOFT; }
MCWARE=$(echo "$ASOFT" | tr '[:upper:]' '[:lower:]' | sed 's/mc//')
mkdir -p "$DICTY"/libraries/mcsys
if ! command -v wget; then apt-get install wget -y; fi
cd "$DICTY" || exit 1
wget -q $ARGANTIUAPI/main.sh
chmod +x ./main.sh
case $LANG in
1) echo -e "$MCPREFIX Great! System is generating the configuration now. Please wait..."
  wget -q $ARGANTIUAPI/resources/de/mcsys.yml
  cd "$DICTY"/libraries/mcsys || exit 1
  wget -q $ARGANTIUAPI/resources/en/messages.json ;;
2) echo -e "$MCPREFIX Okay! Die Konfiguration wird vorbereitet. Bitte warten..."
  wget -q $ARGANTIUAPI/resources/de/mcsys.yml
  cd "$DICTY"/libraries/mcsys || exit 1
  wget -q $ARGANTIUAPI/resources/de/messages.json ;;
esac
wget -q $ARGANTIUAPI/software.sh
chmod +x ./software.sh
apt-get -q update -y 
apt-get -q upgrade -y
apt install gnupg ca-certificates curl -y 
curl -s https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg 
echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | tee /etc/apt/sources.list.d/zulu.list
if ! command -v joe ; then apt-get install joe -y ; fi
if ! command -v screen ; then apt-get install screen -y ; fi
if ! command -v sudo ; then apt-get install sudo -y ; fi
if ! command -v zip ; then apt-get install zip -y ; fi
if ! command -v xargs ; then apt-get install findutils -y ; fi
if ! command -v diff ; then apt-get install diffutils -y ; fi
if ! command -v rpl ; then apt-get install rpl -y ; fi
if ! command -v yq ; then wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq; fi
sed -i "s|directory:.*|directory: $DICTY|g" "$DICTY"/mcsys.yml 
sed -i "s|software:.*|software: $MCWARE|g" "$DICTY"/mcsys.yml 
case $LANG in
1) echo -e "$MCPREFIX Setup finished! \nOpen configuration..." ;;
2) echo -e "$MCPREFIX Fertig mit dem Aufsetzten! \nHier kommt die Konfiguration..." ;;
esac
cd "$DICTY" || exit 1
joe ./mcsys.yml
wget -q https://github.com/Argantiu/.github/releases/download/v3.5.0.0/mcstats.yml && rm mcstats.yml >/dev/null 2>&1
