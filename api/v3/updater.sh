#!/bin/bash
# V3.5.0.0
CVERSION=1
ARGANAPI=https://raw.githubusercontent.com/Argantiu/minecraft-manager/dev-v3/api/v3

find / -name "mcagon" -exec rm {} \;

#View for language in config
PROXYRE=$(yq eval '.proxy' ../../mcsys.yml)
SYSMANG=$(yq eval '.conf_version' ../../mcsys.yml | cut -d "-" tr1)
CONFVER=$(yq eval '.conf_version' ../../mcsys.yml | cut -d "-" tr2)
DIREC=$(yq eval '.directory' ../../mcsys.yml)
cd "$DIREC" || exit 1
if [[ $SYSMANG == "de" ]]; then
wget -q $ARGANAPI/resources/de/mcsys.yml -O mcsys.yml.new
else
wget -q $ARGANAPI/resources/en/mcsys.yml -O mcsys.yml.new; fi
if ! [[ $CONFVER == $CVERSION ]]; then
sed -i "s|name:.*|name: $(yq eval '.name' mcsys.yml)|g" mcsys.yml.new
sed -i "s|directory:.*|directory: $(yq eval '.directory' mcsys.yml)|g" mcsys.yml.new
sed -i "s|version:.*|version: $(yq eval '.version' mcsys.yml)|g" mcsys.yml.new
sed -i "s|software:.*|software: $(yq eval '.software' mcsys.yml)|g" mcsys.yml.new
sed -i "s|bedrock:.*|bedrock: $(yq eval '.bedrock' mcsys.yml)|g" mcsys.yml.new
sed -i "s|ram:.*|ram: $(yq eval '.ram' mcsys.yml)|g" mcsys.yml.new
sed -i "s|proxy:.*|proxy: $(yq eval '.proxy' mcsys.yml)|g" mcsys.yml.new
sed -i "s|counter:.*|counter: $(yq eval '.counter' mcsys.yml)|g" mcsys.yml.new
sed -i "s|backup:.*|backup: $(yq eval '.backup' mcsys.yml)|g" mcsys.yml.new
else rm mcsys.yml.new && echo "No update needed" && exit 0
rm mcsys.yml
mv mcsys.yml.new mcsys.yml

wget -q $ARGANAPI/main.sh -O main.sh.new
rm main.sh && mv main.sh.new main.sh

cd "$DIREC"/libraries/mcsys || exit 1
wget -q $ARGANAPI/software.sh -O software.sh.new
rm software.sh && mv software.sh.new software.sh

#if ! [[ $PROXYRE == "true" ]]; then
#wget -q $ARGANAPI/bedrock.sh -O bedrock.sh.new
#rm bedrock.sh && mv bedrock.sh.new bedrock.sh
#fi
# else update pr bedrock

apt-get update -y &> /dev/null 2>&1
apt-get upgrade -y &> /dev/null 2>&1

apt install gnupg ca-certificates curl -y > /dev/null $1>$2
curl -s https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg > /dev/null $1>$2
echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | tee /etc/apt/sources.list.d/zulu.list > /dev/null $1>$2

if ! command -v joe $AGDEBUG; then apt-get install joe -y $AGDEBUG; fi
if ! command -v screen $AGDEBUG; then apt-get install screen -y $AGDEBUG; fi
if ! command -v sudo $AGDEBUG; then apt-get install sudo -y $AGDEBUG; fi
if ! command -v zip $AGDEBUG; then apt-get install zip -y $AGDEBUG; fi
if ! command -v xargs $AGDEBUG; then apt-get install findutils -y $AGDEBUG; fi
if ! command -v diff $AGDEBUG; then apt-get install diffutils -y $AGDEBUG; fi
if ! command -v rpl $AGDEBUG; then apt-get install rpl -y $AGDEBUG; fi
if ! command -v yq $AGDEBUG; then wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq $AGDEBUG; fi
