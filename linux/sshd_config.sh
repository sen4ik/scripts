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

read -p "Do you want to set allowed users (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        read -p "Enter allowed user(s): " ALLOWED_USERS
		sudo sed -i "s/ALLOWEDUSERSXXX/${ALLOWED_USERS}/g" $SSHCONF
    ;;
    * )
        sed -i.bak '/AllowUsers/d' $SSHCONF
    ;;
esac

read -p "Do you want to allow password authentication (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        sed -i.bak '/PasswordAuthentication/d' $SSHCONF
        sed -i.bak 's:PasswordAuthentication no:PasswordAuthentication yes:g' $SSHCONF
    ;;
    * )
        echo
    ;;
esac

sudo service ssh restart
sudo systemctl status ssh.service
