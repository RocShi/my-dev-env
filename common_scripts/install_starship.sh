#!/bin/bash

set -e

# make sudo optional for root users (e.g. in Docker containers)
if [ "$(id -u)" -eq 0 ]; then
    function sudo() {
        "$@"
    }
fi

echo -e "\nInstalling Starship prompt..."

cd "$(dirname "${BASH_SOURCE[0]}")"

USE_LOCAL_BIN_FILES="$1"
VERSION="1.24.1"
TAR_NAME="starship-x86_64-unknown-linux-musl.tar.gz"

if [ -z "$USE_LOCAL_BIN_FILES" ] || [ "$USE_LOCAL_BIN_FILES" = "y" ]; then
    sudo tar -zxvf ../bin/${TAR_NAME} -C /usr/local/bin/
else
    DOWNLOAD_LINK="https://github.com/starship/starship/releases/download/v${VERSION}/${TAR_NAME}"
    wget "${DOWNLOAD_LINK}"
    sudo tar -zxvf "${TAR_NAME}" -C /usr/local/bin/
    sudo rm -f "${TAR_NAME}"
fi
sudo chmod +x /usr/local/bin/starship

mkdir -p ~/.config
cp ../config/starship.toml ~/.config/

# configure starship in bashrc if not exist
if ! grep -Fq "starship init bash" ~/.bashrc; then
    cat <<'EOF' >>~/.bashrc

# configure starship
eval "$(starship init bash)"
EOF
fi

echo -e "Successfully installed Starship prompt ${VERSION}.\n"
