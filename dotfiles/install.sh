#!/bin/bash

programs=("zsh" "tmux" "vim" "git" "curl" "awk" "perl" "sed")

dir="~/quan-monorepo/dotfiles"
olddir="~/dotfiles_old"
files="zshrc vimrc p10k.zsh tmux.conf.local"

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

# Installing for oh-my-zsh. This needs to go before the links.
if [[ -d "~/.oh-my-zsh" ]]; then
  echo "An existing oh-my-zsh installation detected."
else
  echo "Installing oh-my-zsh..."
  # https://github.com/ohmyzsh/ohmyzsh/wiki
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  # https://github.com/romkatv/powerlevel10k#installation
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  echo "...done"
fi

# Installing Oh My Tmux.
# https://github.com/gpakosz/.tmux
cd $HOME
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf

# Move existing dotfiles to old directory, then create symlinks
for file in $files; do
    if [[ -f "~/.$file" ]]; then
        echo "Moving existing .$file from ~ to $olddir"
        mv ~/.$file $olddir
    fi
    echo "Creating symlink to $file in ~"
    ln -s $dir/$file ~/.$file
done
