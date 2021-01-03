#!/bin/bash

# Kudos To: https://gist.github.com/anthonygtellez/394d234bc75e39c3473ef4f7749bfcf1
#     https://gist.github.com/waako/11559842
#     https://gist.github.com/xdavidhu/07457247b9087dea4ddaf52858500cce

while read domain
do
  IPs=`dig +short $domain | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"| tr '\n' ,`

  # get list of nameservers
  # ns=`dig ns $domain +short| sort | tr '\n' ','`
  # use the line below to extract any information from whois
  # ns=`whois $domain | grep "Name Server" | cut -d ":" -f 2 |  sed 's/ //' | sed -e :a -e '$!N;s/ \n/,/;ta'`

  if [ ! -z "${IPs}" ]; then
    echo -e "$domain||$IPs" | tee -a ips
  fi

done < domains # Defines the text file from which to read domain names
