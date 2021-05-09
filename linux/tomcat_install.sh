#!/bin/bash
# https://www.digitalocean.com/community/tutorials/how-to-install-apache-tomcat-9-on-debian-10

JH=$(echo $JAVA_HOME)
if [ -z "$JH" ]
then
    echo "JAVA_HOME is empty. Please fix this before proceeding."
    exit 1
fi

sudo apt install curl -y

url=https://downloads.apache.org/tomcat/tomcat-9/v9.0.33/bin/apache-tomcat-9.0.33.tar.gz
if curl --output /dev/null --silent --head --fail "$url"; then
  echo "URL exists: $url"
else
  echo "URL does not exist: $url"
  echo "Please provide another URL to download tomcat"
  exit 1
fi

# Create Tomcat User
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

# Install Tomcat
cd /tmp
curl -O $url

sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1

# Permissions
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/

# Create a systemd Service File
sudo sed -i "s/XXXXXX/${JH}/g" tomcat.service
cat tomcat.service | sudo tee /etc/systemd/system/tomcat.service > /dev/null

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl status tomcat
sudo systemctl enable tomcat

# Configure Tomcat Web Management Interface
read -p "Do you want to configure Tomcat Web Management Interface (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        read -p "Enter desired username: " USERNAME
		sudo sed -i "s/UUUUUU/${USERNAME}/g" tomcat-users.xml
		read -s -p "Enter desired password: " PASSWORD
		sudo sed -i "s/PPPPPP/${PASSWORD}/g" tomcat-users.xml
    ;;
    * )
        echo ""
    ;;
esac
cat tomcat-users.xml | sudo tee /opt/tomcat/conf/tomcat-users.xml > /dev/null

MANAGER_APP=/opt/tomcat/webapps/manager/META-INF/context.xml
HOST_MANAGER_APP=/opt/tomcat/webapps/host-manager/META-INF/context.xml
echo "Edit following files: ${MANAGER_APP}, ${HOST_MANAGER_APP}";
echo "Comment out following from above files: <Valve className=\"org.apache.catalina.valves.RemoteAddrValve\" allow=\"127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1\" />"
sleep 3;
sudo nano $MANAGER_APP
sudo nano $HOST_MANAGER_APP
sudo systemctl restart tomcat

echo "Don't forget to adjust firewall if needed!"
echo "Hit http://server_domain_or_IP:8080 to access web Interface"