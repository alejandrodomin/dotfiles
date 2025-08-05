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

    "$GUM" log --time TimeOnly --structured --level info "Tools installed by default: ghostty zsh oh-my-zsh neovim ripgrep fzf lazygit lazydocker"
    # java and mojo options not supported yet
    opt_string=$("$GUM" choose --no-limit --header "Pick Development Suite to Install:" "C/C++ (bear, valgrind)" "Java  (eclipse.jdt.ls)" "Mojo  (pixi)")
    if [[ $? -gt 0 || -z "$opt_string" ]]; then
        return $WARNING
    fi

    read -a options <<<$opt_string

    for opt in "${options[@]}"; do
        case "$opt" in
        "C/C++")
            i_bear
            i_valgrind
            ;;
        "Java")
            i_eclipse
            ;;
        "Mojo")
            i_pixi
            ;;
        esac
    done
}

i_bear() {
    brew list bear >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        "$GUM" log --time TimeOnly --structured --level info "Bear already installed"
        return $SUCCESS
    fi

    "$GUM" spin --spinner dot --title "Installing bear..." -- bash -c "/home/linuxbrew/.linuxbrew/bin/brew install --quiet bear"
    if [[ $? -gt 0 ]]; then
        "$GUM" log --time TimeOnly --structured --level error "Error installing bear"
        exit
    else
        "$GUM" log --time TimeOnly --structured --level info "Bear installed"
    fi
}

i_valgrind() {
    validation=$(apt list --installed valgrind 2>/dev/null)
    if [[ $validation == *"installed"* ]]; then
        "$GUM" log --time TimeOnly --structured --level info "Valgrind already installed"
        return $SUCCESS
    fi

    sudo echo -n
    "$GUM" spin --spinner dot --title "Installing valgrind..." -- sudo bash -c "apt-get install -y valgrind"
    if [[ $? -gt 0 ]]; then
        "$GUM" log --time TimeOnly --structured --level error "Error installing valgrind"
        exit
    else
        "$GUM" log --time TimeOnly --structured --level info "Valgrind installed"
    fi
}

i_pixi() {
    validation=$(pixi --version)
    if [[ $validation == *"pixi"* ]]; then
        "$GUM" log --time TimeOnly --structured --level info "Pixi already installed"
        return $SUCCESS
    fi

    sudo echo -n
    "$GUM" spin --spinner dot --title "Installing pixi..." -- sudo bash -c "curl -fsSL https://pixi.sh/install.sh | sh >/dev/null 2>&1"
    if [[ $? -gt 0 ]]; then
        "$GUM" log --time TimeOnly --structured --level error "Error installing pixi"
        exit
    else
        "$GUM" log --time TimeOnly --structured --level info "Pixi installed"
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
        "$GUM" log --time TimeOnly --structured --level warn "nvim already linked"
    elif [[ $code -eq $ERROR ]]; then
        return $ERROR
    fi

    link $(pwd)/ghostty $HOME/.config/ghostty
    code=$?
    if [[ $code -eq $WARNING ]]; then
        "$GUM" log --time TimeOnly --structured --level warn "ghostty already linked"
    elif [[ $code -eq $ERROR ]]; then
        return $ERROR
    fi

    link $(pwd)/zsh/.zshrc $HOME/.zshrc
    code=$?
    if [[ $code -eq $WARNING ]]; then
        "$GUM" log --time TimeOnly --structured --level warn "zsh already linked"
    elif [[ $code -eq $ERROR ]]; then
        return $ERROR
    fi
}
# ---- -------

main() {
    install_all
    code=$?
    if [[ $code -eq $WARNING ]]; then
        "$GUM" log --time TimeOnly --structured --level warn "No options selected, nothing to do"
        exit
    elif [[ $code -gt 0 ]]; then
        "$GUM" log --time TimeOnly --structured --level error "Error occured during installation"
        exit
    else
        "$GUM" log --time TimeOnly --structured --level info "Installed all items"
    fi

    link_all
    if [[ $? -gt 0 ]]; then
        "$GUM" log --time TimeOnly --structured --level error "Error occured during linking"
        exit
    else
        "$GUM" log --time TimeOnly --structured --level info "Linked all dotfiles"
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

    "$GUM" log --time TimeOnly --structured --level info "Init finished"
}

init
main
