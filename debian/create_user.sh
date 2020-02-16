#!/bin/bash

if [ ! $(id -u) -eq 0 ]; then
    echo "Only root may add a user to the system"
    exit 2
fi

read -p "Enter username: " USER_TO_CREATE
egrep "^$USER_TO_CREATE" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
    echo "$USER_TO_CREATE already exists! Exiting."
    exit 1
fi

read -s -p "Enter password: " password
pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)

# add user
useradd -m -c "$USER_TO_CREATE" -p $pass -s /bin/bash $USER_TO_CREATE

# add user to sudoers
echo -e "$USER_TO_CREATE  ALL=(ALL:ALL) ALL" | tee -a /etc/sudoers > /dev/null

SSH_DIR=/home/$USER_TO_CREATE/.ssh
AUTHORIZED_KEY=$SSH_DIR/authorized_keys
SSH_CONFIG=$SSH_DIR/config

mkdir $SSH_DIR
touch $AUTHORIZED_KEY
touch $SSH_CONFIG

echo -e 'Host *\n    ServerAliveInterval 120\n    ServerAliveCountMax 2' | tee $SSH_CONFIG > /dev/null
echo ""

read -p "Do you want to add public key (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        read -p "Paste your public key: " PUBLIC_KEY
		echo $PUBLIC_KEY > $AUTHORIZED_KEY
    ;;
    * )
        echo ""
    ;;
esac

chmod 700 $SSH_DIR
chmod 644 $AUTHORIZED_KEY
chmod 644 $SSH_CONFIG

chown -R $USER_TO_CREATE $SSH_DIR
chgrp -R $USER_TO_CREATE $SSH_DIR

echo "Following user is created:"
egrep "^$USER_TO_CREATE" /etc/passwd

su $USER_TO_CREATE
