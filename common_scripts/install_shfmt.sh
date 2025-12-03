#!/bin/bash

set -e

# make sudo optional for root users (e.g. in Docker containers)
if [ "$(id -u)" -eq 0 ]; then
    function sudo() {
        "$@"
    }
fi

echo -e "\nInstalling shfmt..."

cd "$(dirname "${BASH_SOURCE[0]}")"

USE_LOCAL_BIN_FILES="$1"
if [ "$USE_LOCAL_BIN_FILES" = "y" ]; then
    sudo cp -f ../bin/shfmt_v3.12.0_linux_amd64 /usr/local/bin/shfmt
else
    VERSION="3.12.0"
    BIN_NAME="shfmt_v${VERSION}_linux_amd64"
    DOWNLOAD_LINK="https://github.com/mvdan/sh/releases/download/v${VERSION}/${BIN_NAME}"
    wget ${DOWNLOAD_LINK}
    sudo cp -f "${BIN_NAME}" /usr/local/bin/shfmt
    sudo rm -f "${BIN_NAME}"
fi
sudo chmod +x /usr/local/bin/shfmt

echo -e "Successfully installed shfmt ${VERSION}.\n"
