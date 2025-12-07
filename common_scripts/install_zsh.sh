#!/bin/bash
set -e

# make sudo optional for root users (e.g. in Docker containers)
if [ "$(id -u)" -eq 0 ]; then
    function sudo() {
        "$@"
    }
fi

# get the project root directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$SCRIPT_DIR/..
CONFIG_SRC=$PROJECT_ROOT/config/zsh

echo -e "\nInstalling zsh..."

# 1. install zsh binary (if not present)
# we continue anyway, maybe the user just wants the config files
if ! command -v zsh >/dev/null 2>&1; then
    echo "Installing zsh from system package manager..."
    if command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt install -y zsh
    else
        echo "Error: Could not detect package manager to install zsh. Please install it manually."
    fi
else
    echo "zsh is already installed."
fi

# 2. deploy plugins and config files
echo "Deploying plugins and config files..."
PLUGIN_DEST=$HOME/.config/zsh/plugins
mkdir -p $PLUGIN_DEST
cp -r $CONFIG_SRC/plugins/* $PLUGIN_DEST/
cp $CONFIG_SRC/*.zsh $HOME/.config/zsh/
cp $CONFIG_SRC/.zshrc $HOME/

# 3. load bash_history into zsh_history
if [ -f $HOME/.bash_history ]; then
    cat $HOME/.bash_history | tr -d '\r' | awk '{print ": 0:0;"$0}' >> $HOME/.zsh_history
fi

echo -e "Successfully installed zsh.\n"
