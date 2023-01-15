#!/bin/bash
# https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/generic-linux-install.html
wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - 
sudo add-apt-repository 'deb https://apt.corretto.aws stable main'
sudo apt-get update; sudo apt-get install -y java-17-amazon-corretto-jdk

java -version

sudo update-alternatives --config java
sudo update-alternatives --config javac
