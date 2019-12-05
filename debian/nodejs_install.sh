#!/bin/bash
sudo apt install -y python-dev build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev zlib1g-dev
sudo apt install -y nodejs npm
sudo chown -R $USER /usr/local
curl https://www.npmjs.com/install.sh | sudo sh
