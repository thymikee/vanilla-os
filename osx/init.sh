#!/usr/bin/env bash
CURRENT_DIR=$(pwd)
export CURRENT_DIR

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Update system
if [ ! -f .step0 ]; then
  echo "Updating system..."
  sudo softwareupdate -i -a
  touch .step0
  echo "Restart is required, press Enter"
  read -r
  sudo reboot
fi

# Enable TRIM
if [ ! -f .step1 ]; then
  echo "Installing TRIM Enabler..."
  curl -L -o packages/TrimEnabler.dmg https://www.dropbox.com/s/r1z1vt8xy1qey9h/TrimEnabler.dmg
  hdiutil mount packages/TrimEnabler.dmg
  cp -r "/Volumes/Trim Enabler/Trim Enabler.app" /Applications
  hdiutil unmount "/Volumes/Trim Enabler/Trim Enabler.app"
  echo "Please enable TRIM and press Enter to restart your Mac"
  open "/Applications/Trim Enabler.app"
  read -r
  touch .step1
  sudo reboot
fi

# Enable OSX developer extensions
if [ ! -f .step2 ]; then
  echo "Installing XCode Command Line Tools, press ENTER when done"
  xcode-select --install > /dev/null 2>&1
  read -r
  touch .step2
fi

# Install developer shell extensions
if [ ! -f .step3 ]; then
  echo "Installing oh-my-zsh and it's plugins..."
  curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap Homebrew/bundle
  brew update
  brew upgrade
  brew bundle
  brew cleanup

  echo "Installing nvm..."
  rm -rf ~/.nvm
  curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  # shellcheck disable=SC1091
  # shellcheck source=~/.nvm/nvm.sh
  [ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"
  nvm install stable
  nvm alias default stable
  nvm use stable

  echo "Installing rvm..."
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  rm -rf ~/.rvm
  curl -sSL https://get.rvm.io | bash
  # shellcheck disable=SC1091
  source ~/.rvm/scripts/rvm

  echo "Installing dotfiles..."
  rm -rf ~/.ackrc ~/.aliases ~/.exports ~/.extra ~/.fun ~/.functions ~/.gitconfig ~/.gitignore ~/.inputrc ~/.osx ~/.profile.osx.d ~/.screenrc ~/.tmux.conf ~/.vim ~/.vimrc ~/.zshrc ~/.dotfiles
  git clone https://github.com/ajgon/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles || exit
  /bin/zsh -c './bootstrap --new-setup'
  cd "${CURRENT_DIR}" || exit
  vim +NeoBundleInstall +qall

  touch .step3
fi

# Install apps
if [ ! -f .step4 ]; then
  echo "Installing Alfred..."
  curl -L -o packages/alfred2.zip https://www.dropbox.com/s/humo6ewd7ylj2es/alfred2.zip
  unzip packages/alfred2.zip -d packages
  cp -r "packages/Alfred 2.app" /Applications/
  # Disable spotlight GUI (without indexing)
  sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
  echo "Change Alfred 2 shortcut, enable clipboard history, activate powerpack and press Enter"
  open "/Applications/Alfred 2.app"
  read -r

  echo "Installing AirDroid"
  curl -L -o packages/AirDroid.dmg https://www.dropbox.com/s/vd98t4dof399sez/AirDroid.dmg
  hdiutil mount "packages/AirDroid.dmg"
  cp -R /Volumes/AirDroid/AirDroid.app /Applications
  hdiutil unmount /Volumes/AirDroid

  echo "Installing Google Chrome..."
  curl -L -o packages/googlechrome.dmg https://www.dropbox.com/s/5we7xp1szgw5ioq/googlechrome.dmg
  hdiutil mount "packages/googlechrome.dmg"
  cp -R "/Volumes/Google Chrome/Google Chrome.app" /Applications/
  hdiutil unmount "/Volumes/Google Chrome"

  echo "Installing Firefox..."
  curl -L -o packages/Firefox.dmg https://www.dropbox.com/s/xpf9l69tlmx0zmi/Firefox.dmg
  hdiutil mount "packages/Firefox.dmg"
  cp -R /Volumes/Firefox/Firefox.app /Applications
  hdiutil unmount /Volumes/Firefox

  echo "Installing Gimp..."
  curl -L -o packages/Gimp.dmg https://www.dropbox.com/s/l9r5zegx0p1oxpz/Gimp.dmg
  hdiutil mount "packages/Gimp.dmg"
  cp -R /Volumes/Gimp*/GIMP.app /Applications
  hdiutil unmount /Volumes/Gimp*

  echo "Installing iTerm2..."
  curl -L -o packages/iTerm2.zip https://www.dropbox.com/s/5urdahw84k96ygf/iTerm2.zip
  unzip packages/iTerm2.zip -d packages
  cp -R packages/iTerm.app /Applications

  echo "Installing ownCloud..."
  curl -L -o packages/ownCloud.pkg https://www.dropbox.com/s/k1cjbb2syw1g7z3/ownCloud.pkg
  sudo installer -pkg packages/ownCloud.pkg -target /

  echo "Installing skype..."
  curl -L -o packages/skype.dmg https://www.dropbox.com/s/mmypvqe20twf01x/skype.dmg
  hdiutil mount "packages/skype.dmg"
  cp -R /Volumes/Skype/Skype.app /Applications
  hdiutil unmount /Volumes/Skype

  echo "Installing Toggl..."
  curl -L -o packages/Toggl.dmg https://www.dropbox.com/s/7bbk9cmqqx02h20/Toggl.dmg
  hdiutil mount "packages/Toggl.dmg"
  cp -R /Volumes/TogglDesktop/TogglDesktop.app /Applications
  hdiutil unmount /Volumes/TogglDesktop

  echo "Installing Spotify..."
  curl -L -o packages/Spotify.zip https://www.dropbox.com/s/l1b9eia3sb3lrxu/Spotify.zip
  unzip packages/Spotify.zip -d packages
  open "packages/Install Spotify.app"

  echo "Installing Tunnelblick..."
  curl -L -o packages/Tunnelblick.dmg https://www.dropbox.com/s/05sfv0pja3vl9d5/Tunnelblick.dmg
  hdiutil mount "packages/Tunnelblick.dmg"
  cp -R /Volumes/Tunnelblick/Tunnelblick.app /Applications
  hdiutil unmount "/Volumes/Tunnelblick"

  echo "Installing Sublime Text 3..."
  curl -L -o packages/Sublime.dmg https://www.dropbox.com/s/7e3key50blljy50/Sublime.dmg
  hdiutil mount "packages/Sublime.dmg"
  cp -R "/Volumes/Sublime Text/Sublime Text.app" /Applications
  hdiutil unmount "/Volumes/Sublime Text"
  mkdir -p "${HOME}/Library/Application Support/Sublime Text 3/Installed Packages"
  mkdir -p "${HOME}/Library/Application Support/Sublime Text 3/Packages/User"
  curl -L -o "${HOME}/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package" "https://sublime.wbond.net/Package%20Control.sublime-package"
  cp "settings/Package Control.sublime-settings" "${HOME}/Library/Application Support/Sublime Text 3/Packages/User"
  open "/Applications/Sublime Text.app"
  echo "Allow Sublime Text to install all packages, then quit it"
  cp "settings/Preferences.sublime-settings" "${HOME}/Library/Application Support/Sublime Text 3/Packages/User/"

  # App Store
  for app in divvy todoist 1Password ReadKit "Tube Controller" Sip CleanMyDrive "The Unarchiver" Twitter; do
    echo "Install ${app} from appStore and press Enter"
    read -r
  done

  touch .step4
fi

# Customizing the environment
if [ ! -f .step5 ]; then
  # Hide all app icons, except the active ones
  defaults write com.apple.dock persistent-apps -array
  defaults write com.apple.dock static-only -bool TRUE

  # Show hidden apps
  defaults write com.apple.dock showhidden -bool TRUE

  # Don’t automatically rearrange Spaces based on most recent use
  defaults write com.apple.dock mru-spaces -bool false

  # Remove the auto-hiding Dock delay
  defaults write com.apple.dock autohide-delay -float 0

  # Remove the animation when hiding/showing the Dock
  defaults write com.apple.dock autohide-time-modifier -float 0

  # Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool true

  # Increase sound quality for Bluetooth headphones/headsets
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

  # Enable right click on mouse
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton

  # Enable Smart Zoom
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseOneFingerDoubleTapGesture 1

  # Enable Tap to click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Enable Three Finger Drag
  defaults write com.apple.AppleMultitouchTrackpad.TrackpadThreeFingerDrag 1
  defaults write com.apple.AppleMultitouchTrackpad.TrackpadThreeFingerHorizSwipeGesture 0
  defaults write com.apple.AppleMultitouchTrackpad.TrackpadThreeFingerVertSwipeGesture 0
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag 1
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture 0
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture 0

  # Trackpad: map bottom right corner to right-click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
  defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
  defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

  # Enable full keyboard access for all controls
  # (e.g. enable Tab in modal dialogs)
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  # Disable press-and-hold for keys in favor of key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  # Set a blazingly fast keyboard repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 0

  # Set the timezone; see `systemsetup -listtimezones` for other values
  systemsetup -settimezone "Europe/Warsaw" > /dev/null

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  # Use list view in all Finder windows by default
  # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  # Empty Trash securely by default
  defaults write com.apple.finder EmptyTrashSecurely -bool true

  # Show the ~/Library folder
  chflags nohidden ~/Library

  # Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
  defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9"

  # Disable automatic spell checking
  defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

  # Prevent Time Machine from prompting to use new hard drives as backup volume
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

  # Disable local Time Machine backups
  hash tmutil &> /dev/null && sudo tmutil disablelocal

  # Don’t display the annoying prompt when quitting iTerm
  defaults write com.googlecode.iterm2 PromptOnQuit -bool false

  # Set default directory for preferences before setting them
  defaults write com.googlecode.iterm2 NSNavLastRootDirectory -string "$HOME/Library/Preferences"

  # Set default preferences
  cp settings/Preferences/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
  plutil -convert binary1 ~/Library/Preferences/com.googlecode.iterm2.plist

  # Configure divvy
  defaults write com.mizage.divvy globalHotkey '{ "keyCode" = 49; "modifiers" = 768;  }'
  defaults write com.mizage.divvy shortcuts '<62706c69 73743030 d4010203 0405085d 5e542474 6f705824 6f626a65 63747358 24766572 73696f6e 59246172 63686976 6572d106 0754726f 6f748001 ae090a14 2b2c333c 3d46474f 50585955 246e756c 6cd20b0c 0d0e5624 636c6173 735a4e53 2e6f626a 65637473 800da50f 10111213 80028005 80078009 800bdd15 16171819 1a1b1c1d 1e1f200b 21222324 25222627 28242126 2a5f1012 73656c65 6374696f 6e456e64 436f6c75 6d6e5f10 1173656c 65637469 6f6e5374 61727452 6f775c6b 6579436f 6d626f43 6f646557 656e6162 6c65645d 6b657943 6f6d626f 466c6167 735f1014 73656c65 6374696f 6e537461 7274436f 6c756d6e 5b73697a 65436f6c 756d6e73 5a737562 64697669 64656457 6e616d65 4b657956 676c6f62 616c5f10 0f73656c 65637469 6f6e456e 64526f77 5873697a 65526f77 73100510 00103109 12001c00 00100608 80030980 04544675 6c6cd22d 2e2f3258 24636c61 73736573 5a24636c 6173736e 616d65a2 30315853 686f7274 63757458 4e534f62 6a656374 5853686f 72746375 74dd1516 1718191a 1b1c1d1e 1f200b34 22352437 22262739 2421262a 1002107b 0912009c 00000880 06098004 544c6566 74dd1516 1718191a 1b1c1d1e 1f200b21 223e2440 41262743 2421262a 107c0912 009c0000 10030880 08098004 55526967 6874dd15 16171819 1a1b1c1d 1e1f200b 21224824 4a222627 4c243426 2a107e09 12009c00 0008800a 09800453 546f70dd 15161718 191a1b1c 1d1e1f20 0b214151 24532226 27552421 262a107d 0912009c 00000880 0c098004 56426f74 746f6dd2 2d2e5a5b a35b5c31 5e4e534d 75746162 6c654172 72617957 4e534172 72617912 000186a0 5f100f4e 534b6579 65644172 63686976 65720008 00110016 001f0028 00320035 003a003c 004b0051 0056005d 0068006a 00700072 00740076 0078007a 009500aa 00be00cb 00d300e1 00f80104 010f0117 011e0130 0139013b 013d013f 01400145 01470148 014a014b 014d0152 01570160 016b016e 01770180 018901a4 01a601a8 01a901ae 01af01b1 01b201b4 01b901d4 01d601d7 01dc01de 01df01e1 01e201e4 01ea0205 02070208 020d020e 02100211 02130217 02320234 0235023a 023b023d 023e0240 0247024c 0250025f 0267026c 00000000 00000201 00000000 0000005f 00000000 00000000 00000000 0000027e>'
  defaults write com.mizage.divvy showMenuIcon 0
  defaults write com.mizage.divvy useGlobalHotkey 1
  for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "Dock" \
    "Finder" "Mail" "Messages" "Safari" "SizeUp" "SystemUIServer" \
    "Transmission" "Twitter" "iCal"; do
    killall "${app}" > /dev/null 2>&1
  done

  touch .step5
  echo "Restart is required, press Enter"
  read -r
  sudo reboot
fi
