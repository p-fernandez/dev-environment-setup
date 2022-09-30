#!/usr/bin/env bash
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
#

echo "Start..."

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew tap homebrew/dupes
brew install coreutils
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-indent --with-default-names
brew install gnu-which --with-default-names
brew install gnu-grep --with-default-names

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

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
    nvm
    openjdk
    pkg-config
    postgresql
    protobuf
    python
    python3
    redis
    ssh-copy-id
    the_silver_searcher
    tmux
    vim
    webp
    wget
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

echo "Installing cask..."
brew install homebrew/cask

CASKS=(
    brave-browser
    docker
    firefox
    google-chrome
    vlc
)

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Installing fonts..."
brew tap caskroom/fonts
FONTS=(
    font-hack-nerd-font
    font-inconsolidata
    font-roboto
    font-clear-sans
)
brew cask install ${FONTS[@]}

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


echo "Creating development folder structure..."
[[ ! -d Dev ]] && mkdir ~/Dev

echo "Set up complete 🖖🏻"
