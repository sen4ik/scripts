#!/bin/bash

source "list_of_users.sh"

read -p "Provide mysql user: " MYSQLUSER
read -p "Provide ${MYSQLUSER} password: " MYSQLPASS

for USER in "${USERS[@]}"
do
	mysqladmin -u $MYSQLUSER -p $MYSQLPASS create ${USER}_db
	echo "${USER}_db created"
	mysql -u $MYSQLUSER -p $MYSQLPASS ${USER}_db < artur_sentsov_db.sql
done
