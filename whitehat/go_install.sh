#!/bin/bash
PROFILE=~/.profile

# install go and add it to path
GO_VERSION=1.13.4
GO_ARCHIVE=go$GO_VERSION.linux-amd64.tar.gz
curl -O https://dl.google.com/go/$GO_ARCHIVE
tar xvf $GO_ARCHIVE

sudo chown -R root:root ./go
sudo mv go /usr/local

rm $GO_ARCHIVE
if [ ! -d "$HOME/go" ]; then
  mkdir $HOME/go
fi

echo -e '\nexport GOPATH=$HOME/go\nexport PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' | tee -a $PROFILE
source $PROFILE