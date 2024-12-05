#!/bin/bash
source cycodly/VariableReader

# Preparation functions
function logger() {
    echo -e "$(jq -r .$1 ./cycodly/messages.json | sed "s:%servername%:$MCNAME:g")"
}


# System functions

function start() {
    if screen -list | grep -q "$MCNAME"; then
        logger mcstart.online;
        return;
    fi
    logger mcstart.start
    
}

function stop() {
    
}

function restart() {
    
}

function remove() {
    
}

function help() {
    
}

case "$1" in
    1|'start') start;;
    2|'stop') stop;;
    3|'restart') restart;;
    4|'remove') remove;;
    *) help;;
esac