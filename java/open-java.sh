sudo apt update
sudo apt -y upgrade
sudo timedatectl set-timezone Asia/Taipei
sudo apt update
sudo apt install openjdk-8-jdk -y
sudo apt install git nginx net-tools -y
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
VERSION=8.5.81
wget https://www-eu.apache.org/dist/tomcat/tomcat-8/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz -P /tmp
sudo tar -xf /tmp/apache-tomcat-${VERSION}.tar.gz -C /opt/tomcat/
sudo ln -s /opt/tomcat/apache-tomcat-${VERSION} /opt/tomcat/latest
sudo chown -R tomcat: /opt/tomcat
sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'
cat>/etc/systemd/system/tomcat.service<<EOF
[Unit]
Description=Tomcat 8 servlet container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"

Environment="CATALINA_BASE=/opt/tomcat/latest"
Environment="CATALINA_HOME=/opt/tomcat/latest"
Environment="CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable --now tomcat
sudo systemctl restart tomcat