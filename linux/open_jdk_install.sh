#!/bin/bash
sudo apt install -y default-jre
java -version
sudo apt install -y default-jdk
javac -version

ENV=/etc/environment
if [ ! -f "$ENV" ]; then
  touch $ENV
fi

# https://serverfault.com/questions/143786/how-to-determine-java-home-on-debian-ubuntu
# JRELOC=$(readlink -f /usr/bin/java | sed "s:bin/java::")
JDKLOC=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
echo -e "JAVA_HOME=\x27${JDKLOC}/\x27" | sudo tee $ENV > /dev/null
source $ENV
echo $JAVA_HOME
