#!/bin/bash

SOURCES=/etc/apt/sources.list
DEB="deb http://ftp.de.debian.org/debian testing main"
if ! grep -q $DEB "$SOURCES"; then
    echo $DEB | sudo tee -a $SOURCES > /dev/null
fi

sudo apt-get update
sudo apt-get -t testing install python3.7

# view installed python versions
# ls /usr/bin | grep python

# view default python
# ls -l /usr/bin/python

# Python 2.7 and 3.7 are installed. python3 is a symlink to 3.7.
# To set python 3.7 as default use the update-alternatives.
# The last number defines the priority. Higher number means higher priority.
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.7 2
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

# After setting more then one alternatives you can easily switch the version by
sudo update-alternatives --config python

sed '/$DEB/d' $SOURCES
sudo apt-get update
