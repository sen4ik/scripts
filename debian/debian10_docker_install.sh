#!/bin/bash
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-debian-10
sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
if [ $? -eq 0 ]; then
    echo "*** docker-ce installed ***"
else
    echo "!!! Something didn't go as expected. Exiting. !!!"
    exit 1
fi

# add user to docker group so user can run docker command without sudo
sudo usermod -aG docker ${USER}

# check if user belongs to docker group
# groups $USER 

# docker compose install
# https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-debian-10
sudo curl -L https://github.com/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

sudo systemctl status docker
