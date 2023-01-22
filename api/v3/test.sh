#!/bin/bash
MCPREFIX=$'\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m'
#echo -e " $(jq -r .mcstart.online messages.json)"
jq -nc --arg MCPREFIX "$MCPREFIX" '{"a":"b","c":$MCPREFIX}' | jq -r .c
