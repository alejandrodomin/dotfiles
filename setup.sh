#!/bin/bash

link() {
    local target="$1"
    local link_name="$2"

    if [ -L "$link_name" ]; then
        echo "Symlink already exists: $link_name → $(readlink "$link_name")"
    elif [ -e "$link_name" ]; then
        echo "Skipping: $link_name already exists and is not a symlink"
    else
        ln -s "$target" "$link_name"
        echo "Linked: $link_name → $target"
    fi
}

link $(pwd)/nvim $HOME/.config/nvim
link $(pwd)/ghostty $HOME/.config/ghostty
link $(pwd)/zsh/.zshrc $HOME/.zshrc
