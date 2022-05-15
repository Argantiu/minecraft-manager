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
echo -n -e "$PREFIX Your server dictionary:"
read;
echo -e "$PREFIX Okey, i will install now everything. Please wait..."
sleep 5
mkdir -p {REPLY}
mkdir -p {REPLY}/mcsys
mkdir -p {REPLY}/mcsys/config
mkdir -p {REPLY}/mcsys/commands
mkdir -p {REPLY}/mcsys/updater
mkdir -p {REPLY}/unused

if [ ${REPLY} = "2" ]; then
echo -e "$PREFIX Vieles wird auf Deutsch sein, jedoch können einige Ausgaben nicht übersetzt werden."
echo -e "$PREFIX"
}
# Were is or should be your minecraft server

# setup in english or german
