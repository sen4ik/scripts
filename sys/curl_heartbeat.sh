#!/bin/bash
curl -Isf http://www.trucksite.com | head -n 1

curl -Is https://www.trucksite.com | head -n 1

curl https://www.trucksite.com -k -s -f -o /dev/null && echo "SUCCESS" || echo "ERROR"
