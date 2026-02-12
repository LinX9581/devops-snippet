sudo sudo

cd /etc/tomcat

wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.78/bin/apache-tomcat-8.5.78.tar.gz

tar zxvf apache-tomcat-8.5.78.tar.gz

cd /etc/tomcat/apache-tomcat-8.5.78/conf

cp -r /etc/tomcat/apache-tomcat-8.5.50/conf/server.xml /etc/tomcat/apache-tomcat-8.5.78/conf

cp -r /etc/tomcat/apache-tomcat-8.5.78/webapps/ /etc/tomcat/apache-tomcat-8.5.78/webapps_default

rm -rf /etc/tomcat/apache-tomcat-8.5.78/webapps/*

cp -r /etc/tomcat/apache-tomcat-8.5.50/webapps/ /etc/tomcat/apache-tomcat-8.5.78/

cp -r /etc/tomcat/apache-tomcat-8.5.50/bin/setenv.sh /etc/tomcat/apache-tomcat-8.5.78/bin/

sudo ln -s /etc/tomcat/apache-tomcat-8.5.78 /opt/tomcat

sudo ln -s /etc/tomcat/apache-tomcat-8.5.78/bin/startup.sh /opt/

sudo ln -s /etc/tomcat/apache-tomcat-8.5.78/bin/shutdown.sh /opt/