#!/bin/bash

xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew analytics off
# export HOMEBREW_NO_ANALYTICS=1

brew install python@3.10 pyenv

brew install openjdk@8

brew install automake findutils coreutils autoconf

brew install nano awk htop wget curl nmap tmux watch tree maven ccat bat

brew install --cask grammarly google-chrome firefox vlc keepassxc tunnelblick audacity balenaetcher istat-menus vnc-viewer caffeine rectangle-pro

brew install --cask intellij-idea sublime-text postman dbeaver-community docker iterm2 figma

brew install --cask slack telegram viber discord

brew install --cask kindle google-drive adobe-acrobat-reader microsoft-remote-desktop

brew install git
# brew install --cask sourcetree

brew install youtube-dl

brew install p7zip exa

brew install --cask wsjtx gridtracker fldigi chirp

brew install node@16 yarn nvm

# brew install --cask virtualbox
# brew install --cask libreoffice
# brew install ffmpeg flac
# brew install --cask burp-suite
# brew install --cask anydesk # team viewer alternative
# brew install --cask coconutbattery
# brew install --cask handshaker

brew install allure openapi-generator
brew install --cask appium appium-inspector
