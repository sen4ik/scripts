#!/bin/bash

source "list_of_users.sh"
source "../functions.sh"

checkIfPackageIsInstalled mysql
checkIfPackageIsInstalled mysqladmin

read -p "Provide MySQL user that will be used for database creation: " MYSQLUSER
read -s -p "Provide ${MYSQLUSER} password: " MYSQLPASS

pass=""
while true; do
    read -s -p "Enter default password for DB users: " password
    echo
    read -s -p "Password (again): " password2
    echo
    if [ "$password" = "$password2" ]; then
   		pass=$password2
    	break
    else
    	echo "Please try again"
    fi
done

for USER in "${USERS[@]}"
do
	DBNAME=${USER}_db
	# mysqladmin -u $MYSQLUSER -p create ${USER}_db
	mysqladmin --user=$MYSQLUSER --password=$MYSQLPASS create $DBNAME
	echo "${DBNAME} created"
	mysql --user=$MYSQLUSER --password=$MYSQLPASS --database=${DBNAME} < artur_sentsov_db.sql
	mysql --user=$MYSQLUSER --password=$MYSQLPASS --database=${DBNAME} -e "CREATE USER '${USER}'@'localhost' IDENTIFIED BY '${pass}'; GRANT ALL PRIVILEGES ON ${DBNAME} . * TO '${USER}'@'localhost'; FLUSH PRIVILEGES;"
	mysql --user=$MYSQLUSER --password=$MYSQLPASS --database=${DBNAME} -e "CREATE USER '${USER}'@'%' IDENTIFIED BY '${pass}'; GRANT ALL PRIVILEGES ON ${DBNAME} . * TO '${USER}'@'%'; FLUSH PRIVILEGES;"
done
