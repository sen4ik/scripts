#!/bin/bash
# https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-debian-9

# sudo apt install -y software-properties-common dirmngr

echo "deb http://deb.debian.org/debian stretch-backports main contrib non-free" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian stretch-backports main contrib non-free" | sudo tee -a /etc/apt/sources.list

sudo apt update
sudo apt install -y python-certbot-nginx -t stretch-backports

read -p "Enter domain (without www. prefix): " DOMAIN
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN

# Below packages are needed for certbot renew to work
sudo apt install -y python-acme
sudo apt install -y --only-upgrade python3-acme

# Verifying certbot auto-renewal
sudo certbot renew --dry-run
RESULT=$?
if [ ! $RESULT -eq 0 ]; then
  echo "certbot renew dry-run failed. Existing."
  exit 1
fi

# Schedule certs renewal
(crontab -l ; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
