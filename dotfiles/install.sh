#!/bin/bash

programs=("zsh" "tmux" "vim" "git" "curl" "python3")

dir="~/quan-monorepo/dotfiles"
olddir="~/dotfiles_old"
files="zshrc vimrc p10k.zsh tmux.conf"

# Helper functions
install_program() {
    local distribution="$1"
    local program="$2"
    case "$distribution" in
        "ubuntu" | "debian")
            sudo apt update
            sudo apt install "$program"
            ;;
        "arch")
            sudo pacman -S "$program"
            ;;
        *)
            echo "Unsupported Linux distro: $distribution."
            return 1
            ;;
    esac
}

check_program() {
    local program="$1"
    if command -v "$program" &>/dev/null; then
        echo "$program is installed."
    else
        echo "$program is not installed."
        return 1
    fi
}

# Check the operating system
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Detect Linux distribution
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        distribution="$ID"

        # Install programs
        for program in "${programs[@]}"; do
            if ! check_program "$program"; then
                echo "Installing $program..."
                install_program "$distribution" "$program"
                echo "...done"
            fi
        done
    else
        echo "Could not detect Linux distribution."
        exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if ! command -v brew &>/dev/null; then
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  # Copy-paste from <brew.sh>
        echo "...done"
    fi

    # Install programs
    for program in "${programs[@]}"; do
        if ! check_program "$program"; then
            echo "Installing $program..."
            brew install "$program"
            echo "...done"
        fi
    done
else
    echo "Unsupported operating system. Please install zsh manually."
    exit 1
fi
echo "...done"

# Set zsh as default shell
if [[ "$SHELL" != "/bin/zsh" ]]; then
    echo "Setting zsh as default shell..."
    if [[ -x /usr/bin/chsh ]]; then
        sudo chsh -s "$(which zsh)"
    else
        echo "chsh is not installed. Please set zsh as default shell manually."
        exit 1
    fi
    echo "...done"
fi

# Create dotfiles_old in ~
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# Move to dotfiles directory
echo "Move to $dir directory"
cd $dir
echo "...done"

# Move existing dotfiles to old directory, then create symlinks
for file in $files; do
    if [[ -f "~/.$file" ]]; then
        echo "Moving existing .$file from ~ to $olddir"
        mv ~/.$file $olddir
    fi
    echo "Creating symlink to $file in ~"
    ln -s $dir/$file ~/.$file
done

# Moving for oh-my-zsh
if [[ -d "~/.oh-my-zsh" ]]; then
  echo "An existing oh-my-zsh installation detected."
else
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "...done"
fi
echo "Moving custom themes and plugins to oh-my-zsh."
mv ~/.oh-my-zsh/custom ~/.oh-my-zsh/custom_old
ln -s $dir/oh-my-zsh/custom ~/.oh-my-zsh/custom
echo "...done"