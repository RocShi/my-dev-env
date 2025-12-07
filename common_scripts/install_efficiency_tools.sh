#!/bin/bash

set -e

echo -e "\nInstalling efficiency tools..."

cd "$(dirname "${BASH_SOURCE[0]}")"

read -p "Whether to use local bin files? (y/n, default: y) " USE_LOCAL_BIN_FILES
if [ -z "$USE_LOCAL_BIN_FILES" ]; then
    USE_LOCAL_BIN_FILES="y"
else
    if [ "$USE_LOCAL_BIN_FILES" != "y" ] && [ "$USE_LOCAL_BIN_FILES" != "n" ]; then
        echo -e "Invalid input, using default value: y\n"
        USE_LOCAL_BIN_FILES="y"
    fi
fi

source install_shfmt.sh $USE_LOCAL_BIN_FILES
source install_zoxide.sh $USE_LOCAL_BIN_FILES
source install_fzf.sh $USE_LOCAL_BIN_FILES
source install_fish_shell.sh $USE_LOCAL_BIN_FILES
source install_zsh.sh
# source install_starship.sh $USE_LOCAL_BIN_FILES
source change_shell.sh

echo -e "Successfully installed efficiency tools.\n"
