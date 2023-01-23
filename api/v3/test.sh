#!/bin/bash
# https://stackoverflow.com/questions/73494478/ansi-color-codes-with-jq
MCPREFIX=$'\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m'
#echo -e " $(jq -r .mcstart.online messages.json)"
jq -nc --arg MCPREFIX "$MCPREFIX" '.file.object | messages.json' | jq -r .object
