#!/bin/bash

set -e

# make sudo optional for root users (e.g. in Docker containers)
if [ "$(id -u)" -eq 0 ]; then
    function sudo() {
        "$@"
    }
fi

echo -e "\nInstalling zoxide..."

cd "$(dirname "${BASH_SOURCE[0]}")"

USE_LOCAL_BIN_FILES="$1"
VERSION="0.9.8"

if [ -z "$USE_LOCAL_BIN_FILES" ] || [ "$USE_LOCAL_BIN_FILES" = "y" ]; then
    sudo dpkg -i ../bin/zoxide_0.9.8-1_amd64.deb
else
    BIN_NAME="zoxide_${VERSION}-1_amd64.deb"
    DOWNLOAD_LINK="https://github.com/ajeetdsouza/zoxide/releases/download/v${VERSION}/${BIN_NAME}"
    wget "${DOWNLOAD_LINK}"
    sudo dpkg -i "${BIN_NAME}"
    sudo rm -f "${BIN_NAME}"
fi

mkdir -p ~/.config/bash
cp ../config/bash/zoxide.sh ~/.config/bash/

# configure zoxide in bashrc if not exist
if ! grep -Fq "source ~/.config/bash/zoxide.sh" ~/.bashrc; then
    cat <<'EOF' >>~/.bashrc

# configure zoxide
source ~/.config/bash/zoxide.sh
EOF
fi

echo -e "Successfully installed zoxide ${VERSION}.\n"
