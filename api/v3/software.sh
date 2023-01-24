#!/bin/bash

MCVERSION=$(yq eval '.version' mcsys.yml && cut -d "." -f2)
if [[ $MCVERSION == "19" ]] || [[ $MCVERSION == "18" ]]; then
apt install zulu17-jdk
else apt install zulu8-jdk
fi

