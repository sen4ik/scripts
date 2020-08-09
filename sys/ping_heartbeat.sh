#!/bin/bash
HOSTS="trucksite.com"
COUNT=5

for myHost in $HOSTS
do
  count=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
  if [ $count -eq 0 ]; then
    echo "Host : $myHost is down (ping failed) at $(date)"
  else
    echo "Host : $myHost is running (ping successful) at $(date)"
  fi
done
