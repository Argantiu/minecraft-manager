#!/bin/bash
# V3.5.0.0

find / -name "mcagon" -exec rm {} \;

#View for language in config
SYSMANG=$(yq eval '.conf_version' ../../mcsys.yml | cut -d "-" tr1)
CONFVER=$(yq eval '.conf_version' ../../mcsys.yml | cut -d "-" tr2)
DIREC=$(yq eval '.directory' ../../mcsys.yml)
cd "$DIREC" || exit 1
if [[ $SYSMANG == "de" ]]; then
wget -q https://raw.githubusercontent.com/Argantiu/minecraft-manager/dev-v3/api/v3/resources/de/mcsys.yml -O mcsys.yml.new
 if ! [[ $CONFVER == "1" ]]; then
 cat < mcsys.yml | sed -i "s|directory:.*|directory: |g" mcsys.yml.new
 

# Check if mycsys.yml version has changed
# mv mcsys.yml to mcsys.yml.old
# Overtake settings
# Remove mcsys.yml.old

# Update main.sh
# Update Software.sh

# Check for if not proxy
# Update Bedrock.sh
# else update Bedrock.pr.sh

# Update dependencys
# With yq
