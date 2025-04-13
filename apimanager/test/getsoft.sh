CYCODLYAPI=https://raw.githubusercontent.com/Argantiu/minecraft-manager/refs/heads/v4/apimanager

function setup() {
    local PX="\033[1;30m[\033[1;32mCycodly\033[1;30m]\033[0;37m"
    echo "------------------------------------------"
    echo -e "$PX Welcome to Cycodly's server management tool\n$MPX You can leave with STRG+C"
    echo -e "$PX -----------------------------------"
    echo -e "$PX First, please select your language:\n$PX 1 = English (English)"
    echo -e ""
    { echo -n -e "$PX Please type a number and hit enter:"; echo -n -e " "; read -r MCLANG; }
    case $MCLANG in
        1)
            echo -e "$MCPREFIX Where is your server directory located?\n$MCPREFIX e.g. /opt/paper or /home/myserver/server"
            echo -e "$MCPREFIX Your server directory:" ;;
        2)
            echo -e "$MCPREFIX Wo ist oder soll dein Serverordner sich befinnden?"
            echo -e "$MCPREFIX z.b. /opt/paper oder /home/meinserver/server"
            echo -e "$MCPREFIX Und wo ist oder soll der Ordner sein:" ;;
        *) 
            echo "Please select a language! " && exit 1 ;;
    esac
    { echo -n -e " "; read -r DCI; }
    DICTY=$(echo "$DCI" | sed 's/\/$//')
    
    for cmd in joe screen sudo zip xargs diff rpl jq; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            case "$cmd" in
                xargs) apt-get install -y findutils >/dev/null 2>&1 ;;
                diff)  apt-get install -y diffutils >/dev/null 2>&1 ;;
                *)     apt-get install -y "$cmd" >/dev/null 2>&1 ;;
            esac
        fi
    done
    
    if ! command -v yq >/dev/null 2>&1; then
        wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq
    fi
    
    
}

setup


