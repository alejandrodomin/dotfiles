#!/bin/bash

GUM="/home/linuxbrew/.linuxbrew/bin/gum"
BREW="/home/linuxbrew/.linuxbrew/bin/brew"
SUCCESS=0
ERROR=1
WARNING=2

# install all
install_all() {
    declare -a c_options=("bear" "valgrind")
    declare -a java_options=("eclipse.jdt.ls")
    declare -a mojo_options=("pixi")

    "$GUM" style --foreground "#00FF00" -- "✔ Tools installed by default: ghostty, zsh, oh-my-zsh, neovim, ripgrep, fzf, lazygit, lazydocker"
    # java and mojo options not supported yet
    opt_string=$("$GUM" choose --no-limit --header "Pick Development Suite to Install:" "C/C++ Tools" "Java Tools" "Mojo Tools")
    if [[ $? -gt 0 || -z "$opt_string" ]]; then
        return $WARNING
    fi

    read -a options <<<"$opt_string"

    for opt in "${options[@]}"; do
        case "$opt" in
        "C/C++ Tools")
            i_bear
            i_valgrind
            ;;
        "Java Tools")
            ;;
        "Mojo Tools")
            ;;
        *)
            "$GUM" style --foreground "#FFFF00" -- "⚠ Unknown option $opt"
            ;;
        esac
    done
}

i_bear() {
    brew list bear >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        "$GUM" style --foreground "#FFFF00" -- "⚠ Bear already installed"
        return $SUCCESS
    fi

    "$GUM" spin --spinner dot --title "Installing bear ..." -- bash -c "/home/linuxbrew/.linuxbrew/bin/brew install --quiet bear"
    if [[ $? -gt 0 ]]; then
        "$GUM" style --foreground "#FF0000" -- "✖ Error installing bear"
        exit
    else
        "$GUM" style --foreground "#00FF00" -- "✔ Bear installed successfully"
    fi
}

i_valgrind() {
    sudo echo -n
    "$GUM" spin --spinner dot --title "Installing valgrind ..." -- sudo bash -c "apt-get install -y valgrind"
    if [[ $? -gt 0 ]]; then
        "$GUM" style --foreground "#FF0000" -- "✖ Error installing valgrind"
        exit
    else
        "$GUM" style --foreground "#00FF00" -- "✔ Valgrind installed successfully"
    fi
}
# ------- ---

# file linking
link() {
    local target="$1"
    local link_name="$2"

    if [ -L "$link_name" ]; then
        return $WARNING
    elif [ -e "$link_name" ]; then
        return $WARNING
    else
        ln -s "$target" "$link_name"
        if [[ $? -gt 0 ]]; then
            return $ERROR
        else
            return $SUCCESS
        fi
    fi
}

link_all() {
    link $(pwd)/nvim $HOME/.config/nvim
    code=$?
    if [[ $code -eq $WARNING ]]; then
        "$GUM" style --foreground "#FFFF00" -- "⚠ nvim already linked"
    elif [[ $code -eq $ERROR ]]; then
        return $ERROR
    fi

    link $(pwd)/ghostty $HOME/.config/ghostty
    code=$?
    if [[ $code -eq $WARNING ]]; then
        "$GUM" style --foreground "#FFFF00" -- "⚠ ghostty already linked"
    elif [[ $code -eq $ERROR ]]; then
        return $ERROR
    fi

    link $(pwd)/zsh/.zshrc $HOME/.zshrc
    code=$?
    if [[ $code -eq $WARNING ]]; then
        "$GUM" style --foreground "#FFFF00" -- "⚠ zsh already linked"
    elif [[ $code -eq $ERROR ]]; then
        return $ERROR
    fi
}
# ---- -------

main() {
    install_all
    code=$?
    if [[ $code -eq $WARNING ]]; then
        "$GUM" style --foreground "#FFFF00" -- "⚠ No options selected, nothing to do"
        exit
    elif [[ $code -gt 0 ]]; then
        "$GUM" style --foreground "#FF0000" -- "✖ Error occurred during installation"
        exit
    else
        "$GUM" style --foreground "#00FF00" -- "✔ Installed all items successfully"
    fi

    link_all
    if [[ $? -gt 0 ]]; then
        "$GUM" style --foreground "#FF0000" -- "✖ Error occurred during linking"
        exit
    else
        "$GUM" style --foreground "#00FF00" -- "✔ Linked all dotfiles successfully"
    fi
}

init() {
    if [[ ! -f "$BREW" ]]; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ $? -eq $ERROR ]]; then
            echo "fatal error unable to install brew"
            exit
        fi
    fi

    if [[ ! -f "$GUM" ]]; then
        "$BREW" install --quiet gum >/dev/null 2>&1
        if [[ $? -eq $ERROR ]]; then
            echo "fatal error unable to install gum"
            exit
        fi
    fi

    "$GUM" style --foreground "#00FF00" -- "✔ Init finished successfully"
}

init
main
