#!/bin/bash
sudo apt install -y vim curl

# Get https://github.com/VundleVim/Vundle.vim
if [ ! -d "~/.vim" ]; then
  mkdir ~/.vim
fi
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

if [ ! -f ~/.vimrc ]; then
    cat vimrc > ~/.vimrc
else
    echo ".vimrc already exists. I wont modify it."
fi

echo "Run vim and do :PluginInstall"
