#!/bin/bash

programs=("build_essentials" "zsh" "tmux" "vim" "git" "curl" "awk" "perl" "sed" "pyenv")

dir=~/quan-monorepo/dotfiles
olddir=~/dotfiles_old
files="zshrc vimrc p10k.zsh tmux.conf.local gitconfig"

# Helper functions
install_program() {
    local distribution="$1"
    local program="$2"

    if [ "$program" = "pyenv" ]; then
        curl https://pyenv.run | bash
        return 0
    fi

    if [ "$program" = "build_essentials" ]; then
        case "$distribution" in
            "ubuntu" | "debian")
                sudo apt update
                sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev libxml2-dev libxmlsec1-dev liblzma-dev tk-dev
                ;;
            "arch")
                sudo pacman -S --no-confirm base-devel openssl zlib bzip2 readline sqlite libffi libxml2 libxmlsec xz tk
                ;;
            *)
                echo "Unsupported Linux distro: $distribution."
                return 1
                ;;
        esac
        return 0
    fi

    case "$distribution" in
        "ubuntu" | "debian")
            sudo apt update
            sudo apt install -y "$program"
            ;;
        "arch")
            sudo pacman -S --no-confirm "$program"
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
    fi

    # Install programs
    brew update
    for program in "${programs[@]}"; do
        if ! check_program "$program"; then
            echo "Installing $program..."
            brew install --yes "$program"
        fi
        if [ "$program" = "build_essentials" ]; then
            brew install --yes openssl zlib readline sqlite libffi libxml2 libxmlsec xz python-tk
        fi
    done
else
    echo "Unsupported operating system. Please install zsh manually."
    exit 1
fi

# Set zsh as default shell
if [[ "$SHELL" != /bin/zsh ]]; then
    echo "Setting zsh as default shell..."
    if [[ -x /usr/bin/chsh ]]; then
        sudo chsh -s "$(which zsh)"
    else
        echo "chsh is not installed. Please set zsh as default shell manually."
        exit 1
    fi
fi

# Clone the repository to ~
if [[ -d ~/quan-monorepo ]]; then
    echo "An existing quan-monorepo directory detected."
else
    echo "Cloning quan-monorepo..."
    git clone https://github.com/QuanDo2000/quan-monorepo.git
fi

# Create dotfiles_old in ~
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir

# Move to dotfiles directory
echo "Move to $dir directory"
cd $dir

# Installing for oh-my-zsh. This needs to go before the links.
if [[ -d ~/.oh-my-zsh ]]; then
  echo "An existing oh-my-zsh installation detected."
else
  echo "Installing oh-my-zsh..."
  # https://github.com/ohmyzsh/ohmyzsh/wiki
  # https://github.com/ohmyzsh/ohmyzsh#unattended-install
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  # https://github.com/romkatv/powerlevel10k#installation
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Installing Oh My Tmux.
# https://github.com/gpakosz/.tmux
cd $HOME
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf

# Install python from pyenv.
if command -v pyenv &>/dev/null; then
    echo "pyenv is installed. Installing the latest Python version..."
    latest_python_version=$(pyenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+\s*$' | tail -n 1 | sed -e 's/^\s*//' -e 's/\s*$//')
    echo "Installing the latest Python version: $latest_python_version"
    pyenv install "$latest_python_version"

    # Set the global Python version
    pyenv global "$latest_python_version"

    echo "Python $latest_python_version is installed and set as the global version."
fi

# Move existing dotfiles to old directory, then create symlinks
for file in $files; do
    if [[ -f ~/.$file ]]; then
        echo "Moving existing .$file from ~ to $olddir"
        mv ~/.$file $olddir
    fi
    echo "Creating symlink to $file in ~"
    ln -s $dir/$file ~/.$file
done

exec zsh
