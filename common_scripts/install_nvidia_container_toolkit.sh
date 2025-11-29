#!/bin/bash

set -e

echo -e "\nInstalling NVIDIA Container Toolkit..."

# add nvidia container toolkit repository
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg &&
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# install apt-fast for faster package installation
sudo add-apt-repository ppa:apt-fast/stable
sudo apt update && sudo apt install -y apt-fast

# install nvidia container toolkit
sudo apt-fast install -y nvidia-container-toolkit

# configure nvidia container runtime
sudo nvidia-ctk runtime configure --runtime=docker

# restart docker service
sudo systemctl restart docker

echo -e "Successfully installed NVIDIA Container Toolkit.\n"
