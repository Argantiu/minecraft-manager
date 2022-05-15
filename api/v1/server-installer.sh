# Minecraft Server installer for Easy Setup
# Made By CrazyCloudCraft - Argantiu GmbH
PREFIX="\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m"
# Which language do you speak. 1 English . 2 German 3 French ...
echo -e "\033[1;32m_______"
echo -e "$PREFIX Welcome to Argantiu's server management tool"
echo -e "$PREFIX You can leave with STRG + C"
echo -e "$PREFIX _______"
echo -e "$PREFIX At first please select your language:"
echo -e "$PREFIX 1 = English"
echo -e "$PREFIX 2 = German"
{
echo -n -e "$PREFIX Please type a number and hit space:";
read;
if [ ${REPLY} = "1" ]; then
 echo -e "$PREFIX Everything will be in english"
 echo -e "$PREFIX Were should be or is your server dictionary?"
 echo -e "$PREFIX e.g. /opt/Paper or /home/myserver/server"
 echo -e "$PREFIX Don't write this: /opt/Paper\033[0;31m/ <- You don't need / at the end"
 {
 echo -n -e "$PREFIX Your server dictionary:"
 read;
 echo -e "$PREFIX Okey, i will install now everything. Please wait..."
 sleep 5
 mkdir -p ${REPLY}
 mkdir -p ${REPLY}/mcsys
 mkdir -p ${REPLY}/mcsys/config
 mkdir -p ${REPLY}/mcsys/commands
 mkdir -p ${REPLY}/unused
 cd ${REPLY}/mcsys/config || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/lang/en/mcsys.conf -O mcsys.conf
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/values.conf -O values.conf
 sed -i "s/DSERVERFOLDER=/DSERVERFOLDER=${REPLY}/g" ${REPLY}/mcsys/config/values.conf $>/dev/null 2>&1
 cd ${REPLY}/mcsys/ || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/restart.sh -O restart.sh
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/start.sh -O start.sh
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/stop.sh -O stop.sh
 chmod +x *.sh
 cd ${REPLY} || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/config -O config
 chmod +x config
 echo -e "$PREFIX Setup finished!"
 echo -e "$PREFIX Open Configuration... "
 sleep 3
 joe ${REPLY}/mcsys/config/mcsys.conf
 }
fi
if [ ${REPLY} = "2" ]; then
 echo -e "$PREFIX Vieles wird auf Deutsch sein, jedoch können einige Ausgaben nicht übersetzt werden."
 echo -e "$PREFIX Wo ist oder soll dein Serverordner sich befinnden?"
 echo -e "$PREFIX z.b. /opt/Paper oder /home/meinserver/server"
 echo -e "$PREFIX Schreibe es nicht so: /opt/Paper\033[0;31m/ <- Du brauchst kein / am Ende des Ordnerweges"
 {
 echo -n -e "$PREFIX Und wo ist oder soll der Ordner sein:"
 read;
 echo -e "$PREFIX Okey, ich werde alles Installieren. Bitte warten.."
 sleep 5
 mkdir -p ${REPLY}
 mkdir -p ${REPLY}/mcsys
 mkdir -p ${REPLY}/mcsys/config
 mkdir -p ${REPLY}/mcsys/commands
 mkdir -p ${REPLY}/unused
 cd ${REPLY}/mcsys/config || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/lang/de/mcsys.conf -O mcsys.conf
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/values.conf -O values.conf
 sed -i "s/DSERVERFOLDER=/DSERVERFOLDER=${REPLY}/g" ${REPLY}/mcsys/config/values.conf $>/dev/null 2>&1
 cd ${REPLY}/mcsys/ || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/restart.sh -O restart.sh
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/start.sh -O start.sh
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/stop.sh -O stop.sh
 chmod +x *.sh
 cd ${REPLY} || exit 1
 wget -q https://raw.githubusercontent.com/Argantiu/system-api/main/api/v1/config -O config
 chmod +x config
 echo -e "$PREFIX Fertig mit dem Aufsetzten!"
 echo -e "$PREFIX Hier kommt die Konfiguration..."
 sleep 3
 joe ${REPLY}/mcsys/config/mcsys.conf
 }
fi
}
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
# End of file. Please sh server-installer.sh this file.
