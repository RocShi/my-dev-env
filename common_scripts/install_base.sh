#!/bin/bash

set -e

# make sudo optional for root users (e.g. in Docker containers)
if [ "$(id -u)" -eq 0 ]; then
    function sudo() {
        "$@"
    }
fi

echo -e "\nInstalling base packages..."

ubuntu_version=$(cat /etc/os-release | grep "VERSION_ID" | sed 's/\(VERSION_ID=\|"\|\.\)//g')

# replace sources with aliyun
echo "Ubuntu $ubuntu_version detected, replacing sources with aliyun..."
if [ "$ubuntu_version" == "2404" ]; then
    sudo cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak.$(date +%Y%m%d%H%M%S)
    sudo tee /etc/apt/sources.list.d/ubuntu.sources >/dev/null 2>&1 <<-'EOF'
Types: deb
URIs: http://mirrors.aliyun.com/ubuntu/
Suites: noble noble-updates
Components: main restricted universe multiverse

Types: deb
URIs: http://mirrors.aliyun.com/ubuntu/
Suites: noble-backports
Components: main restricted universe multiverse

Types: deb
URIs: http://mirrors.aliyun.com/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
EOF
else
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%Y%m%d%H%M%S)
fi

echo "Updating and upgrading packages..."
sudo apt update && sudo apt upgrade -y
# Install locales to fix character encoding issues (e.g. zsh/autosuggestions glitches)
sudo apt install -y wget curl git vim build-essential locales

echo "Generating en_US.UTF-8 locale..."
sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8

echo -e "Successfully installed base packages.\n"
