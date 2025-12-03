#!/bin/bash

# find the current branch name of the current repository
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
