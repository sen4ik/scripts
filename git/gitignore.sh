#!/bin/bash

GIT_IGNORE_GLOBAL=~/.gitignore_global

if [ ! -f $GIT_IGNORE_GLOBAL ]; then
    touch $GIT_IGNORE_GLOBAL
fi

echo ".DS_Store" >> $GIT_IGNORE_GLOBAL
echo "._.DS_Store" >> $GIT_IGNORE_GLOBAL
echo "**/.DS_Store" >> $GIT_IGNORE_GLOBAL
echo "**/._.DS_Store" >> $GIT_IGNORE_GLOBAL
echo "HELP.md" >> $GIT_IGNORE_GLOBAL
echo "target/" >> $GIT_IGNORE_GLOBAL
echo ".idea" >> $GIT_IGNORE_GLOBAL

git config --global core.excludesfile $GIT_IGNORE_GLOBAL
