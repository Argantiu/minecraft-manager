#!/bin/bash
# Minecraft Server installer
MCPREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
ARGANTIUAPI=https://raw.githubusercontent.com/Argantiu/minecraft-manager/dev-v3/api/v3/
# Ask for language Which language do you speak.
echo -e "\033[1;32m------------------------------------------"
echo -e "$PREFIX Welcome to Argantiu's server management tool"
echo -e "$PREFIX You can leave with STRG+C"
echo -e "$PREFIX -----------------------------------"
echo -e "$PREFIX First, please select your language:"
echo -e "$PREFIX 1 = English (English)"
echo -e "$PREFIX 2 = Deutsch (German)"
{
echo -n -e "$PREFIX Please type a number and hit enter:";
echo -n -e " "
read -r LANG;
}
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
case $LANG in
1)
 echo -e "$PREFIX Wich Software do you want to use?"
 echo -e "$PREFIX You can write [ paper, purpur, spigot, bukkit, mohist, bungeecord, velocity, waterfall ] here."
;;
2)
 echo -e "$PREFIX Welche Software willst du verwenden?"
 echo -e "$PREFIX Du kannst hier [ paper, purpur, spigot, bukkit, mohist, bungeecord, velocity, waterfall ] hinschreiben."
;;
esac
{
echo -n -e " "
read -r ASOFT;
}
MCSOFTWARE=$(echo $ASOFT | tr '[:upper:]' '[:lower:]' | sed 's/mc//')
# Ask for server location
# Ask for server Software
# Downloading language assets
# Downloading assets
# Update packetloader
# Update packets
# Download needed packets

apt install gnupg ca-certificates curl
curl -s https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg
echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | tee /etc/apt/sources.list.d/zulu.list
#apt install zulu17-jdk
wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq
