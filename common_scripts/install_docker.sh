#!/bin/bash

set -e

# make sudo optional for root users (e.g. in Docker containers)
if [ "$(id -u)" -eq 0 ]; then
    function sudo() {
        "$@"
    }
fi

echo -e "\nInstalling Docker..."

# install docker
curl -fsSL https://get.docker.com | sudo sh -s -- --mirror Aliyun
sudo systemctl start docker && sudo systemctl enable docker && sudo systemctl restart docker

# add user to docker group
sudo groupadd docker && sudo usermod -aG docker $(whoami)

# set docker registry mirrors for faster image download
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://dockerproxy.com",
    "https://mirror.ccs.tencentyun.com"
  ]
}
EOF

# restart docker service
sudo systemctl daemon-reload && sudo systemctl restart docker

echo -e "Successfully installed Docker.\n"
