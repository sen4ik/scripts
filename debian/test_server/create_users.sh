#!/bin/bash

source "list_of_users.sh"

if [ ! $(id -u) -eq 0 ]; then
    echo "Only root may add a user to the system"
    exit 2
fi

read -p "Do you want to add multiple users (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        echo ""
    ;;
    * )
        exit 2
    ;;
esac

read -s -p "Enter default password: " pass
PASSWORD=$(perl -e 'print crypt($ARGV[0], "password")' $pass)

# USERS=("testUser1" "testUser3" "testUser3" "testUser4")

for USER in "${USERS[@]}"
do

	egrep "^$USER" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
	    echo "$USER already exists! Exiting."
	    exit 1
	fi

	# add user
	useradd -m -c "$USER" -p $PASSWORD -s /bin/bash $USER

	echo "Following user is created:"
	egrep "^$USER" /etc/passwd

done
