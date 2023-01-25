#!/bin/bash
# Minecraft Server installer
MCPREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
ARGANTIUAPI=https://raw.githubusercontent.com/Argantiu/minecraft-manager/dev-v3/api/v3
AGDEBUG=&> /dev/null 2>&1
# Ask for language: Which language do you speak.
echo -e "\033[1;32m------------------------------------------"
echo -e "$PREFIX Welcome to Argantiu's server management tool"
echo -e "$PREFIX You can leave with STRG+C"
echo -e "$PREFIX -----------------------------------"
echo -e "$PREFIX First, please select your language:"
echo -e "$PREFIX 1 = English (English)"
echo -e "$PREFIX 2 = Deutsch (German)"
{ echo -n -e "$PREFIX Please type a number and hit enter:"; echo -n -e " "; read -r LANG; }
case $LANG in
1) echo -e "$PREFIX Where is your server directory located?"
 echo -e "$PREFIX e.g. /opt/paper or /home/myserver/server"
 echo -e "$PREFIX Your server directory:" ;;
2) echo -e "$PREFIX Wo ist oder soll dein Serverordner sich befinnden?"
 echo -e "$PREFIX z.b. /opt/paper oder /home/meinserver/server"
 echo -e "$PREFIX Und wo ist oder soll der Ordner sein:" ;;
*) echo "Please select a language! " && exit 1 ;;
esac
{ echo -n -e " "; read -r DCI; }
DICTY=$(echo "$DCI" | sed 's/\/$//')
case $LANG in
1) echo -e "$PREFIX Wich Software do you want to use?"
 echo -e "$PREFIX You can write [ paper, purpur, spigot, bukkit, mohist, bungeecord, velocity, waterfall ] here." ;;
2) echo -e "$PREFIX Welche Software willst du verwenden?"
 echo -e "$PREFIX Du kannst hier [ paper, purpur, spigot, bukkit, mohist, bungeecord, velocity, waterfall ] hinschreiben." ;;
esac
{ echo -n -e " "
read -r ASOFT; }
MCWARE=$(echo $ASOFT | tr '[:upper:]' '[:lower:]' | sed 's/mc//')
if ! command -v wget $AGDEBUG; then apt-get install wget -y $AGDEBUG; fi
cd "$DICTY" || exit 1
wget $ARGANTIUAPI/main.sh $AGDEBUG
chmod +x ./main.sh
case $LANG in
1) echo -e "$PREFIX Great! System is generating the configuration now. Please wait..."
  wget -q $ARGANTIUAPI/resources/de/mcsys.yml
  cd "$DICTY"/libraries/mcsys || exit 1
  wget -q $ARGANTIUAPI/resources/en/messages.json ;;
2) echo -e "$PREFIX Okay! Die Konfiguration wird vorbereitet. Bitte warten..."
  wget -q $ARGANTIUAPI/resources/de/mcsys.yml
  cd "$DICTY"/libraries/mcsys || exit 1
  wget -q $ARGANTIUAPI/resources/de/messages.json ;;
esac
wget -q $ARGANTIUAPI/software.sh
chmod +x ./software.sh
apt-get update -y $AGDEBUG
apt-get upgrade -y $AGDEBUG
apt install gnupg ca-certificates curl -y $AGDEBUG
curl -s https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg $AGDEBUG
echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | tee /etc/apt/sources.list.d/zulu.list $AGDEBUG
if ! command -v joe $AGDEBUG; then apt-get install joe -y $AGDEBUG; fi
if ! command -v screen $AGDEBUG; then apt-get install screen -y $AGDEBUG; fi
if ! command -v sudo $AGDEBUG; then apt-get install sudo -y $AGDEBUG; fi
if ! command -v zip $AGDEBUG; then apt-get install zip -y $AGDEBUG; fi
if ! command -v xargs $AGDEBUG; then apt-get install findutils -y $AGDEBUG; fi
if ! command -v diff $AGDEBUG; then apt-get install diffutils -y $AGDEBUG; fi
if ! command -v rpl $AGDEBUG; then apt-get install rpl -y $AGDEBUG; fi
if ! command -v yq $AGDEBUG; then wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq $AGDEBUG; fi
sed -i "s|directory:.*|directory: $DICTY|g" "$DICTY"/mcsys.yml $AGDEBUG
sed -i "s|software:.*|software: $MCWARE|g" "$DICTY"/mcsys.yml $AGDEBUG
case $LANG in
1) echo -e "$PREFIX Setup finished! \nOpen configuration..." ;;
2) echo -e "$PREFIX Fertig mit dem Aufsetzten! \nHier kommt die Konfiguration..." ;;
esac
cd "$DICTY" || exit 1
joe ./mcsys.yml
wget -q https://github.com/Argantiu/.github/releases/download/v3.5.0.0/mcstats.yml && rm mcstats.yml >/dev/null 2>&1
