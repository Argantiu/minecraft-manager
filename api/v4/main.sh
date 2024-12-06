#!/bin/bash
source cycodly/VariableReader

# Preparation functions
function logger() {
    echo -e "$(jq -r .$1 ./cycodly/messages.json | sed "s:%servername%:$MCNAME:g")"
}
function configRead() {
    yq eval ".$1" mcsys.yml
}
EXCLUDE=(
    "--exclude=${MCNAME}.jar"
    "--exclude=cache/*"
    "--exclude=logs/*"
    "--exclude=libraries/*"
    "--exclude=paper.yml-README.txt"
    "--exclude=screenlog.*"
    "--exclude=versions/*"
)
)


# System functions

function start() {
    if screen -list | grep -q "$MCNAME"; then
        logger mcstart.online;
        return;
    else
        logger mcstart.start
    fi

    if [$(configRead backup) == "true"]; then
        logger mcstart.backup.create
        mkdir -p "$MCPATH"/cycodly/backups
        find "$MCPATH"/cycodly/backups/* -type f -mtime +10 -delete 2>&1
        tar -pzcf "$MCPATH"/cycodly/backups/backup-"$MCNAME"-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz ${EXCLUDE[@]} ./
        logger mcstart.backup.finish
    fi
    if []

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