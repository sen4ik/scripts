#!/bin/bash

read -p "Are you sure you want to remove mysql and all its configs(y/n)? " answer
case ${answer:0:1} in
    y|Y )
        sudo apt-get remove --purge mysql-server mysql-client mysql-common -y
		sudo apt-get autoremove -y
		sudo apt-get autoclean
		rm -rf /etc/mysql
		# sudo find / -iname 'mysql*' -exec rm -rf {} \;
        echo "following files with mysql prefix exist in the system:"
        sudo find / -iname 'mysql*'
    ;;
    * )
        echo ""
    ;;
esac
