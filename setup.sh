#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Set standby delay to 24 hours (default is 1 hour)
# sudo pmset -a standbydelay 86400

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable smart quotes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Finder: allow quitting via âŒ˜ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true && killall Finder

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you donâ€™t use
# the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array

# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

# Disable autocorrect 
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

brew tap homebrew/science

brews=(
  android-sdk
  brew-cask
  cmake
  git
  gcc
  jpeg
  libpng
  libtiff
  r
  git-extras
  eigen
  tbb
  heroku-toolbelt
  nvm
  mysql
  mongodb
  openexr
  python
  python3
  pkg-config
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
  java
  jeromelebel-mongohub
  qlprettypatch
  betterzipql
  Caskroom/cask/xquartz
  qlimagesize
  webpquicklook
  suspicious-package
  sublime-text3
  qlcolorcode
  qlmarkdown
  qlstephen
  quicklook-json
  quicklook-csv
  robomongo
  caskroom/homebrew-cask/mongochef
  skype
  slack
  spotify
  vlc
  java
  jeromelebel-mongohub
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

fails=()

function print_red {
  red='\x1B[0;31m'
  NC='\x1B[0m' # no color
  echo -e "${red}$1${NC}"
}

function install {
  cmd=$1
  shift
  for pkg in $@;
  do
    exec="$cmd $pkg"
    echo "Executing: $exec"
    if $exec ; then
      echo "Installed $pkg"
    else
      fails+=($pkg)
      print_red "Failed to execute: $exec"
    fi
  done
}

install 'brew install' ${brews[@]}
install 'brew cask install --appdir="/Applications"' ${casks[@]}

nvm install stable
nvm use stable
nvm alias default stable

npm update npm -g

install 'npm install -g' ${npms[@]}

gem install sass
brew cask alfred link
brew cleanup
brew cask cleanup
brew linkapps

for fail in ${fails[@]}
do
  echo "Failed to install: $fail"
done

# Allow installing user scripts via GitHub Gist or Userscripts.org
defaults write com.google.Chrome ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"

pip install numpy scikit-learn
