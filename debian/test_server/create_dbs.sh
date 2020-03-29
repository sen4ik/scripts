#!/bin/bash

source "list_of_users.sh"
source "../functions.sh"

checkIfPackageIsInstalled mysql
checkIfPackageIsInstalled mysqladmin

read -p "Provide MySQL user: " MYSQLUSER
read -p "Provide ${MYSQLUSER} password: " MYSQLPASS

for USER in "${USERS[@]}"
do
	DBNAME=${USER}_db
	# mysqladmin -u $MYSQLUSER -p create ${USER}_db
	mysqladmin --user=$MYSQLUSER --password=$MYSQLPASS create $DBNAME
	echo "${DBNAME} created"
	mysql --user=$MYSQLUSER --password=$MYSQLPASS --database=${DBNAME} < artur_sentsov_db.sql
	mysql --user=$MYSQLUSER --password=$MYSQLPASS --database=${DBNAME} -e "CREATE USER '${USER}'@'localhost' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON ${DBNAME} . * TO '${USER}'@'localhost'; FLUSH PRIVILEGES;"
	mysql --user=$MYSQLUSER --password=$MYSQLPASS --database=${DBNAME} -e "CREATE USER '${USER}'@'%' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON ${DBNAME} . * TO '${USER}'@'%'; FLUSH PRIVILEGES;"
done
