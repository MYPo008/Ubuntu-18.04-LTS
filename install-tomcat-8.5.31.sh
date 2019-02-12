#!/bin/bash
# For More Info http://clivern.com/how-to-install-apache-tomcat-8-on-ubuntu-16-04

sudo apt-get update
sudo apt-get install curl
sudo apt-get install unzip
cd /opt
curl -O http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.zip
sudo unzip apache-tomcat-8.5.31.zip
sudo mv apache-tomcat-8.5.31 tomcat
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chown -R tomcat /opt/tomcat
sudo chmod -R 755 /opt/tomcat
sudo echo "[Unit]
Description=Apache Tomcat Web Server
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
#Uncomment to set up OPDWeb variable. The path must be the directory of the file OPDWeb.properties.
#Environment=OPDWeb=/home/username/OPD_Web
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=15
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/tomcat.service
sudo sed -i '$ i\<role rolename="manager-gui" />' /opt/tomcat/conf/tomcat-users.xml
sudo sed -i '$ i\<user username="admin" password="admin" roles="manager-gui" />' /opt/tomcat/conf/tomcat-users.xml
sudo sed -i 's/52428800/104857600/' /opt/tomcat/webapps/manager/WEB-INF/web.xml
sudo perl -i -0pe 's/privileged="true" >/privileged="true" >\n<!--/' /opt/tomcat/webapps/manager/META-INF/context.xml
sudo perl -i -0pe 's/:0:0:0:0:0:0:1" \/>/:0:0:0:0:0:0:1" \/>\n-->/' /opt/tomcat/webapps/manager/META-INF/context.xml
sudo ufw allow 8080
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl status tomcat