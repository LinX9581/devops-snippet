# java install
sudo apt-get update
sudo timedatectl set-timezone Asia/Taipei
sudo apt install wget net-tools -y

cd /usr
mkdir java
cd java
cp /home/ansible/java/jdk-8u311-linux-x64.tar.gz /usr/java
sudo tar -zxf jdk-8u311-linux-x64.tar.gz
sudo update-alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_311/bin/java 100

sudo update-alternatives --display java
sudo update-alternatives --config java

sed -i '1iexport JAVA_HOME=/usr/java/jdk1.8.0_311 \
export JRE_HOME=/usr/java/jdk1.8.0_311/jre \
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib \
export PATH=${PATH}:${JAVA_HOME}/bin:${JRE_HOME}/bin \
' ~/.bashrc
source ~/.bashrc

# tomcat install
cd /etc
mkdir tomcat
cd tomcat
cp /home/ansible/java/apache-tomcat-8.5.81.tar /etc/tomcat/
sudo tar -xvf apache-tomcat-8.5.81.tar
cd /opt
sudo ln -s /etc/tomcat/apache-tomcat-8.5.81 /opt/tomcat
sudo ln -s /etc/tomcat/apache-tomcat-8.5.81/bin/startup.sh /opt/
sudo ln -s /etc/tomcat/apache-tomcat-8.5.81/bin/shutdown.sh /opt/

mv /home/ansible/java/server.xml /opt/tomcat/conf/

cat>/opt/tomcat/bin/setenv.sh<<EOF
export JAVA_HOME=/usr/java/jdk1.8.0_311
export JRE_HOME=/usr/java/jdk1.8.0_311/jre
export JAVA_OPTS="-Xms256m -Xmx256m -Duser.timezone=Asia/Taipei"
export CATALINA_OPTS="-Duser.timezone=Asia/Taipei"
EOF

sh /opt/startup.sh

# tomcat setting
# cp /home/ansible/deploy/java/server.xml /opt/tomcat/conf/
# TOMCAT=8.5.81
# cat>/etc/systemd/system/tomcat.service<<EOF
# [Unit]
# Description=Tomcat 8 servlet container
# After=network.target

# [Service]
# Type=forking

# User=root
# Group=root

# ExecStart=/etc/tomcat/apache-tomcat-8.5.81/bin/startup.sh
# ExecStop=/etc/tomcat/apache-tomcat-8.5.81/bin/shutdown.sh

# [Install]
# WantedBy=multi-user.target
# EOF

# sudo systemctl daemon-reload
# sudo systemctl enable --now tomcat
# sudo systemctl restart tomcat