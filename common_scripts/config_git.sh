#!/bin/bash

set -e

echo -e "\nConfiguring Git..."

cd "$(dirname "${BASH_SOURCE[0]}")"

DEFAULT_USERNAME="ShiPeng"
DEFAULT_EMAIL="RocShi@outlook.com"

read -p "Enter your username (default: $DEFAULT_USERNAME): " USERNAME
if [ -z "$USERNAME" ]; then
    USERNAME=$DEFAULT_USERNAME
fi
read -p "Enter your email (default: $DEFAULT_EMAIL): " EMAIL
if [ -z "$EMAIL" ]; then
    EMAIL=$DEFAULT_EMAIL
fi

git config --global user.name "$USERNAME"
git config --global user.email "$EMAIL"

# set alias
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.st "status"
git config --global alias.cma "commit --amend"
git config --global alias.pl "pull"
git config --global alias.ps "push"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.df "diff"
git config --global alias.cp "cherry-pick -xs"
git config --global alias.rs "reset"
git config --global alias.rb "rebase"

mkdir -p ~/.config/bash
cp ../config/bash/git.sh ~/.config/bash/

# configure git in bashrc if not exist
if ! grep -q "source ~/.config/bash/git.sh" ~/.bashrc; then
    cat <<'EOF' >>~/.bashrc

# configure git
source ~/.config/bash/git.sh
EOF
fi

echo -e "Successfully configured Git.\n"
