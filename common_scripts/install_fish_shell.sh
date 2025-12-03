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

FISH_BIN="$(command -v fish || true)"
if [ -z "$FISH_BIN" ]; then
    echo "Error: fish not found in PATH after installation." >&2
    exit 1
fi

if [ -f /etc/shells ] && ! grep -qx "$FISH_BIN" /etc/shells 2>/dev/null; then
    echo "$FISH_BIN" | sudo tee -a /etc/shells >/dev/null
fi
chsh -s "$FISH_BIN" "$(whoami)"
echo "The current shell is "$SHELL"."

mkdir -p ~/.config/fish
rm -rf ~/.config/fish/*
cp -r ../config/fish/* ~/.config/fish/

echo -e "Successfully installed fish shell (need to restart system to take effect).\n"
