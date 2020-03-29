#!/bin/bash

function checkIfPackageIsInstalled(){

	if [[ -z $1 ]] ; then
	    echo "USAGE: $0 packageName"
	    exit 1
	fi

	which $1 > /dev/null 2>&1
	if [ $? == 0 ]
		then
			echo "$1 is already installed. "
		else
			read -p "$1 is not installed. Answer yes/no if want installation_ " request
		if  [ $request == "yes" ]
			then
				sudo apt install -y $pkg
			fi
	fi
}