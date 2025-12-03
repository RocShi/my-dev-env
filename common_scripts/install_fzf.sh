#!/bin/bash

set -e

# make sudo optional for root users (e.g. in Docker containers)
if [ "$(id -u)" -eq 0 ]; then
    function sudo() {
        "$@"
    }
fi

echo -e "\nInstalling fzf..."

cd "$(dirname "${BASH_SOURCE[0]}")"

USE_LOCAL_BIN_FILES="$1"
VERSION="0.67.0"

if [ -z "$USE_LOCAL_BIN_FILES" ] || [ "$USE_LOCAL_BIN_FILES" = "y" ]; then
    sudo tar -zxvf ../bin/fzf-0.67.0-linux_amd64.tar.gz -C /usr/local/bin/
else
    TAR_NAME="fzf-${VERSION}-linux_amd64.tar.gz"
    DOWNLOAD_LINK="https://github.com/junegunn/fzf/releases/download/v${VERSION}/${TAR_NAME}"
    wget "${DOWNLOAD_LINK}"
    sudo tar -zxvf "${TAR_NAME}" -C /usr/local/bin/
    sudo rm -f "${TAR_NAME}"
fi
sudo chmod +x /usr/local/bin/fzf

mkdir -p ~/.config/bash
cp ../config/bash/fzf.sh ~/.config/bash/

# configure fzf in bashrc if not exist
if ! grep -Fq "source ~/.config/bash/fzf.sh" ~/.bashrc; then
    cat <<'EOF' >>~/.bashrc

# configure fzf
source ~/.config/bash/fzf.sh
EOF
fi

echo -e "Successfully installed fzf ${VERSION}.\n"
