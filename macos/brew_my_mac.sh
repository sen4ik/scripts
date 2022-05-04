#!/bin/bash

xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew analytics off
# export HOMEBREW_NO_ANALYTICS=1

brew install python@3.10

brew install openjdk@8

brew install --cask grammarly google-chrome firefox vlc keepassxc tunnelblick audacity balenaetcher istat-menus vnc-viewer

brew install --cask intellij-idea sublime-text postman dbeaver-community docker iterm2 figma

brew install --cask slack telegram viber discord

brew install --cask kindle google-drive

brew install nano awk htop wget curl nmap tmux watch tree maven ccat bat

brew install git

brew install youtube-dl

brew install p7zip exa

brew install --cask wsjtx gridtracker fldigi chirp

# brew install libreoffice
# brew install ffmpeg
# brew install findutils coreutils

brew install allure
