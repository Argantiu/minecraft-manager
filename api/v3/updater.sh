#!/bin/bash
# V3.5.0.0
CVERSION=1
ARGANAPI=https://raw.githubusercontent.com/Argantiu/minecraft-manager/dev-v3/api/v3

find / -name "mcagon" -exec rm {} \;

#View for language in config
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


# Update Software.sh

# Check for if not proxy
# Update Bedrock.sh
# else update Bedrock.pr.sh

# Update dependencys
# With yq
