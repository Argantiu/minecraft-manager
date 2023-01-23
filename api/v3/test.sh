#!/bin/bash
# https://stackoverflow.com/questions/73494478/ansi-color-codes-with-jq
MCPREFIX=$'\033[1;30m[\033[1;32mArgantiu\033[1;30m]\033[0;37m'
#echo -e " $(jq -r .mcstart.online messages.json)"
jq -nc --arg MCPREFIX "$MCPREFIX" '.file.object | messages.json' | jq -r .object
jq -nc --arg MCPREFIX "$MCPREFIX" '.mcstart.online' messages.json | jq -r .online

#https://apihandyman.io/api-toolbox-jq-and-openapi-part-4-bonus-coloring-jqs-raw-output/
echo '{ "greeting": "Hello", "who":"World" }' | jq -r '"\u001b[31m" + .greeting + "\u001b[0m " + .who'
