#!/bin/bash
PROFILE=~/.profile

# get some goodies from tomnomnom
go get -u github.com/tomnomnom/assetfinder

go get -u github.com/tomnomnom/gf
echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> $PROFILE
source $PROFILE
cp -r $GOPATH/src/github.com/tomnomnom/gf/examples ~/.gf

go get -u github.com/tomnomnom/meg
go get -u github.com/tomnomnom/httprobe
go get -u github.com/tomnomnom/gron
go get github.com/tomnomnom/waybackurls
go get -u github.com/tomnomnom/unfurl
go get -u github.com/tomnomnom/hacks/html-tool
go get -u github.com/m4ll0k/Aron
go get -u github.com/ffuf/ffuf