#!/bin/bash 
# Minecraft Server installer for Easy Setup
# Made By CrazyCloudCraft - Argantiu GmbH
PREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
#
echo -e "$PREFIX Vieles wird auf Deutsch sein, jedoch können"
echo -e "$PREFIX einige Ausgaben nicht übersetzt werden."
echo -e "$PREFIX _____"
echo -e "$PREFIX Wo ist oder soll dein Serverordner sich befinnden?"
echo -e "$PREFIX z.b. /opt/Paper oder /home/meinserver/server"
echo -e "$PREFIX Schreibe es nicht so: /opt/Paper\033[0;31m/ <- "
echo -e "$PREFIX \033[0;31mDu brauchst kein / am Ende des Ordnerweges \033[0;37m"
{
echo -n -e "$PREFIX Und wo ist oder soll der Ordner sein? -> "
read -r;

echo -e "$PREFIX Okey, ich werde alles Installieren. Bitte warten..."
sleep 5
mkdir -p ${REPLY}
mkdir -p ${REPLY}/mcsys
mkdir -p ${REPLY}/mcsys/config
mkdir -p ${REPLY}/unused
cd ${REPLY}/mcsys/config || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/lang/de/mcsys.conf -O mcsys.conf
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/values.conf -O values.conf
sed -i "s/empty/${REPLY}/" ./values.conf $>/dev/null 2>&1
}
cd ${REPLY}/mcsys/ || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/restart.sh -O restart.sh
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/start.sh -O start.sh
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/stop.sh -O stop.sh
chmod +x ./*.sh
cd ${REPLY} || exit 1
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/config -O config
wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/update -O update
chmod +x config
chmod +x update
echo -e "$PREFIX Fertig mit dem Aufsetzten!"
echo -e "$PREFIX Hier kommt die Konfiguration..."
sleep 3
joe ${REPLY}/mcsys/config/mcsys.conf
 #
if ! command -v joe &> /dev/null
then
    apt-get install joe -y
    echo "joe installed"
fi
#
if ! command -v screen &> /dev/null
then
    apt-get install screen -y
    echo "screen installed"
 fi
#
if ! command -v sudo &> /dev/null
then
    apt-get install sudo -y
    echo "sudo installed"
fi
#
if ! command -v zip &> /dev/null
then
    apt-get install zip -y
    echo "zip installed"
fi
#
if ! command -v wget &> /dev/null
then
    apt-get install wget -y
    echo "wget installed"
fi
#
if ! command -v xargs &> /dev/null
then
    apt-get install findutils -y
    echo "findutils installed"
fi
#
if ! command -v diff &> /dev/null
then
    apt-get install diffutils -y
    echo "diffutils installed"
fi
#
if ! command -v rpl &> /dev/null
then
    apt-get install rpl -y
    echo "rpl installed"
fi
