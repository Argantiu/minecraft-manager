#!/bin/bash

if [[ $(yq eval '.version' mcsys.yml && cut -d "." -f2) == "19" ]] || [[ $(yq eval '.version' mcsys.yml && cut -d "." -f2) == "18" ]]; then
apt install zulu17-jdk
else apt install zulu8-jdk
fi

