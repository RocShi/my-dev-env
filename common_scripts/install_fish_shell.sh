#!/bin/bash

set -e

# make sudo optional for root users (e.g. in Docker containers)
if [ "$(id -u)" -eq 0 ]; then
    function sudo() {
        "$@"
    }
fi

echo -e "\nInstalling fish shell..."

cd "$(dirname "${BASH_SOURCE[0]}")"

USE_LOCAL_BIN_FILES="$1"
if [ -z "$USE_LOCAL_BIN_FILES" ] || [ "$USE_LOCAL_BIN_FILES" = "y" ]; then
    sudo tar -xf ../bin/fish-4.2.1-linux-x86_64.tar.xz -C /usr/local/bin/
    sudo chmod +x /usr/local/bin/fish
else
    sudo apt-add-repository ppa:fish-shell/release-4
    sudo apt update
    sudo apt install fish
fi

mkdir -p ~/.config/fish
rm -rf ~/.config/fish/*
cp -r ../config/fish/* ~/.config/fish/

echo -e "Successfully installed fish shell.\n"
