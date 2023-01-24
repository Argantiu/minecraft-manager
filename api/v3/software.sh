#!/bin/bash

MCVERS=$(yq eval '.version' ./../../mcsys.yml && cut -d "." -f2)
if [[ $MCVERS == "19" ]] || [[ $MCVERS == "18" ]]; then
apt install zulu17-jdk
else apt install zulu8-jdk
fi

