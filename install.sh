#!/bin/sh

set -e

BASE_DIR="$HOME/AeternumOS-Setup"
CONFIG_DIR="$HOME/.config/rebos"

echo "==> Ensuring git is installed..."

if ! command -v git >/dev/null 2>&1; then
    echo "Git not found, installing..."
    sudo  pacman -S git
else
    echo "Git already installed."
fi

echo "==> Starting AeternumOS initialization..."

# Create working directory
mkdir -p "$BASE_DIR"
cd "$BASE_DIR"



#  Need to move this to hook - git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
# ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"



# ---- Clone Repositories ----

if [ ! -d "AeternumOS" ]; then
    echo "==> Cloning AeternumOS..."
    git clone https://github.com/OddlyGeek/AeternumOS.git
else
    echo "==> AeternumOS already exists, pulling latest..."
    cd AeternumOS && git pull
    cd ..
fi

if [ ! -d "AeternumOS-Rebos" ]; then
    echo "==> Cloning AeternumOS-Rebos..."
    git clone https://github.com/OddlyGeek/AeternumOS-Rebos.git
else
    echo "==> AeternumOS-Rebos already exists, pulling latest..."
    cd AeternumOS-Rebos && git pull
    cd ..
fi

# ---- Install RebOS through Cargo ----

echo "==> Installing rebos using cargo..."

if ! command -v rebos >/dev/null 2>&1; then
    cargo install rebos
else
    echo "==> rebos already installed, skipping cargo install"
fi

# ---- Initialize rebos ----

echo "==> Running rebos setup..."
rebos setup

echo "==> Initializing rebos config..."
rebos config init

# ---- Copy config ----

echo "==> Copying AeternumOS rebos config..."
mkdir -p "$CONFIG_DIR"
cp -r AeternumOS/rebos_config/* "$CONFIG_DIR"

# ---- Rebos Commit and Build ----

while getopts "b" opt; do
    case $opt in
        b)

            echo "==> Running rebos commit..."
            rebos commit "Initial Run"

            echo "==> Generating build..."
            rebos gen current build

            echo "==> Initialization completed successfully!"
            ;;
    esac
done