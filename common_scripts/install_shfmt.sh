#!/bin/bash

set -e

echo -e "\nInstalling shfmt..."

VERSION="3.12.0"
BIN_NAME="shfmt_v${VERSION}_linux_amd64"
DOWNLOAD_LINK="https://github.com/mvdan/sh/releases/download/v${VERSION}/${BIN_NAME}"

cd "$(dirname "${BASH_SOURCE[0]}")"

wget ${DOWNLOAD_LINK}

sudo cp -f "${BIN_NAME}" "/usr/local/bin/shfmt"
sudo chmod +x "/usr/local/bin/shfmt"
sudo rm -f "${BIN_NAME}"

echo -e "Successfully installed shfmt ${VERSION}.\n"
