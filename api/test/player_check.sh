#!/bin/bash
IP=$(hostname -I | grep -o '^\S*') # the server ip. This can be 127.0.0.1
PORT=$(cat < "$MCPATH"/server.properties | grep server-port | grep -oE '[0-9]+') # get's server port



# Get server information
# ... echo -e "\xFE\x01" | nc ... to get version and type
response=$(echo -e "\xFE" | nc $IP $PORT | tr -d '\0')

# Get current playercount
playercount=$(echo "$response" | grep -oE '[0-9]+' | tail -n 2 | head -n 1)

echo "$playercount players online"
