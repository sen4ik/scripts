#!/bin/bash
FILE=mysql-apt-config_0.8.14-1_all.deb
wget http://repo.mysql.com/$FILE
sudo dpkg -i $FILE
sudo apt update 
sudo apt install -y mysql-server
rm -f $FILE
sudo apt install -y libmysqlclient-dev
