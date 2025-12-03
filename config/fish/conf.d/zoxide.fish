# !/usr/local/bin/fish

# Since Fish is installed as a single binary, missing the standard library's cd.fish,
# zoxide init will fail. Here we manually define the core functionality of zoxide.

# Define z command: query and jump
function z
    set -l result (command zoxide query --exclude $PWD -- $argv)
    and cd $result
end

# Define zi command: interactive query and jump
function zi
    set -l result (command zoxide query -i --exclude $PWD -- $argv)
    and cd $result
end

# Use prompt hook to automatically record path (equivalent to --hook prompt)
function __zoxide_hook --on-event fish_prompt
    command zoxide add -- $PWD
end

alias zz="zi"
