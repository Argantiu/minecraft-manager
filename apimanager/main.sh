#!/bin/bash
if [ -f "./cycodly/CycodlySystemManager.sh" ]; then
    source ./cycodly/CycodlySystemManager.sh
else
    setup
fi
# Preparation functions
EXCLUDE=(
    "--exclude=${MCNAME}.jar"
    "--exclude=cache/*"
    "--exclude=logs/*"
    "--exclude=libraries/*"
    "--exclude=paper.yml-README.txt"
    "--exclude=screenlog.*"
    "--exclude=versions/*"
    "--exclude=cycodly/*backup/*"
)

# System functions
function start() {
    local backupPath="$MCPATH"/cycodly/systembackup
    
    
    
    if screen -list | grep -q "$MCNAME"; then
        logMessage start.online;
        return;
    else
        logMessage start.start;
    fi
    
    if [[ $MCBACKUP == "true" ]]; then
        logMessage start.backup.create
        mkdir -p "$backupPath" && find "$backupPath"/* -maxdepth 1 -type f -mtime +10 -delete 2>&1
        tar -pzcf "$backupPath"/backup-"$MCNAME"-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz "${EXCLUDE[@]}" ./
        logMessage start.backup.finish;
    fi
    ### Proxy support for future versions
    #if [[ $MCSOFTWARE =~ (spigot|paper|purpur|banner|youer|mohist)$]]; then
    #    if [[ $MCPROXY =~ (waterfall|bungeecord)$ ]]; then
    #        sed -i '0,;online-mode=true;online-mode=false' "$MCPATH"/server.propeties >/dev/null 2>&1;
    #        sed -i '0,;bungeecord: false;bungeecord: true' "$MCPATH"/spigot.yml >/dev/null 2>&1;
    #    else
    #        sed -i '0,;online-mode=false;online-mode=true' "$MCPATH"/server.propeties >/dev/null 2>&1;
    #        sed -i '0,;bungeecord: true;bungeecord: false' "$MCPATH"/spigot.yml >/dev/null 2>&1;
    #    fi
    #    if [[ $MCPROXY =~ (velocity)$ ]]; then
    #        sed -i '0,;online-mode=true;online-mode=false' "$MCPATH"/server.propeties >/dev/null 2>&1;
    #    fi
    for n in {5..1}; do
        [ -f screenlog.$((n-1)) ] && mv screenlog.$((n-1)) screenlog."$n";
    done
    #if [[ $MCBEDROCK == "true" ]]; then
    #    execute bedrock;
    #fi
    /bin/bash "$MCPATH"/cycodly/CycodlySoftwareUpdater.sh;
    return;
}

function stop() {
    if ! screen -list | grep -q "$MCNAME"; then
        logMessage stop.offline;
        return;
    fi
    logMessage stop.stopservice;
    if ! [[ $MCSOFTWARE =~ ^(bungeecord|velocity|waterfall)$ ]] && [[ $MCCOUNTER == "true" ]]; then
        local ip=$(hostname -I | grep -o '^\S*') # the server ip. This can be 127.0.0.1
        local port=$(cat < "$MCPATH"/server.properties | grep server-port | grep -oE '[0-9]+') # get's server port
        # Get server information
        local response=$(echo -e "\xFE" | nc "$ip" "$port" | tr -d '\0')
        # Get current playercount
        if (response); then
            local playercount=$(echo "$response" | grep -oE '[0-9]+' | tail -n 2 | head -n 1)
            if ! [[ $playercount == "0" ]]; then
                for numb in {10...1}; do
                    if [[ $numb =~ ^(9|8|7|6)$ ]] ; then
                        sleep 1s;
                    else
                        screen -Rd "$MCNAME" -X stuff "say $(logMessage counter.stop) $numb $(logMessage counter.sec) $(printf '\r')";
                        sleep 1s;
                    fi
                done
                screen -Rd "$MCNAME" -X stuff "say $(logMessage stop.stopservice) $(printf '\r')";
            fi
        else
            logMessage counter.invalid;
        fi
    fi
    
    local StopChecks=0
    screen -S "$MCNAME" -X quit
    while [ $StopChecks -lt 30 ]; do
        if ! screen -list | grep -q "$MCNAME"; then
            break
        else
            sleep 1s
            StopChecks=$((StopChecks+1))
        fi
    done
    if screen -list | grep -q "$MCNAME"; then
        logMessage stop.kill;
        pkill -15 -f "SCREEN -dmSL $MCNAME"
    fi
    logMessage stop.stopped;
    return;
}

function restart() {
    if ! screen -list | grep -q "$MCNAME"; then
        logMessage stop.offline;
        start;
    else
        stop &
        wait for $!
        start
    fi
    return;
}

function remove() {
    logMessage tool.remove;
    {
        echo -n "";
        read -r MCONFIRM;
    }
    if [[ $MCONFIRM =~ ^("ja"|"yes")$ ]]; then
        logMessage tool.rmY;
        stop &
        wait for $!
        rm "$MCPATH"/mcsys.yml;
        rm -r "$MCPATH"/cycodly;
        rm -- "$0"
    else
        logMessage tool.rmN;
    fi
    return;
}

function setup() {
    local api=https://raw.githubusercontent.com/Argantiu/minecraft-manager/refs/heads/v4/apimanager
    local mclang=$LANG
    local directory=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    local servname=$(basename "$directory" | tr '[:upper:]' '[:lower:]')
    apt-get -q -y update >/dev/null 2>&1
    apt-get -q -y upgrade >/dev/null 2>&1
    
    for cmd in wget joe screen sudo zip xargs diff rpl jq; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            case "$cmd" in
                xargs) apt-get install -y findutils >/dev/null 2>&1 ;;
                diff)  apt-get install -y diffutils >/dev/null 2>&1 ;;
                *)     apt-get install -y "$cmd" >/dev/null 2>&1 ;;
            esac
        fi
    done
    
    if ! command -v yq >/dev/null 2>&1; then
        local bin_path="/usr/local/bin/yq"
        if [[ $EUID -ne 0 ]]; then
            bin_path="$HOME/.local/bin/yq"
            mkdir -p "$(dirname "$bin_path")"
            export PATH="$HOME/.local/bin:$PATH"
        fi
        wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O "$bin_path" && chmod +x "$bin_path"
    fi
    
    mkdir -p ./cycodly && cd ./cycodly
    wget -q $api/CycodlySystemManager.sh
    [[ ! -s CycodlySystemManager.sh ]] && echo "ERROR: Script not loaded, no Network connection." && return 1
    wget -q $api/CycodlySoftwareUpdater.sh
    [[ ! -s CycodlySoftwareUpdater.sh ]] && echo "ERROR: Script not loaded, no Network connection." && return 1
    
    if [[ "$mclang" =~ ^de_ ]]; then
        wget -q $api/resources/de/messages.json
        cd ../
        wget -q $api/resources/de/mcsys.yml
    else
        wget -q $api/resources/en/messages.json
        cd ../
        wget -q $api/resources/en/mcsys.yml
    fi
    sed -i "s|directory:.*|directory: $directory|g" "$directory"/mcsys.yml >/dev/null 2>&1
    sed -i "s|name:.*|name: $servname|g" "$directory"/mcsys.yml >/dev/null 2>&1
    source ./cycodly/CycodlySystemManager.sh
    wget -q https://github.com/Argantiu/.github/releases/download/v3.6.0.0/mcstats.used.yml && rm mcstats.used.yml >/dev/null 2>&1
    logMessage setup.finish
    return;
}

validConfig
cd "$MCPATH" || exit
case "$1" in
    1|'start') start ;;
    2|'stop') stop ;;
    3|'restart') restart ;;
    4|'remove') remove ;;
    *)
        if ! logMessage tool.help >/dev/null 2>&1; then
            setup
        else
            logMessage tool.help
        fi
    ;;
esac