#!/bin/bash

set -e

echo -e "\nSetting up WSL2..."

cd "$(dirname "${BASH_SOURCE[0]}")"

source ../common_scripts/install_base.sh
source ../common_scripts/config_git.sh
source ../common_scripts/install_efficiency_tools.sh
source ../common_scripts/install_docker.sh
source ../common_scripts/install_nvidia_container_toolkit.sh

echo -e "Successfully setup WSL2.\n"
