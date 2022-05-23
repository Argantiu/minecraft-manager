#!/bin/bash
# Minecraft Server installer for Easy Setup
# Made By CrazyCloudCraft - Argantiu GmbH
RPREFIX="\033[1;30m[\033[0;31mArgatiu\033[1;30m]\033[0;37m"
PREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
# Which language do you speak. 1 English . 2 German 3 French ...
echo -e "\033[1;32m_______"
echo -e "$PREFIX Welcome to Argantiu's server management tool"
echo -e "$PREFIX You can leave with STRG + C"
echo -e "$PREFIX _______"
echo -e "$PREFIX At first, please select your language:"
echo -e "$PREFIX 1 = English (English)"
echo -e "$PREFIX 2 = Deutsch (German)"
{
echo -n -e "$PREFIX Please type a number and hit space:  ";
read LANG;
}
if [ $LANG = "1" ]; then
 echo -e "$PREFIX Everything will be in english"
 echo -e "$PREFIX Were should be or is your server dictionary?"
 echo -e "$PREFIX e.g. /opt/Paper or /home/myserver/server"
 echo -e "$PREFIX Don't write this: /opt/Paper\033[0;31m/ <- You don't need / at the end\033[0;37m"
 {
 echo -n -e "$PREFIX Your server dictionary:  ";
 read DICTI;
 }
 echo -e "$PREFIX Okey, i will preparing now the configuration. Please wait..."
 sleep 1
 mkdir -p $DICTI/mcsys/config
 cd $DICTI/mcsys/config || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/lang/en/mcsys.txt -O mcsys.txt
 echo -e "$PREFIX Setup finished!"
 echo -e "$PREFIX Open Configuration..."
 sleep 1
 joe $DICTI/mcsys/config/mcsys.txt
#else
 #echo -e "$RPREFIX Something went wrong! Please report on github with code error #l0001"
fi
if [ $LANG = "2" ]; then
 echo -e "$PREFIX Vieles wird auf Deutsch sein, jedoch können"
 echo -e "$PREFIX einige Ausgaben nicht übersetzt werden."
 echo -e "$PREFIX _____"
 echo -e "$PREFIX Wo ist oder soll dein Serverordner sich befinnden?"
 echo -e "$PREFIX z.b. /opt/Paper oder /home/meinserver/server"
 echo -e "$PREFIX Schreibe es nicht so: /opt/Paper\033[0;31m/ <- "
 echo -e "$PREFIX \033[0;31mDu brauchst kein / am Ende des Ordnerweges \033[0;37m"
 {
 echo -n -e "$PREFIX Und wo ist oder soll der Ordner sein:  ";
 read DICTI;
 }
 echo -e "$PREFIX Okey, die Konfiguration wird vorbereitet. Bitte warten..."
 sleep 1
 mkdir -p $DICTI/mcsys/config
 cd $DICTI/mcsys/config || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/lang/de/mcsys.txt -O mcsys.txt
 echo -e "$PREFIX Fertig mit dem Aufsetzten!"
 echo -e "$PREFIX Hier kommt die Konfiguration..."
 sleep 1
 joe $DICTI/mcsys/config/mcsys.txt
#else
 #echo -e "$RPREFIX Something went wrong! Please report on github with code error #l0001"
fi
#DICTII=./mcsys/config/mcsys.conf
#if test -f "$DICTII"; then
 mkdir -p $DICTI/unused
 cd $DICTI/mcsys/config || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/values.txt -O values.txt
 sed -i "s:empty:$DICTI:g" ./values.txt $>/dev/null 2>&1
 cd $DICTI/mcsys/ || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/restart.sh -O restart.sh
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/start.sh -O start.sh
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/stop.sh -O stop.sh
 chmod +x ./*.sh
 cd $DICTI || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/config -O config
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/update -O update
 chmod +x config
 chmod +x update
 if ! command -v joe &> /dev/null
  then
     apt-get install joe -y
     echo "joe installed"
 fi
 if ! command -v screen &> /dev/null
 then
     apt-get install screen -y
     echo "screen installed"
 fi
 if ! command -v sudo &> /dev/null
 then
     apt-get install sudo -y
     echo "sudo installed"
 fi
 if ! command -v zip &> /dev/null
 then
     apt-get install zip -y
     echo "zip installed"
 fi
 if ! command -v wget &> /dev/null
 then
     apt-get install wget -y
     echo "wget installed"
 fi
 if ! command -v xargs &> /dev/null
 then
     apt-get install findutils -y
     echo "findutils installed"
 fi
 if ! command -v diff &> /dev/null
 then
     apt-get install diffutils -y
     echo "diffutils installed"
 fi
 if ! command -v rpl &> /dev/null
 then
     apt-get install rpl -y
     echo "rpl installed"
 fi
 #rm server-installer.sh
# End of file. Please sh server-installer.sh this file.
