#!/bin/bash

set -e

echo -e "\nConfiguring Git..."

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

# add the following commands to bashrc if not exist
if ! grep -q "find_git_branch" ~/.bashrc; then
    sudo tee -a ~/.bashrc >/dev/null 2>&1 <<-'EOF'

# These shell commands block are for the purpose of displaying the current branch name of the current repository.
# current branch name of the current repository.
find_git_branch() {
    local dir=. head
    until [ "$dir" -ef / ]; do
        if [ -f "$dir/.git/HEAD" ]; then
            head=$(<"$dir/.git/HEAD")
            if [[ $head = ref:\ refs/heads/* ]]; then
                git_branch="(*${head#*/*/})"
            elif [[ $head != '' ]]; then
                git_branch="(*(detached))"
            else
                git_branch="(*(unknow))"
            fi
            return
        fi
        dir="../$dir"
    done
    git_branch=''
}
PROMPT_COMMAND="find_git_branch; $PROMPT_COMMAND"
export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[0;32m\]\$git_branch\[\033[0m\] \$ "
EOF
fi

echo -e "Successfully configured Git.\n"
