#!/bin/bash

function checkIfPackageIsInstalled(){

	if [[ -z $1 ]] ; then
	    echo "USAGE: $0 packageName"
	    exit 1
	fi

	which $1 > /dev/null 2>&1
	if [ $? == 0 ]
		then
			echo
		else
			echo "$1 is NOT installed"
			exit 2;
	fi
}