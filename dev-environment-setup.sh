#!/bin/bash
# 
# Machine set up script for setting up a new development environment
# 
# This should be idempotent so it can be run multiple times.
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
# - Also Xcode tools has installed Git by default. Git is needed for the installation
#   of Homebrew.
#

add_separator () {
  echo " "
  echo "🔽🔽🔽🔽🔽🔽🔽🔽"
  echo " "
}

echo " "
echo "Start... ⚡️"

add_separator

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew recipes
echo "Tap, update and upgrade Homebrew..."
brew tap homebrew/cask
brew update
brew upgrade

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

add_separator

PACKAGES=(
    curl
    ffmpeg
    gcc
    gettext
    git
    httpd
    imagemagick
    jq
    libjpeg
    lynx
    pkg-config
    ssh-copy-id
    the_silver_searcher
    tmux
    vim
    webp
    wget
)

echo "Installing packages..."
brew install "${PACKAGES[@]}"

add_separator

LANGUAGES=(
    nvm
    openjdk
    protobuf
    python
    python3
)

echo "Installing languages..."
brew install "${LANGUAGES[@]}"


echo "Create NVM folder if not existing..."
[[ ! -d ~/.nvm ]] && mkdir ~/.nvm

add_separator

DATABASES=(
    mongosh
    postgresql@14
    redis
)

echo "Installing databases..."
brew install "${DATABASES[@]}"

echo "Cleaning up..."
brew cleanup

add_separator

APPS=(
    brave-browser
    docker
    firefox
    google-chrome
    vlc
)

echo "Installing cask apps..."
brew install --cask "${APPS[@]}"

add_separator

echo "Installing fonts..."
brew tap homebrew/cask-fonts

FONTS=(
    font-hack-nerd-font
    font-inconsolata
    font-roboto
    font-clear-sans
)
brew install --cask "${FONTS[@]}"

add_separator

echo "Configuring OSx..."

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Save screenshots to folder
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Set machine name
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "Universe"

add_separator

echo "Creating development folder structure..."
[[ ! -d ~/Dev ]] && mkdir ~/Dev

add_separator

echo "Copy VIM configuration file..."
[[ ! -f ~/.vimrc ]] && curl -o ~/.vimrc https://raw.githubusercontent.com/p-fernandez/vimrc/main/.vimrc

add_separator

echo "Set up complete."
echo "🖖🏻"
echo " "
