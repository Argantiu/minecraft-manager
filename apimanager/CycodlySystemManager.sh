#!/bin/bash
function logMessage() {
    local rawmessage=$(jq -r .$1 "$MCPATH"/cycodly/messages.json)
    if [[ -z $rawmessage || $rawmessage == "null" ]]; then
        echo "Error: Message key '$1' not found in messages.json" >&2
        return 1
    fi

    # Define Minecraft to ANSI color mappings
    declare -A colors=(
        ["§a"]="\033[92m" ["§b"]="\033[94m" ["§c"]="\033[91m"
        ["§d"]="\033[95m" ["§e"]="\033[93m" ["§f"]="\033[97m"
        ["§0"]="\033[30m" ["§1"]="\033[34m" ["§2"]="\033[32m"
        ["§3"]="\033[36m" ["§4"]="\033[31m" ["§5"]="\033[35m"
        ["§6"]="\033[33m" ["§7"]="\033[37m" ["§8"]="\033[90m"
        ["§9"]="\033[94m" ["§r"]="\033[0m"
    )

    # Replace placeholders and color codes
    message="${rawmessage//%servername%/$MCNAME}"
    
    for code in "${!colors[@]}"; do
        message="${message//${code}/${colors[$code]}}"
    done

    # Output the final formatted message
    echo -e "$message";
    return;
}

function configReader() {
    local file=$1
    local prefix=$2
    local s='[[:space:]]*' 
    local w='[a-zA-Z0-9_]*' 
    local fs=$(echo @ | tr @ '\034')

    # Parse the YAML file and transform to key-value pairs
    sed -ne "
        s|^\($s\):|\1|;                       # Remove lines with just ':'
        s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p; # Handle quoted values
        s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p;           # Handle unquoted values
    " "$file" | \
    awk -F"$fs" -v prefix="$prefix" '{
        indent = length($1) / 2;              # Calculate the indentation level
        vname[indent] = $2;                   # Store the variable name at the current level
        for (i in vname) {                    # Clear deeper levels if necessary
            if (i > indent) { delete vname[i] }
        }
        if (length($3) > 0) {                 # If there is a value, construct the full variable name
            vn = ""; 
            for (i = 0; i < indent; i++) {
                vn = vn vname[i] "_";
            }
            # Print the variable name and value, converting the name to uppercase
            printf("%s%s%s=\"%s\"\n", toupper(prefix), toupper(vn), toupper($2), $3);
        }
    }'
    return;
}

function minecraftServiceStart() {
    local javabin=$1
    local ram="$($MCRAM | tr -d 'B')"
    cd "$MCPATH" || exit 1
    logMessage mcstart.start;
    #if [[] $MCSOFTWARE == "velocity"]]
    screen -d -m -L -S "$MCNAME"  /bin/bash -c "$javabin -Xms$ram -Xmx$ram 
    -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions 
    -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 
    -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 
    -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 
    -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs 
    -Daikars.new.flags=true --add-modules=jdk.incubator.vector -jar $MCNAME.jar nogui";
    return;
}

# Function to validate variables
function validConfig() {
  local valid=true

  # Validate MCNAME (lowercase letters only)
  if [[ ! "$MCNAME" =~ ^[a-z]+$ ]]; then
    echo "Error: MCNAME ('$MCNAME') should only contain lowercase letters."
    valid=false
  fi

  # Validate MCDIRECTORY (should be a valid directory path)
  if [[ ! "$MCDIRECTORY" =~ ^/ ]]; then
    echo "Error: MCDIRECTORY ('$MCDIRECTORY') should be an absolute path starting with '/'."
    valid=false
  fi

  # Validate MCVERSION (format like 1.19.3)
  if [[ ! "$MCVERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: MCVERSION ('$MCVERSION') should be in format 'x.y.z'."
    valid=false
  fi

  # Validate MCSOFTWARE (valid options)
  if [[ ! "$MCSOFTWARE" =~ ^(paper|purpur|spigot|craftbukkit|mohist|bungeecord|velocity|waterfall)$ ]]; then
    echo "Error: MCSOFTWARE ('$MCSOFTWARE') is not a valid software choice."
    valid=false
  fi

  # Validate MCBEDROCK (true or false)
  if [[ ! "$MCBEDROCK" =~ ^(true|false)$ ]]; then
    echo "Error: MCBEDROCK ('$MCBEDROCK') should be 'true' or 'false'."
    valid=false
  fi

  # Validate MCRAM (format like 4GB)
  if [[ ! "$MCRAM" =~ ^[0-9]+GB$ ]] || [[ ! "$MCRAM" =~ ^[0-9]+MB$ ]]; then
    echo "Error: MCRAM ('$MCRAM') should be in format 'xGB' or 'xMB'."
    valid=false
  fi

  # Validate MCPROXY (true or false)
  if [[ ! "$MCPROXY" =~ ^(true|false)$ ]]; then
    echo "Error: MCPROXY ('$MCPROXY') should be 'true' or 'false'."
    valid=false
  fi

  # Validate MCCOUNTER (true or false)
  if [[ ! "$MCCOUNTER" =~ ^(true|false)$ ]]; then
    echo "Error: MCCOUNTER ('$MCCOUNTER') should be 'true' or 'false'."
    valid=false
  fi

  # Validate MCBACKUP (true or false)
  if [[ ! "$MCBACKUP" =~ ^(true|false)$ ]]; then
    echo "Error: MCBACKUP ('$MCBACKUP') should be 'true' or 'false'."
    valid=false
  fi

  # Validate MCCONF_VERSION (non-empty)
  if [[ -z "$MCCONF_VERSION" ]]; then
    echo "Error: MCCONF_VERSION is not set."
    valid=false
  fi

  # Final validation result
  if $valid; then
    echo "All configuration variables are valid."
  else
    echo "Configuration validation failed. Please fix the above errors."
    return 1
  fi
}

eval $(configReader ./../mcsys.yml MC)