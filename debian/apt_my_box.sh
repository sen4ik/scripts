#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y findutils lsof sudo gnupg bash htop nano vim net-tools curl wget rsync openssh-server ca-certificates tmux git tree dirmngr unzip apt-transport-https ca-certificates gnupg2 software-properties-common

read -p "Do you want to install locate (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        sudo apt install -y locate
		# update db for locate 
		sudo updatedb
    ;;
    * )
        echo ""
    ;;
esac
