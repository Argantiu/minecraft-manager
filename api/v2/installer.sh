#!/bin/bash
# Minecraft Server installer for an Easy Setup
# Made By CrazyCloudCraft
RPREFIX="\033[1;30m[\033[0;31mArgatiu\033[1;30m]\033[0;37m"
PREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
# Which language do you speak. 1 English . 2 German 3 French ...
echo -e "\033[1;32m_______"
echo -e "$PREFIX Welcome to Argantiu's server management tool"
echo -e "$PREFIX You can leave with STRG+C"
echo -e "$PREFIX _______"
echo -e "$PREFIX At first, please select your language:"
echo -e "$PREFIX 1 = English (English)"
echo -e "$PREFIX 2 = Deutsch (German)"
{
echo -n -e "$PREFIX Please type a number and hit enter:";
echo -n -e " "
read LANG;
if [[ $LANG == "1" ]]; then
 echo -e "$PREFIX Everything will be in english"
 echo -e "$PREFIX Were should be or is your server dictionary?"
 echo -e "$PREFIX e.g. /opt/Paper or /home/myserver/server"
 echo -e "$PREFIX Your server dictionary:";
fi
 {
 echo -n -e " "
 read DCI;
 }
 DICTY=$(grep $DCI | rev | cut -b "/" | rev)
if [[ $LANG == "1" ]]; then echo -e "$PREFIX Okey, i will preparing now the configuration. Please wait..."
fi
if [[ $LANG == "2" ]]; then echo -e ""
fi
mkdir -p $DICTY/mcsys/configs
mkdir -p $DICTY/mcsys/configs
#File locations:
#x will installed though other progress
#... /MainServer/manage.tool
#... /MainServer/mcsys/start.sh
#... /MainServer/mcsys/stop.sh
#... /MainServer/mcsys/restart.sh
#... /MainServer/mcsys/configs/mcsys.config
#... /MainServer/mcsys/updater/*
#x ... /MainServer/mcsys/backsave/jar/*
#x ... /MainServer/mcsys/backsave/geyser/*
#x ... /MainServer/mcsys/backsave/floodgate/*
#x ... /MainServer/mcsys/software/*


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
rm -- "$0" # Delete this file
