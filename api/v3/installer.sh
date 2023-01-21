#!/bin/bash

# Ask for language

# Ask for server location
# Ask for server Software
# Downloading language assets
# Downloading assets
# Update packetloader
# Update packets
# Download needed packets

apt install gnupg ca-certificates curl
curl -s https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg
echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | sudo tee /etc/apt/sources.list.d/zulu.list
