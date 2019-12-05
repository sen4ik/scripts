#!/bin/bash
FILE=nordvpn-release_1.0.0_all.deb
sudo wget -qnc https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/$FILE
sudo dpkg -i $FILE
sudo apt update -y
sudo apt install -y nordvpn
# In case you get the GPG error (NO_PUBKEY), use the following command and repeat step 4:
# sudo wget https://repo.nordvpn.com/gpg/nordvpn_public.asc -O - | sudo apt-key add -

nordvpn login
nordvpn connect

rm -f $FILE
