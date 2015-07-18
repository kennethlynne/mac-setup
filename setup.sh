#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Set standby delay to 24 hours (default is 1 hour)
sudo pmset -a standbydelay 86400

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

defaults write com.apple.finder QLEnableTextSelection -bool true && killall Finder

brews=(
  brew-cask
  git
  git-extras
  nvm
  python
  python3
  ruby
  wget
  zsh
)

casks=(
  alfred
  adobe-reader
  airdroid
  dropbox
  firefox
  google-chrome
  flash
  github
  iterm2
  qlprettypatch
  betterzipql
  qlimagesize
  webpquicklook
  suspicious-package
  qlcolorcode
  qlmarkdown
  qlstephen
  quicklook-json
  quicklook-csv
  sublime-text
  jeromelebel-mongohub
  robomongo
  java
  skype
  slack
  spotify
  vlc
)

npms=(
  typescript
  gulp
  strongloop
)

set +e

if test ! $(which brew); then
  echo "Installing Xcode ..."
  xcode-select --install

  echo "Installing Homebrew ..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Updating Homebrew ..."
  brew update
  brew upgrade brew-cask
fi
brew doctor
brew tap homebrew/dupes






gem install sass

brew cask alfred link
