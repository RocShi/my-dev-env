#!/bin/bash

set -e

echo -e "\nChanging shell..."

read -p "Which shell to use? (bash/fish/zsh, default: zsh) " SHELL_TYPE
if [ -z "$SHELL_TYPE" ]; then
    SHELL_TYPE="zsh"
else
    if [ "$SHELL_TYPE" != "bash" ] && [ "$SHELL_TYPE" != "fish" ] && [ "$SHELL_TYPE" != "zsh" ]; then
        echo -e "Invalid input, using default value: zsh\n"
        SHELL_TYPE="zsh"
    fi
fi

SHELL_BIN="$(command -v $SHELL_TYPE || true)"
if [ -z "$SHELL_BIN" ]; then
    echo "Error: $SHELL_TYPE not found in PATH after installation." >&2
    exit 1
fi

if [ -f /etc/shells ] && ! grep -qx "$SHELL_BIN" /etc/shells 2>/dev/null; then
    echo "$SHELL_BIN" | sudo tee -a /etc/shells >/dev/null
fi
chsh -s $SHELL_BIN $(whoami)

echo -e "Successfully changed shell to $SHELL_TYPE, need to restart system to take effect.\n"
