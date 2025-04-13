#!/bin/bash
source ./cycodly/CycodlySystemManager.sh
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
        logMessage mcstart.online;
        return;
    else
        logMessage mcstart.start;
    fi
    
    if [[ $MCBACKUP == "true" ]]; then
        logMessage mcstart.backup.create
        mkdir -p "$backupPath"
        find "$backupPath"/* -type f -mtime +10 -delete 2>&1
        tar -pzcf "$backupPath"/backup-"$MCNAME"-"$(date +%Y.%m.%d.%H.%M.%S)".tar.gz "${EXCLUDE[@]}" ./
        logMessage mcstart.backup.finish;
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
        logMessage mcstop.offline;
        return;
    fi
    logMessage mcstop.stop;
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
                screen -Rd "$MCNAME" -X stuff "say $(logMessage mcstop.stop_n) $(printf '\r')";
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
        logMessage mcstop.kill;
        pkill -15 -f "SCREEN -dmSL $MCNAME"
    fi
    logMessage mcstop.stopped;
    return;
}

function restart() {
    if ! screen -list | grep -q "$MCNAME"; then
        logMessage mcstop.offline;
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
        logMessage tool.rm_ok;
        stop &
        wait for $!
        rm "$MCPATH"/mcsys.yml;
        rm -r "$MCPATH"/cycodly;
        rm -- "$0"
    else
        logMessage tool.rm_no;
    fi
    return;
}

validConfig
cd "$MCPATH" || exit
case "$1" in
    1|'start') start ;;
    2|'stop') stop ;;
    3|'restart') restart ;;
    4|'remove') remove ;;
    *) logMessage tool.help ;;
esac