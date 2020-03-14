#!/bin/bash

sudo apt-get install -y certbot python-certbot-nginx

read -p "Enter domain (without www. prefix): " DOMAIN
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN

# Verifying certbot auto-renewal
sudo certbot renew --dry-run
RESULT=$?
if [ ! $RESULT -eq 0 ]; then
  echo "certbot renew dry-run failed. Existing."
  exit 1
fi

# Schedule certs renewal
(crontab -l ; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
