#!/bin/bash
# sudo apt install -y openssh-server
SSHCONF=/etc/ssh/sshd_config
if [ -f "$SSHCONF" ]; then
    cat sshd_config | sudo tee $SSHCONF > /dev/null
else
    echo "Can't find $SSHCONF. Exiting."
    exit 1
fi

read -p "Enter desired port: " SSHPORT
sudo sed -i "s/55995/${SSHPORT}/g" $SSHCONF

read -p "Enter allowed user(s): " ALLOWED_USERS
sudo sed -i "s/ALLOWEDUSERSXXX/${ALLOWED_USERS}/g" $SSHCONF

sudo service ssh restart
sudo systemctl status ssh.service
