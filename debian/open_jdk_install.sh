#!/bin/bash
sudo apt install -y default-jre
java -version
sudo apt install -y default-jdk
javac -version

ENV=/etc/environment
if [ ! -f "$ENV" ]; then
  touch $ENV
fi

echo -e 'JAVA_HOME=\x27/usr/lib/jvm/java-8-openjdk-amd64/jre\x27' | sudo tee $ENV > /dev/null
source $ENV
echo $JAVA_HOME
